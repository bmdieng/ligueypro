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
  double _averageRating = 0;
  int _reviewsCount = 0;
  String _professionalName = '';
  String _location = 'Localisation non renseignée';
  String _price = 'Tarif à confirmer';
  String _phone = '';
  String _service = 'Service non renseigné';
  String _responseTime = 'Temps de réponse non renseigné';
  int _completedJobs = 0;
  bool _verified = false;
  bool _availableNow = false;
  bool _subscribed = false;
  String _subscriptionPlan = 'none';
  List<_ProfessionalReview> _recentReviews = const [];
  DatabaseReference? _professionalRef;
  bool _isLoading = true;
  bool _notFound = false;

  @override
  void initState() {
    super.initState();
    _loadProfessional();
  }

  Future<void> _loadProfessional() async {
    final targetId = Uri.decodeComponent(widget.id);

    if (!FirebaseBootstrap.isReady) {
      setState(() {
        _professionalName = targetId;
        _notFound = true;
        _isLoading = false;
      });
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
                    : _parseStoredRating(map['rating']?.toString());
                final count = map['reviewsCount'] is num
                    ? (map['reviewsCount'] as num).toInt()
                    : 0;
                final reviews = _reviewsFromSnapshot(map['reviews']);

                if (!mounted) return;
                setState(() {
                  _professionalName = map['name']?.toString() ?? targetId;
                  _location =
                      map['location']?.toString().trim().isNotEmpty == true
                          ? map['location'].toString()
                          : 'Localisation non renseignée';
                  _price = map['price']?.toString().trim().isNotEmpty == true
                      ? map['price'].toString()
                      : 'Tarif à confirmer';
                  _phone = map['phone']?.toString().trim() ?? '';
                  _service =
                      map['service']?.toString().trim().isNotEmpty == true
                          ? map['service'].toString()
                          : categoryEntry.key.toString();
                  _responseTime =
                      map['responseTime']?.toString().trim().isNotEmpty == true
                          ? map['responseTime'].toString()
                          : 'Temps de réponse non renseigné';
                  _completedJobs = map['completedJobs'] is num
                      ? (map['completedJobs'] as num).toInt()
                      : 0;
                  _verified = map['verified'] == true;
                  _availableNow = map['availableNow'] != false;
                  _subscribed = map['subscribed'] == true;
                  _subscriptionPlan =
                      map['subscriptionPlan']?.toString() ?? 'none';
                  _averageRating = ratingAverage;
                  _reviewsCount = count;
                  _recentReviews = reviews;
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
      setState(() {
        _professionalName = targetId;
        _notFound = true;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _professionalName = targetId;
        _notFound = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _launchPhone() async {
    if (_phone.trim().isEmpty) {
      return;
    }
    final uri = Uri(scheme: 'tel', path: _phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWhatsApp() async {
    final digits = _phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return;
    }
    final uri = Uri.parse('https://wa.me/$digits');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static double _parseStoredRating(String? ratingText) {
    if (ratingText == null || ratingText.isEmpty) {
      return 0;
    }

    final match = RegExp(r'\d+(?:[.,]\d+)?').firstMatch(ratingText);
    if (match == null) {
      return 0;
    }

    return double.tryParse(match.group(0)!.replaceAll(',', '.')) ?? 0;
  }

  List<_ProfessionalReview> _reviewsFromSnapshot(Object? snapshotValue) {
    final reviews = <_ProfessionalReview>[];
    if (snapshotValue is! Map) {
      return reviews;
    }

    for (final entry in snapshotValue.entries) {
      final value = entry.value;
      if (value is! Map) {
        continue;
      }

      final rating = value['rating'];
      final comment = value['comment']?.toString().trim();
      final createdAt = value['createdAt'];
      final ratingValue = rating is num ? rating.toDouble() : null;
      final createdAtValue = createdAt is num
          ? DateTime.fromMillisecondsSinceEpoch(createdAt.toInt())
          : null;

      if (ratingValue == null) {
        continue;
      }

      reviews.add(
        _ProfessionalReview(
          id: entry.key.toString(),
          rating: ratingValue,
          comment: (comment == null || comment.isEmpty)
              ? 'Sans commentaire'
              : comment,
          createdAt: createdAtValue,
        ),
      );
    }

    reviews.sort((a, b) {
      final left = a.createdAt?.millisecondsSinceEpoch ?? 0;
      final right = b.createdAt?.millisecondsSinceEpoch ?? 0;
      return right.compareTo(left);
    });

    return reviews.take(3).toList();
  }

  String _formatRatingSummary() {
    if (_reviewsCount == 0) {
      return 'Aucun avis pour le moment';
    }
    return '⭐ ${_averageRating.toStringAsFixed(1)} ($_reviewsCount avis)';
  }

  String? _formatReviewDate(DateTime? createdAt) {
    if (createdAt == null) {
      return null;
    }

    final now = DateTime.now();
    final difference = now.difference(createdAt);
    if (difference.inMinutes < 1) {
      return 'à l’instant';
    }
    if (difference.inHours < 1) {
      return 'il y a ${difference.inMinutes} min';
    }
    if (difference.inDays < 1) {
      return 'il y a ${difference.inHours} h';
    }
    return 'il y a ${difference.inDays} j';
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
      final submittedRating = _selectedRating;
      final reviewRef = professionalRef.child('reviews').push();
      await reviewRef.set({
        'rating': submittedRating,
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
        _recentReviews = _reviewsFromSnapshot(reviews);
        _selectedRating = 0;
      });

      _reviewController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Merci pour votre note de ${submittedRating.toStringAsFixed(0)}/5.')),
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
          if (_notFound && !_isLoading)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.person_search_outlined,
                    color: AppColors.navy,
                    size: 36,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Profil introuvable',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ce professionnel n’est pas présent dans Firebase ou n’est plus disponible.',
                    style: TextStyle(color: AppColors.muted, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
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
            _isLoading ? 'Chargement...' : _formatRatingSummary(),
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
            subtitle: const Text('Indication tarifaire'),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      _notFound || _phone.trim().isEmpty ? null : _launchPhone,
                  icon: const Icon(Icons.phone_outlined),
                  label: const Text('Appeler'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _notFound || _phone.trim().isEmpty
                      ? null
                      : _launchWhatsApp,
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
          if (_recentReviews.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
              ),
              child: const Text(
                'Aucun avis récent disponible pour ce professionnel.',
                style: TextStyle(color: AppColors.muted, height: 1.4),
              ),
            )
          else
            Column(
              children: [
                for (final review in _recentReviews)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: ListTile(
                        title: Text(
                          '⭐ ${review.rating.toStringAsFixed(1)}',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(review.comment),
                            if (_formatReviewDate(review.createdAt) !=
                                null) ...[
                              const SizedBox(height: 6),
                              Text(
                                _formatReviewDate(review.createdAt)!,
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
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
            onPressed: _notFound ? null : _submitRating,
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

class _ProfessionalReview {
  const _ProfessionalReview({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  final String id;
  final double rating;
  final String comment;
  final DateTime? createdAt;
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
