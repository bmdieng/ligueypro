import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';

class _RequestItem {
  const _RequestItem({
    required this.id,
    required this.service,
    required this.description,
    required this.urgency,
    required this.location,
    required this.phone,
    required this.status,
    required this.offersStatus,
    required this.offersCount,
    required this.createdAt,
    this.acceptedProfessionalId,
    this.acceptedProfessionalName,
    this.acceptedOfferPrice,
    this.acceptedOfferEta,
  });

  final String id;
  final String service;
  final String description;
  final String urgency;
  final String location;
  final String phone;
  final String status;
  final String offersStatus;
  final int offersCount;
  final DateTime createdAt;
  final String? acceptedProfessionalId;
  final String? acceptedProfessionalName;
  final String? acceptedOfferPrice;
  final String? acceptedOfferEta;
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
      id: 'fallback_request_1',
      service: 'Climatisation',
      description: 'Mon climatiseur ne refroidit plus depuis ce matin.',
      urgency: 'Très urgent',
      location: 'Yoff, Dakar',
      phone: '+221 77 123 45 67',
      status: 'awaiting_offers',
      offersStatus: 'open',
      offersCount: 3,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    _RequestItem(
      id: 'fallback_request_2',
      service: 'Plomberie',
      description:
          'Fuite sous l’évier de la cuisine, besoin d’intervention rapide.',
      urgency: 'Urgent',
      location: 'Sacré-Cœur, Dakar',
      phone: '+221 70 987 65 43',
      status: 'in_progress',
      offersStatus: 'accepted',
      offersCount: 2,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      acceptedProfessionalId: 'fallback_pro_4',
      acceptedProfessionalName: 'Saliou Ndiaye',
      acceptedOfferPrice: '12 000 FCFA',
      acceptedOfferEta: 'Intervention prévue à 16h',
    ),
    _RequestItem(
      id: 'fallback_request_3',
      service: 'Électricité',
      description: 'Prise cassée dans la chambre principale.',
      urgency: 'Standard',
      location: 'Mermoz, Dakar',
      phone: '+221 76 345 12 98',
      status: 'pending',
      offersStatus: 'open',
      offersCount: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static List<_RequestItem> _requestsFromSnapshot(Object? snapshotValue) {
    final requests = <_RequestItem>[];

    void collectFrom(dynamic value, [String requestId = 'request']) {
      if (value is Map) {
        final service = value['service']?.toString() ?? 'Service';
        final urgency = value['urgency']?.toString() ?? 'Standard';
        final description =
            value['description']?.toString() ?? 'Demande en cours';
        final location = value['location']?.toString() ?? 'Dakar';
        final phone = value['phone']?.toString() ?? 'Téléphone non renseigné';
        final status = value['status']?.toString() ?? 'pending';
        final offersStatus = value['offersStatus']?.toString() ?? 'open';
        final offersCount = value['offersCount'] is num
            ? (value['offersCount'] as num).toInt()
            : 0;
        final acceptedProfessionalId =
            value['acceptedProfessionalId']?.toString();
        final acceptedProfessionalName =
            value['acceptedProfessionalName']?.toString();
        final acceptedOfferPrice = value['acceptedOfferPrice']?.toString();
        final acceptedOfferEta = value['acceptedOfferEta']?.toString();

        final createdAtValue = value['createdAt'];
        final createdAt = createdAtValue is int
            ? DateTime.fromMillisecondsSinceEpoch(createdAtValue)
            : DateTime.now();

        requests.add(
          _RequestItem(
            id: requestId,
            service: service,
            description: description,
            urgency: urgency,
            location: location,
            phone: phone,
            status: status,
            offersStatus: offersStatus,
            offersCount: offersCount,
            createdAt: createdAt,
            acceptedProfessionalId: acceptedProfessionalId,
            acceptedProfessionalName: acceptedProfessionalName,
            acceptedOfferPrice: acceptedOfferPrice,
            acceptedOfferEta: acceptedOfferEta,
          ),
        );
      }
    }

    if (snapshotValue is Map) {
      for (final entry in snapshotValue.entries) {
        collectFrom(entry.value, entry.key.toString());
      }
    }

    if (requests.isEmpty) {
      return _fallbackRequests;
    }

    requests.sort(
      (a, b) => (_urgencyRank[b.urgency] ?? 0)
          .compareTo(_urgencyRank[a.urgency] ?? 0),
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

  static String _statusLabel(String status) {
    switch (status) {
      case 'accepted':
        return 'Acceptée';
      case 'awaiting_offers':
        return 'En attente d’offres';
      case 'en_route':
        return 'En route';
      case 'in_progress':
        return 'En cours';
      case 'completed':
        return 'Terminée';
      case 'cancelled':
        return 'Annulée';
      default:
        return 'En attente';
    }
  }

  static Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return AppColors.primary;
      case 'awaiting_offers':
        return AppColors.navy;
      case 'en_route':
      case 'in_progress':
        return AppColors.navy;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.danger;
      default:
        return AppColors.muted;
    }
  }

  static double _statusProgress(String status) {
    switch (status) {
      case 'accepted':
        return 0.4;
      case 'awaiting_offers':
        return 0.25;
      case 'en_route':
        return 0.65;
      case 'in_progress':
        return 0.8;
      case 'completed':
        return 1;
      case 'cancelled':
        return 0;
      default:
        return 0.2;
    }
  }

  static String _offersStatusLabel(String offersStatus) {
    switch (offersStatus) {
      case 'accepted':
        return 'Offre acceptée';
      case 'closed':
        return 'Appel d’offres clos';
      default:
        return 'Offres ouvertes';
    }
  }

  static Widget _buildList(List<_RequestItem> requests) {
    final sortedRequests = [...requests]..sort(
        (a, b) => (_urgencyRank[b.urgency] ?? 0)
            .compareTo(_urgencyRank[a.urgency] ?? 0),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _urgencyColor(request.urgency)
                            .withValues(alpha: 0.12),
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
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusColor(request.status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _statusLabel(request.status),
                    style: TextStyle(
                      color: _statusColor(request.status),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  request.description,
                  style: const TextStyle(color: AppColors.muted, height: 1.45),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: _statusProgress(request.status),
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        _statusColor(request.status)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 18, color: AppColors.primary),
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
                    const Icon(Icons.phone_outlined,
                        size: 18, color: AppColors.primary),
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
                const SizedBox(height: 8),
                Text(
                  '${_offersStatusLabel(request.offersStatus)} • ${request.offersCount} offre(s)',
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Règlement direct entre client et professionnel après choix de l’offre.',
                  style: TextStyle(color: AppColors.muted),
                ),
                if (request.acceptedProfessionalName != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Professionnel retenu',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          request.acceptedProfessionalName!,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        if (request.acceptedOfferPrice != null)
                          Text(
                            'Prix accepté : ${request.acceptedOfferPrice}',
                            style: const TextStyle(color: AppColors.muted),
                          ),
                        if (request.acceptedOfferEta != null)
                          Text(
                            'Délai confirmé : ${request.acceptedOfferEta}',
                            style: const TextStyle(color: AppColors.muted),
                          ),
                        if (request.acceptedProfessionalId != null) ...[
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () => context.push(
                              '/professional/${Uri.encodeComponent(request.acceptedProfessionalId!)}',
                            ),
                            icon: const Icon(Icons.person_search_outlined),
                            label: const Text('Voir le profil'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.push(
                          '/request-offers',
                          extra: {
                            'requestId': request.id,
                            'service': request.service,
                            'location': request.location,
                            'urgency': request.urgency,
                          },
                        ),
                        child: const Text('Voir les offres'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => context.push('/request'),
                        style: FilledButton.styleFrom(
                            backgroundColor: AppColors.navy),
                        child: const Text('Nouvelle demande'),
                      ),
                    ),
                  ],
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

                  final requests =
                      _requestsFromSnapshot(snapshot.data?.snapshot.value);
                  return _buildList(requests);
                },
              )
            : _buildList(_fallbackRequests),
      ),
    );
  }
}
