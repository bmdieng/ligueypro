import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';

class ProfessionalPage extends StatefulWidget {
  const ProfessionalPage({super.key, required this.id});
  final String id;

  @override
  State<ProfessionalPage> createState() => _ProfessionalPageState();
}

class _ProfessionalPageState extends State<ProfessionalPage> {
  final TextEditingController _reviewController = TextEditingController();
  double _selectedRating = 0;
  double _averageRating = 4.8;
  int _reviewsCount = 127;
  String _professionalName = '';
  String _location = 'Sacré-Cœur, Dakar';
  String _price = 'À partir de 5 000 FCFA';
  String _phone = '+221 77 123 45 67';
  String _service = 'Service';
  String _responseTime = 'Répond en 10 min';
  int _completedJobs = 124;
  bool _verified = true;
  bool _availableNow = true;
  bool _subscribed = false;
  String _subscriptionPlan = 'none';
  DatabaseReference? _professionalRef;
  bool _isLoading = true;

  static const Map<String, Map<String, Object>> _fallbackProfessionals = {
    'fallback_pro_1': {
      'name': 'Mamadou Diop',
      'service': 'Climatisation',
      'location': 'Yoff, Dakar',
      'price': '18 000 FCFA',
      'phone': '+221 77 000 00 01',
      'responseTime': 'Répond en 10 min',
      'completedJobs': 148,
      'verified': true,
      'availableNow': true,
      'subscribed': true,
      'subscriptionPlan': 'pro',
      'ratingAverage': 4.8,
      'reviewsCount': 127,
    },
    'fallback_pro_2': {
      'name': 'Aliou Ba',
      'service': 'Plomberie',
      'location': 'Sacré-Cœur, Dakar',
      'price': '16 500 FCFA',
      'phone': '+221 77 000 00 02',
      'responseTime': 'Répond en 15 min',
      'completedJobs': 96,
      'verified': true,
      'availableNow': true,
      'subscribed': true,
      'subscriptionPlan': 'starter',
      'ratingAverage': 4.6,
      'reviewsCount': 83,
    },
    'fallback_pro_3': {
      'name': 'Yacine Fall',
      'service': 'Climatisation',
      'location': 'Mermoz, Dakar',
      'price': '19 500 FCFA',
      'phone': '+221 77 000 00 03',
      'responseTime': 'Répond en 8 min',
      'completedJobs': 172,
      'verified': true,
      'availableNow': true,
      'subscribed': true,
      'subscriptionPlan': 'business',
      'ratingAverage': 4.9,
      'reviewsCount': 201,
    },
    'fallback_pro_4': {
      'name': 'Saliou Ndiaye',
      'service': 'Plomberie',
      'location': 'Sacré-Cœur, Dakar',
      'price': '12 000 FCFA',
      'phone': '+221 77 000 00 04',
      'responseTime': 'Répond en 12 min',
      'completedJobs': 134,
      'verified': true,
      'availableNow': true,
      'subscribed': true,
      'subscriptionPlan': 'pro',
      'ratingAverage': 4.7,
      'reviewsCount': 109,
    },
  };

