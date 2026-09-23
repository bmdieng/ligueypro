import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/uri_helpers.dart';

class _ProfessionalSummary {
  const _ProfessionalSummary({
    required this.id,
    required this.name,
    required this.service,
    required this.location,
    required this.rating,
    required this.ratingAverage,
    required this.distance,
    required this.price,
    required this.verified,
    required this.availableNow,
    required this.responseTime,
    required this.completedJobs,
  });

  final String id;
  final String name;
  final String service;
  final String location;
  final String rating;
  final double ratingAverage;
  final String distance;
  final String price;
  final bool verified;
  final bool availableNow;
  final String responseTime;
  final int completedJobs;
}

class ServiceSearchPage extends StatefulWidget {
  const ServiceSearchPage({super.key, required this.category});
  final String category;

  @override
  State<ServiceSearchPage> createState() => _ServiceSearchPageState();
}

class _ServiceSearchPageState extends State<ServiceSearchPage> {
  String _selectedFilter = 'Tous';

  static List<_ProfessionalSummary> _fromSnapshot(Object? snapshotValue,
      {String search = ''}) {
    final professionals = <_ProfessionalSummary>[];
    final normalizedSearch = search.trim().toLowerCase();

    void collectFrom(dynamic value, [String? parentKey]) {
      if (value is Map) {
        final name = value['name']?.toString();
        final rating = value['rating']?.toString() ?? '⭐ 4.5';
        final distance = value['distance']?.toString() ?? 'N/A';
        final price = value['price']?.toString() ?? 'À confirmer';
        final ratingAverage = value['ratingAverage'] is num
            ? (value['ratingAverage'] as num).toDouble()
            : _parseRating(rating);
        final verified = value['verified'] == true;
        final availableNow = value['availableNow'] != false;
        final responseTime =
            value['responseTime']?.toString() ?? 'Réponse rapide';
        final completedJobs = value['completedJobs'] is num
            ? (value['completedJobs'] as num).toInt()
            : 0;
        final location = value['location']?.toString() ?? 'Dakar';

        if (name != null && name.trim().isNotEmpty) {
          final serviceKey =
              (parentKey ?? value['service']?.toString() ?? '').trim();
          final matchesSearch = normalizedSearch.isEmpty ||
              name.toLowerCase().contains(normalizedSearch) ||
              serviceKey.toLowerCase().contains(normalizedSearch) ||
              value['service']
                      ?.toString()
                      .toLowerCase()
                      .contains(normalizedSearch) ==
                  true;

          if (matchesSearch) {
            professionals.add(
              _ProfessionalSummary(
                id: value['id']?.toString() ?? name,
                name: name,
                service: value['service']?.toString() ?? serviceKey,
                location: location,
                rating: rating,
                ratingAverage: ratingAverage,
                distance: distance,
                price: price,
                verified: verified,
                availableNow: availableNow,
                responseTime: responseTime,
                completedJobs: completedJobs,
              ),
            );
          }
          return;
        }

        for (final entry in value.entries) {
          collectFrom(entry.value, entry.key.toString());
        }
      } else if (value is List) {
        for (final item in value) {
          collectFrom(item, parentKey);
        }
      }
    }

    if (snapshotValue != null) {
      collectFrom(snapshotValue);
      debugPrint(
          'Firebase professionals parsed: ${professionals.length} items from $snapshotValue');
    }

    return professionals;
  }

  static double _parseRating(String ratingText) {
    final match = RegExp(r'\d+(?:[.,]\d+)?').firstMatch(ratingText);
    if (match == null) return 4.5;
    return double.tryParse(match.group(0)!.replaceAll(',', '.')) ?? 4.5;
  }

  List<_ProfessionalSummary> _applyFilter(
      List<_ProfessionalSummary> professionals) {
    switch (_selectedFilter) {
      case 'Vérifiés':
        return professionals
            .where((professional) => professional.verified)
            .toList();
      case 'Disponibles':
        return professionals
            .where((professional) => professional.availableNow)
            .toList();
      case 'Top notés':
        final filtered = [...professionals]
          ..sort((a, b) => b.ratingAverage.compareTo(a.ratingAverage));
        return filtered;
      default:
        return professionals;
    }
  }

  List<Widget> _buildPros(
      BuildContext context, List<_ProfessionalSummary> pros) {
    return pros
        .map(
          (professional) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading:
                  const CircleAvatar(radius: 28, child: Icon(Icons.person)),
              title: Text(
                professional.name,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text('${professional.service} • ${professional.location}'),
                  const SizedBox(height: 4),
                  Text(
                    '${professional.rating}  •  ${professional.distance}  •  ${professional.price}',
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (professional.verified)
                        _ResultBadge(
                          label: 'Vérifié',
                          color: AppColors.success,
                        ),
                      if (professional.availableNow)
                        _ResultBadge(
                          label: 'Disponible',
                          color: AppColors.primary,
                        ),
                      _ResultBadge(
                        label: professional.responseTime,
                        color: AppColors.navy,
                      ),
                    ],
                  ),
                ],
              ),
              isThreeLine: false,
              trailing: FilledButton(
                onPressed: () => context.push(
                    '/professional/${Uri.encodeComponent(professional.id)}'),
                style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
                child: const Text('Voir'),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final decodedCategory = safeDecodeUriComponent(widget.category);
    final normalizedQuery =
        decodedCategory == 'Recherche' ? '' : decodedCategory;

    return Scaffold(
      appBar: AppBar(
          title: Text(
              decodedCategory == 'Recherche' ? 'Recherche' : decodedCategory)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-professional'),
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Ajouter'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  normalizedQuery.isEmpty
                      ? 'Professionnels proches'
                      : 'Résultats pour "$normalizedQuery"',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Filtrez les profils les plus fiables, disponibles et bien notés.',
                  style: TextStyle(color: AppColors.muted),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['Tous', 'Vérifiés', 'Disponibles', 'Top notés']
                      .map(
                        (filter) => ChoiceChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          onSelected: (_) =>
                              setState(() => _selectedFilter = filter),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            normalizedQuery.isEmpty
                ? 'Professionnels proches'
                : 'Résultats pour "$normalizedQuery"',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          if (!FirebaseBootstrap.isReady)
            ..._buildEmptyResults()
          else
            StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance.ref('professionals').onValue,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint(
                      'Firebase professionals error for $decodedCategory: ${snapshot.error}');
                  return Column(children: _buildEmptyResults());
                }

                final pros = _fromSnapshot(snapshot.data?.snapshot.value,
                    search: normalizedQuery);
                final filtered = _applyFilter(pros);
                if (filtered.isEmpty) {
                  return Column(children: _buildEmptyResults());
                }
                return Column(children: _buildPros(context, filtered));
              },
            ),
        ],
      ),
    );
  }

  List<Widget> _buildEmptyResults() {
    return [
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        ),
        child: const Column(
          children: [
            Icon(Icons.search_off_outlined, size: 42, color: AppColors.primary),
            SizedBox(height: 12),
            Text(
              'Aucun professionnel trouvé',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Aucun profil ne correspond à cette recherche dans Firebase pour le moment.',
              style: TextStyle(color: AppColors.muted, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ];
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
