import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';

class _RequestItem {
  const _RequestItem({
    required this.service,
    required this.description,
    required this.urgency,
    required this.location,
    required this.phone,
    required this.createdAt,
  });

  final String service;
  final String description;
  final String urgency;
  final String location;
  final String phone;
  final DateTime createdAt;
}

class MyRequestsPage extends StatelessWidget {
  const MyRequestsPage({super.key});

  static const Map<String, int> _urgencyRank = {
    'Très urgent': 3,
    'Urgent': 2,
    'Standard': 1,
  };

  static final List<_RequestItem> _fallbackRequests = [
    _RequestItem(
      service: 'Climatisation',
      description: 'Mon climatiseur ne refroidit plus depuis ce matin.',
      urgency: 'Très urgent',
      location: 'Yoff, Dakar',
      phone: '+221 77 123 45 67',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    _RequestItem(
      service: 'Plomberie',
      description: 'Fuite sous l’évier de la cuisine, besoin d’intervention rapide.',
      urgency: 'Urgent',
      location: 'Sacré-Cœur, Dakar',
      phone: '+221 70 987 65 43',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    _RequestItem(
      service: 'Électricité',
      description: 'Prise cassée dans la chambre principale.',
      urgency: 'Standard',
      location: 'Mermoz, Dakar',
      phone: '+221 76 345 12 98',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static List<_RequestItem> _requestsFromSnapshot(Object? snapshotValue) {
    final requests = <_RequestItem>[];

    void collectFrom(dynamic value) {
      if (value is Map) {
        final service = value['service']?.toString() ?? 'Service';
        final urgency = value['urgency']?.toString() ?? 'Standard';
        final description = value['description']?.toString() ?? 'Demande en cours';
        final location = value['location']?.toString() ?? 'Dakar';
        final phone = value['phone']?.toString() ?? 'Téléphone non renseigné';

        final createdAtValue = value['createdAt'];
        final createdAt = createdAtValue is int
            ? DateTime.fromMillisecondsSinceEpoch(createdAtValue)
            : DateTime.now();

        requests.add(
          _RequestItem(
            service: service,
            description: description,
            urgency: urgency,
            location: location,
            phone: phone,
            createdAt: createdAt,
          ),
        );
      }
    }

    if (snapshotValue is Map) {
      for (final item in snapshotValue.values) {
        collectFrom(item);
      }
    }

    if (requests.isEmpty) {
      return _fallbackRequests;
    }

    requests.sort(
      (a, b) => (_urgencyRank[b.urgency] ?? 0).compareTo(_urgencyRank[a.urgency] ?? 0),
    );
    return requests;
  }

  static Color _urgencyColor(String urgency) {
    switch (urgency) {
      case 'Très urgent':
        return AppColors.danger;
      case 'Urgent':
        return AppColors.primary;
      default:
        return AppColors.success;
    }
  }

  static Widget _buildList(List<_RequestItem> requests) {
    final sortedRequests = [...requests]
      ..sort(
        (a, b) => (_urgencyRank[b.urgency] ?? 0).compareTo(_urgencyRank[a.urgency] ?? 0),
      );

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sortedRequests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final request = sortedRequests[index];

        return Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        request.service,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _urgencyColor(request.urgency).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        request.urgency,
                        style: TextStyle(
                          color: _urgencyColor(request.urgency),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  request.description,
                  style: const TextStyle(color: AppColors.muted, height: 1.45),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 18, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        request.location,
                        style: const TextStyle(color: AppColors.muted),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 18, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        request.phone,
                        style: const TextStyle(color: AppColors.muted),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Créée le ${request.createdAt.day}/${request.createdAt.month}/${request.createdAt.year}',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes demandes')),
      body: SafeArea(
        child: FirebaseBootstrap.isReady
            ? StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance.ref('requests').onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _buildList(_fallbackRequests);
                  }

                  final requests = _requestsFromSnapshot(snapshot.data?.snapshot.value);
                  return _buildList(requests);
                },
              )
            : _buildList(_fallbackRequests),
      ),
    );
  }
}