  void _applyFallbackProfessional(String targetId) {
    final data = _fallbackProfessionals[targetId];
    if (data == null) {
      setState(() {
        _professionalName = targetId;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _professionalName = data['name']?.toString() ?? targetId;
      _location = data['location']?.toString() ?? _location;
      _price = data['price']?.toString() ?? _price;
      _phone = data['phone']?.toString() ?? _phone;
      _service = data['service']?.toString() ?? _service;
      _responseTime = data['responseTime']?.toString() ?? _responseTime;
      _completedJobs = data['completedJobs'] is int
          ? data['completedJobs'] as int
          : _completedJobs;
      _verified = data['verified'] == true;
      _availableNow = data['availableNow'] != false;
      _subscribed = data['subscribed'] == true;
      _subscriptionPlan =
          data['subscriptionPlan']?.toString() ?? _subscriptionPlan;
      _averageRating = data['ratingAverage'] is num
          ? (data['ratingAverage'] as num).toDouble()
          : _averageRating;
      _reviewsCount = data['reviewsCount'] is int
          ? data['reviewsCount'] as int
          : _reviewsCount;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfessional();
  }

  Future<void> _loadProfessional() async {
    final targetId = Uri.decodeComponent(widget.id);

    if (!FirebaseBootstrap.isReady) {
      _applyFallbackProfessional(targetId);
      return;
    }

    try {
      final snapshot =
          await FirebaseDatabase.instance.ref('professionals').get();
      final root = snapshot.value;

      if (root is Map) {
        for (final categoryEntry in root.entries) {
          final categoryMap = categoryEntry.value;
          if (categoryMap is Map) {
            for (final professionalEntry in categoryMap.entries) {
              final map = professionalEntry.value;
              final matchesId = map is Map &&
                  (professionalEntry.key.toString() == targetId ||
                      map['id']?.toString() == targetId);
              final matchesName =
                  map is Map && map['name']?.toString() == targetId;
              if (map is Map && (matchesId || matchesName)) {
                final ratingAverage = map['ratingAverage'] is num
                    ? (map['ratingAverage'] as num).toDouble()
                    : 4.5;
                final count = map['reviewsCount'] is num
                    ? (map['reviewsCount'] as num).toInt()
                    : 127;

                if (!mounted) return;
                setState(() {
                  _professionalName = map['name']?.toString() ?? targetId;
                  _location =
                      map['location']?.toString() ?? 'Sacré-Cœur, Dakar';
                  _price = map['price']?.toString() ?? 'À partir de 5 000 FCFA';
                  _phone = map['phone']?.toString() ?? '+221 77 123 45 67';
                  _service = categoryEntry.key.toString();
                  _responseTime =
                      map['responseTime']?.toString() ?? 'Répond en 10 min';
                  _completedJobs = map['completedJobs'] is num
                      ? (map['completedJobs'] as num).toInt()
                      : 124;
                  _verified = map['verified'] == true;
                  _availableNow = map['availableNow'] != false;
                  _subscribed = map['subscribed'] == true;
                  _subscriptionPlan =
                      map['subscriptionPlan']?.toString() ?? 'none';
                  _averageRating = ratingAverage;
                  _reviewsCount = count;
                  _isLoading = false;
                  _professionalRef = FirebaseDatabase.instance.ref(
                      'professionals/${categoryEntry.key}/${professionalEntry.key}');
                });
                return;
              }
            }
          }
        }
      }

      if (!mounted) return;
      _applyFallbackProfessional(targetId);
    } catch (_) {
      if (!mounted) return;
      _applyFallbackProfessional(targetId);
    }
  }

  Future<void> _launchPhone() async {
    final uri = Uri(scheme: 'tel', path: _phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWhatsApp() async {
    final digits = _phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$digits');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildTrustItem(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitRating() async {
    final review = _reviewController.text.trim();
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir une note.')),
      );
      return;
    }

    final professionalRef = _professionalRef;
    if (professionalRef == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Professionnel introuvable pour enregistrer la note.')),
      );
      return;
    }

    try {
      final reviewRef = professionalRef.child('reviews').push();
      await reviewRef.set({
        'rating': _selectedRating,
        'comment': review.isEmpty ? 'Sans commentaire' : review,
        'createdAt': ServerValue.timestamp,
      });

      final reviewsSnapshot = await professionalRef.child('reviews').get();
      final reviews = reviewsSnapshot.value;
      double total = 0;
      int count = 0;

      if (reviews is Map) {
        for (final value in reviews.values) {
          if (value is Map) {
            final rating = value['rating'];
            if (rating is num) {
              total += rating.toDouble();
              count++;
            }
          }
        }
      }

      final nextAverage = count == 0 ? _selectedRating : total / count;
      final nextCount = count == 0 ? 1 : count;

      await professionalRef.update({
        'ratingAverage': nextAverage,
        'reviewsCount': nextCount,
        'rating': '⭐ ${nextAverage.toStringAsFixed(1)}',
      });

      if (!mounted) return;
      setState(() {
        _averageRating = nextAverage;
        _reviewsCount = nextCount;
      });

      _reviewController.clear();
      setState(() => _selectedRating = 0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Merci pour votre note de ${_selectedRating == 0 ? nextAverage.toStringAsFixed(1) : _selectedRating.toStringAsFixed(0)}/5.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Échec de l’enregistrement de la note. Réessayez.')),
      );
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil professionnel')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () => context.push('/request'),
            style: FilledButton.styleFrom(
                backgroundColor: AppColors.navy,
                padding: const EdgeInsets.all(16)),
            child: const Text('Demander un service'),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(radius: 46, child: Icon(Icons.person, size: 45)),
          const SizedBox(height: 12),
          Text(
            _professionalName.isEmpty
                ? Uri.decodeComponent(widget.id)
                : _professionalName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            _isLoading
                ? 'Chargement...'
                : '⭐ ${_averageRating.toStringAsFixed(1)} ($_reviewsCount avis)',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Center(
            child: Chip(
              label: Text(_service.isEmpty ? 'Professionnel' : '✓ $_service'),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_verified)
                _ProBadge(label: 'Profil vérifié', color: AppColors.success),
              if (_subscribed)
                _ProBadge(label: 'Abonné Pro', color: AppColors.navy),
              if (_availableNow)
                _ProBadge(
                    label: 'Disponible maintenant', color: AppColors.primary),
              _ProBadge(label: _responseTime, color: AppColors.navy),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildTrustItem(Icons.verified_user_outlined, 'Confiance',
                  _verified ? 'Badge vérifié' : 'Profil standard'),
              const SizedBox(width: 10),
              _buildTrustItem(Icons.work_history_outlined, 'Interventions',
                  '$_completedJobs réalisées'),
              const SizedBox(width: 10),
              _buildTrustItem(Icons.bolt_outlined, 'Réponse', _responseTime),
            ],
          ),
          const SizedBox(height: 10),
          if (_subscribed)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.navy.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: AppColors.navy.withValues(alpha: 0.14)),
              ),
              child: Text(
                'Ce professionnel est abonné au plan ${_subscriptionPlan.toUpperCase()} et peut recevoir vos demandes puis vous émettre des offres.',
                style: const TextStyle(height: 1.4),
              ),
            ),
          const Divider(height: 32),
          const Text('Informations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(_location),
            subtitle: const Text('Zone d’intervention'),
          ),
          ListTile(
            leading: const Icon(Icons.work_outline),
            title: Text(_service),
            subtitle: const Text('Service principal'),
          ),
          ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: Text(_price),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _launchPhone,
                  icon: const Icon(Icons.phone_outlined),
                  label: const Text('Appeler'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _launchWhatsApp,
                  style: FilledButton.styleFrom(
                      backgroundColor: AppColors.success),
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text('WhatsApp'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Avis récents',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              title: Text('⭐ 5.0 — Très professionnel'),
              subtitle: Text('Intervention rapide et travail propre.'),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Noter ce professionnel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (index) {
              final value = index + 1;
              final isSelected = _selectedRating >= value;
              return IconButton(
                onPressed: () =>
                    setState(() => _selectedRating = value.toDouble()),
                icon: Icon(
                  isSelected ? Icons.star : Icons.star_border,
                  color: AppColors.primary,
                  size: 30,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _reviewController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Votre avis',
              hintText: 'Décrivez votre expérience...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _submitRating,
            style: FilledButton.styleFrom(
                backgroundColor: AppColors.navy,
                padding: const EdgeInsets.all(14)),
            child: const Text('Valider la note'),
          ),
        ],
      ),
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
