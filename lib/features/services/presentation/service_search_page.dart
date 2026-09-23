import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';

class _ProfessionalSummary {
  const _ProfessionalSummary({
    required this.name,
    required this.rating,
    required this.distance,
    required this.price,
  });

  final String name;
  final String rating;
  final String distance;
  final String price;
}

class ServiceSearchPage extends StatelessWidget {
  const ServiceSearchPage({super.key, required this.category});
  final String category;

  static const List<_ProfessionalSummary> _fallbackProfessionals = [
    _ProfessionalSummary(
      name: 'Mamadou Diop',
      rating: '⭐ 4.8',
      distance: '1.2 km',
      price: 'À partir de 5 000 FCFA',
    ),
    _ProfessionalSummary(
      name: 'Aliou Ba',
      rating: '⭐ 4.6',
      distance: '2.4 km',
      price: 'À partir de 6 000 FCFA',
    ),
    _ProfessionalSummary(
      name: 'Yacine Fall',
      rating: '⭐ 4.9',
      distance: '3.1 km',
      price: 'À partir de 7 000 FCFA',
    ),
  ];

  static List<_ProfessionalSummary> _fromSnapshot(Object? snapshotValue, {String search = ''}) {
    final professionals = <_ProfessionalSummary>[];
    final normalizedSearch = search.trim().toLowerCase();

    void collectFrom(dynamic value, [String? parentKey]) {
      if (value is Map) {
        final name = value['name']?.toString();
        final rating = value['rating']?.toString() ?? '⭐ 4.5';
        final distance = value['distance']?.toString() ?? 'N/A';
        final price = value['price']?.toString() ?? 'À confirmer';

        if (name != null && name.trim().isNotEmpty) {
          final serviceKey = (parentKey ?? value['service']?.toString() ?? '').trim();
          final matchesSearch = normalizedSearch.isEmpty ||
              name.toLowerCase().contains(normalizedSearch) ||
              serviceKey.toLowerCase().contains(normalizedSearch) ||
              value['service']?.toString().toLowerCase().contains(normalizedSearch) == true;

          if (matchesSearch) {
            professionals.add(
              _ProfessionalSummary(
                name: name,
                rating: rating,
                distance: distance,
                price: price,
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
      debugPrint('Firebase professionals parsed: ${professionals.length} items from $snapshotValue');
    }

    return professionals.isNotEmpty ? professionals : _fallbackProfessionals;
  }

  List<Widget> _buildPros(BuildContext context, List<_ProfessionalSummary> pros) {
    return pros
        .map(
          (professional) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: const CircleAvatar(radius: 28, child: Icon(Icons.person)),
              title: Text(
                professional.name,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                '${professional.rating}  •  ${professional.distance}\n${professional.price}',
              ),
              isThreeLine: true,
              trailing: FilledButton(
                onPressed: () => context.push('/professional/${Uri.encodeComponent(professional.name)}'),
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
    final decodedCategory = Uri.decodeComponent(category);
    final normalizedQuery = decodedCategory == 'Recherche' ? '' : decodedCategory;
    final filteredFallbackProfessionals = normalizedQuery.isEmpty
        ? _fallbackProfessionals
        : _fallbackProfessionals.where((professional) {
            final haystack = '${professional.name} ${professional.price}'.toLowerCase();
            return haystack.contains(normalizedQuery.toLowerCase());
          }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(decodedCategory == 'Recherche' ? 'Recherche' : decodedCategory)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-professional'),
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Ajouter'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            normalizedQuery.isEmpty ? 'Professionnels proches' : 'Résultats pour "$normalizedQuery"',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          if (!FirebaseBootstrap.isReady)
            ..._buildPros(context, filteredFallbackProfessionals)
          else
            StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance.ref('professionals').onValue,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint('Firebase professionals error for $decodedCategory: ${snapshot.error}');
                  return Column(children: _buildPros(context, filteredFallbackProfessionals));
                }

                final pros = _fromSnapshot(snapshot.data?.snapshot.value, search: normalizedQuery);
                return Column(children: _buildPros(context, pros));
              },
            ),
        ],
      ),
    );
  }
}
