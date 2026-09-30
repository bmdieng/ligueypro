import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/uri_helpers.dart';
import '../../../l10n/generated/app_localizations.dart';

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
        final price = value['price']?.toString() ?? '';
        final ratingAverage = value['ratingAverage'] is num
            ? (value['ratingAverage'] as num).toDouble()
            : _parseRating(rating);
        final verified = value['verified'] == true;
        final availableNow = value['availableNow'] != false;
        final responseTime = value['responseTime']?.toString() ?? '';
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
    List<_ProfessionalSummary> professionals,
    AppLocalizations l10n,
  ) {
    if (_selectedFilter == l10n.serviceSearchFilterVerified) {
      return professionals
          .where((professional) => professional.verified)
          .toList();
    }

    if (_selectedFilter == l10n.serviceSearchFilterAvailable) {
      return professionals
          .where((professional) => professional.availableNow)
          .toList();
    }

    if (_selectedFilter == l10n.serviceSearchFilterTopRated) {
      final filtered = [...professionals]
        ..sort((a, b) => b.ratingAverage.compareTo(a.ratingAverage));
      return filtered;
    }

    return professionals;
  }

  List<Widget> _buildPros(
      BuildContext context, List<_ProfessionalSummary> pros) {
    final l10n = AppLocalizations.of(context);
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
                          label: l10n.serviceSearchBadgeVerified,
                          color: AppColors.success,
                        ),
                      if (professional.availableNow)
                        _ResultBadge(
                          label: l10n.serviceSearchBadgeAvailable,
                          color: AppColors.primary,
                        ),
                      _ResultBadge(
                        label: professional.responseTime.isEmpty
                            ? l10n.serviceSearchDefaultResponseTime
                            : professional.responseTime,
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
                child: Text(l10n.serviceSearchSee),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final decodedCategory = safeDecodeUriComponent(widget.category);
    final normalizedQuery =
        decodedCategory == l10n.serviceSearchTitle ? '' : decodedCategory;

    final filterAll = l10n.serviceSearchFilterAll;
    final filterVerified = l10n.serviceSearchFilterVerified;
    final filterAvailable = l10n.serviceSearchFilterAvailable;
    final filterTopRated = l10n.serviceSearchFilterTopRated;

    if (_selectedFilter == 'Tous') {
      _selectedFilter = filterAll;
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(decodedCategory == l10n.serviceSearchTitle
              ? l10n.serviceSearchTitle
              : decodedCategory)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-professional'),
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: Text(l10n.serviceSearchAdd),
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
                      ? l10n.serviceSearchNearby
                      : l10n.serviceSearchResultsFor(normalizedQuery),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.serviceSearchFilterDescription,
                  style: const TextStyle(color: AppColors.muted),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    filterAll,
                    filterVerified,
                    filterAvailable,
                    filterTopRated,
                  ]
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
                ? l10n.serviceSearchNearby
                : l10n.serviceSearchResultsFor(normalizedQuery),
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
                final filtered = _applyFilter(pros, l10n);
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
        child: Column(
          children: [
            const Icon(Icons.search_off_outlined,
                size: 42, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context).serviceSearchEmptyTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).serviceSearchEmptyMessage,
              style: const TextStyle(color: AppColors.muted, height: 1.4),
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
