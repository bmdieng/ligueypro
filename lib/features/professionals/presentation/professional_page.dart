import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  String _service = 'Service';
  DatabaseReference? _professionalRef;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfessional();
  }

  Future<void> _loadProfessional() async {
    final targetName = Uri.decodeComponent(widget.id);

    if (!FirebaseBootstrap.isReady) {
      setState(() {
        _professionalName = targetName;
        _isLoading = false;
      });
      return;
    }

    try {
      final snapshot = await FirebaseDatabase.instance.ref('professionals').get();
      final root = snapshot.value;

      if (root is Map) {
        for (final categoryEntry in root.entries) {
          final categoryMap = categoryEntry.value;
          if (categoryMap is Map) {
            for (final professionalEntry in categoryMap.entries) {
              final map = professionalEntry.value;
              if (map is Map && map['name']?.toString() == targetName) {
                final ratingAverage = map['ratingAverage'] is num
                    ? (map['ratingAverage'] as num).toDouble()
                    : 4.5;
                final count = map['reviewsCount'] is num
                    ? (map['reviewsCount'] as num).toInt()
                    : 127;

                if (!mounted) return;
                setState(() {
                  _professionalName = map['name']?.toString() ?? targetName;
                  _location = map['location']?.toString() ?? 'Sacré-Cœur, Dakar';
                  _price = map['price']?.toString() ?? 'À partir de 5 000 FCFA';
                  _service = categoryEntry.key.toString();
                  _averageRating = ratingAverage;
                  _reviewsCount = count;
                  _isLoading = false;
                  _professionalRef = FirebaseDatabase.instance
                      .ref('professionals/${categoryEntry.key}/${professionalEntry.key}');
                });
                return;
              }
            }
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _professionalName = targetName;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _professionalName = targetName;
        _isLoading = false;
      });
    }
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
        const SnackBar(content: Text('Professionnel introuvable pour enregistrer la note.')),
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
        SnackBar(content: Text('Merci pour votre note de ${_selectedRating == 0 ? nextAverage.toStringAsFixed(1) : _selectedRating.toStringAsFixed(0)}/5.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec de l’enregistrement de la note. Réessayez.')),
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
            style: FilledButton.styleFrom(backgroundColor: AppColors.navy, padding: const EdgeInsets.all(16)),
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
            _professionalName.isEmpty ? Uri.decodeComponent(widget.id) : _professionalName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            _isLoading ? 'Chargement...' : '⭐ ${_averageRating.toStringAsFixed(1)} (${_reviewsCount} avis)',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Center(
            child: Chip(
              label: Text(_service.isEmpty ? 'Professionnel' : '✓ $_service'),
            ),
          ),
          const Divider(height: 32),
          const Text('Informations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
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
          const SizedBox(height: 16),
          const Text('Avis récents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              title: Text('⭐ 5.0 — Très professionnel'),
              subtitle: Text('Intervention rapide et travail propre.'),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Noter ce professionnel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (index) {
              final value = index + 1;
              final isSelected = _selectedRating >= value;
              return IconButton(
                onPressed: () => setState(() => _selectedRating = value.toDouble()),
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
            style: FilledButton.styleFrom(backgroundColor: AppColors.navy, padding: const EdgeInsets.all(14)),
            child: const Text('Valider la note'),
          ),
        ],
      ),
    );
  }
}
