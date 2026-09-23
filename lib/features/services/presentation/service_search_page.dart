import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';

class _ProfessionalSummary {
  const _ProfessionalSummary({
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

  static const List<_ProfessionalSummary> _fallbackProfessionals = [
    _ProfessionalSummary(
      name: 'Mamadou Diop',
      service: 'Plomberie',
      location: 'Sacré-Cœur, Dakar',
      rating: '⭐ 4.8',
      ratingAverage: 4.8,
      distance: '1.2 km',
      price: 'À partir de 5 000 FCFA',
      verified: true,
      availableNow: true,
      responseTime: 'Répond en 8 min',
      completedJobs: 126,
    ),
    _ProfessionalSummary(
      name: 'Aliou Ba',
      service: 'Électricité',
      location: 'Mermoz, Dakar',
      rating: '⭐ 4.6',
      ratingAverage: 4.6,
      distance: '2.4 km',
      price: 'À partir de 6 000 FCFA',
      verified: true,
      availableNow: false,
      responseTime: 'Répond en 18 min',
      completedJobs: 84,
    ),
    _ProfessionalSummary(
      name: 'Yacine Fall',
      service: 'Climatisation',
      location: 'Yoff, Dakar',
      rating: '⭐ 4.9',
      ratingAverage: 4.9,
      distance: '3.1 km',
      price: 'À partir de 7 000 FCFA',
      verified: false,
      availableNow: true,
      responseTime: 'Répond en 12 min',
      completedJobs: 59,
    ),
  ];

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

    return professionals.isNotEmpty ? professionals : _fallbackProfessionals;
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
                    '/professional/${Uri.encodeComponent(professional.name)}'),
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
    final decodedCategory = Uri.decodeComponent(widget.category);
    final normalizedQuery =
        decodedCategory == 'Recherche' ? '' : decodedCategory;
    final filteredFallbackProfessionals = normalizedQuery.isEmpty
        ? _fallbackProfessionals
        : _fallbackProfessionals.where((professional) {
            final haystack =
                '${professional.name} ${professional.price}'.toLowerCase();
            return haystack.contains(normalizedQuery.toLowerCase());
          }).toList();

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
            ..._buildPros(context, _applyFilter(filteredFallbackProfessionals))
          else
            StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance.ref('professionals').onValue,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint(
                      'Firebase professionals error for $decodedCategory: ${snapshot.error}');
                  return Column(
                      children: _buildPros(context,
                          _applyFilter(filteredFallbackProfessionals)));
                }

                final pros = _fromSnapshot(snapshot.data?.snapshot.value,
                    search: normalizedQuery);
                return Column(
                    children: _buildPros(context, _applyFilter(pros)));
              },
            ),
        ],
      ),
    );
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
