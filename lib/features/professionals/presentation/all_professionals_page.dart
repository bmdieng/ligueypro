import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';

class _ProfessionalSummary {
  const _ProfessionalSummary({
    required this.id,
    required this.name,
    required this.service,
    required this.location,
    required this.price,
    required this.ratingAverage,
    required this.reviewsCount,
    required this.verified,
    required this.availableNow,
  });

  final String id;
  final String name;
  final String service;
  final String location;
  final String price;
  final double ratingAverage;
  final int reviewsCount;
  final bool verified;
  final bool availableNow;
}

class AllProfessionalsPage extends StatelessWidget {
  const AllProfessionalsPage({super.key});

  static List<_ProfessionalSummary> _fromSnapshot(Object? snapshotValue) {
    final professionals = <_ProfessionalSummary>[];

    if (snapshotValue is Map) {
      for (final categoryEntry in snapshotValue.entries) {
        final categoryMap = categoryEntry.value;
        if (categoryMap is Map) {
          for (final professionalEntry in categoryMap.entries) {
            final value = professionalEntry.value;
            if (value is Map) {
              final name = value['name']?.toString();
              if (name == null || name.trim().isEmpty) {
                continue;
              }

              final ratingAverage = value['ratingAverage'] is num
                  ? (value['ratingAverage'] as num).toDouble()
                  : _parseRating(value['rating']?.toString());
              final reviewsCount = value['reviewsCount'] is num
                  ? (value['reviewsCount'] as num).toInt()
                  : 0;

              professionals.add(
                _ProfessionalSummary(
                  id: professionalEntry.key.toString(),
                  name: name,
                  service: value['service']?.toString() ??
                      categoryEntry.key.toString(),
                  location: value['location']?.toString() ?? 'Dakar',
                  price: value['price']?.toString() ?? 'À confirmer',
                  ratingAverage: ratingAverage,
                  reviewsCount: reviewsCount,
                  verified: value['verified'] == true,
                  availableNow: value['availableNow'] != false,
                ),
              );
            }
          }
        }
      }
    }

    return professionals;
  }

  static double _parseRating(String? ratingText) {
    if (ratingText == null || ratingText.isEmpty) return 4.5;
    final match = RegExp(r'\d+(?:[.,]\d+)?').firstMatch(ratingText);
    if (match == null) return 4.5;
    final raw = match.group(0)!.replaceAll(',', '.');
    return double.tryParse(raw) ?? 4.5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tous les professionnels')),
      body: SafeArea(
        child: FirebaseBootstrap.isReady
            ? StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance.ref('professionals').onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _buildList(const []);
                  }

                  final professionals =
                      _fromSnapshot(snapshot.data?.snapshot.value);
                  return _buildList(professionals);
                },
              )
            : _buildList(const []),
      ),
    );
  }

  Widget _buildList(List<_ProfessionalSummary> professionals) {
    if (professionals.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
            ),
            child: const Column(
              children: [
                Icon(Icons.groups_outlined, size: 42, color: AppColors.primary),
                SizedBox(height: 12),
                Text(
                  'Aucun professionnel disponible',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'La liste sera remplie dès que des professionnels seront publiés dans Firebase.',
                  style: TextStyle(color: AppColors.muted, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      );
    }

    final sortedProfessionals = [...professionals]
      ..sort((a, b) => b.ratingAverage.compareTo(a.ratingAverage));

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sortedProfessionals.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final professional = sortedProfessionals[index];

        return Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: const CircleAvatar(radius: 28, child: Icon(Icons.person)),
            title: Text(
              professional.name,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(professional.service),
                const SizedBox(height: 4),
                Text('Lieu : ${professional.location}'),
                const SizedBox(height: 4),
                Text('Prix : ${professional.price}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.primary, size: 18),
                    const SizedBox(width: 4),
                    const Text('Moyenne',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Text(
                        '${professional.ratingAverage.toStringAsFixed(1)} / 5'),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (professional.verified)
                      _AllProsBadge(label: 'Vérifié', color: AppColors.success),
                    if (professional.availableNow)
                      _AllProsBadge(
                          label: 'Disponible', color: AppColors.primary),
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${professional.reviewsCount} avis',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () => context.push(
                      '/professional/${Uri.encodeComponent(professional.id)}'),
                  style:
                      FilledButton.styleFrom(backgroundColor: AppColors.navy),
                  child: const Text('Voir'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AllProsBadge extends StatelessWidget {
  const _AllProsBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}
