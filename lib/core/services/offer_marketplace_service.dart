import 'package:firebase_database/firebase_database.dart';

import '../network/firebase_bootstrap.dart';
import 'app_preferences_service.dart';

class MarketplaceRequestItem {
  const MarketplaceRequestItem({
    required this.id,
    required this.service,
    required this.urgency,
    required this.description,
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
  final String urgency;
  final String description;
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

class MarketplaceOfferItem {
  const MarketplaceOfferItem({
    required this.id,
    required this.professionalId,
    required this.professionalName,
    required this.planLabel,
    required this.price,
    required this.eta,
    required this.message,
    required this.phone,
    required this.createdAt,
    this.isAccepted = false,
    this.highlighted = false,
  });

  final String id;
  final String professionalId;
  final String professionalName;
  final String planLabel;
  final String price;
  final String eta;
  final String message;
  final String phone;
  final DateTime createdAt;
  final bool isAccepted;
  final bool highlighted;
}

class MarketplaceRequestDetails {
  const MarketplaceRequestDetails({
    required this.offers,
    required this.status,
    required this.offersStatus,
    this.acceptedOfferId,
  });

  final List<MarketplaceOfferItem> offers;
  final String status;
  final String offersStatus;
  final String? acceptedOfferId;
}

class SubscribedProfessionalItem {
  const SubscribedProfessionalItem({
    required this.id,
    required this.name,
    required this.phone,
    required this.service,
    required this.planLabel,
  });

  final String id;
  final String name;
  final String phone;
  final String service;
  final String planLabel;
}

class ProSentOfferItem {
  const ProSentOfferItem({
    required this.offerId,
    required this.requestId,
    required this.professionalId,
    required this.requestService,
    required this.requestLocation,
    required this.requestUrgency,
    required this.clientPhone,
    required this.professionalName,
    required this.planLabel,
    required this.price,
    required this.eta,
    required this.message,
    required this.createdAt,
    required this.requestStatus,
    required this.requestOffersStatus,
    this.isAccepted = false,
  });

  final String offerId;
  final String requestId;
  final String professionalId;
  final String requestService;
  final String requestLocation;
  final String requestUrgency;
  final String clientPhone;
  final String professionalName;
  final String planLabel;
  final String price;
  final String eta;
  final String message;
  final DateTime createdAt;
  final String requestStatus;
  final String requestOffersStatus;
  final bool isAccepted;
}

class OfferMarketplaceService {
  OfferMarketplaceService._();

  static List<MarketplaceRequestItem> requestsFromSnapshot(
      Object? snapshotValue) {
    final requests = <MarketplaceRequestItem>[];

    if (snapshotValue is Map) {
      for (final entry in snapshotValue.entries) {
        final value = entry.value;
        if (value is Map) {
          final createdAtValue = value['createdAt'];
          final createdAt = createdAtValue is int
              ? DateTime.fromMillisecondsSinceEpoch(createdAtValue)
              : DateTime.now();
          requests.add(
            MarketplaceRequestItem(
              id: entry.key.toString(),
              service: value['service']?.toString() ?? 'Service',
              urgency: value['urgency']?.toString() ?? 'Standard',
              description:
                  value['description']?.toString() ?? 'Demande en cours',
              location: value['location']?.toString() ?? 'Dakar',
              phone: value['phone']?.toString() ?? 'Téléphone non renseigné',
              status: value['status']?.toString() ?? 'pending',
              offersStatus: value['offersStatus']?.toString() ?? 'open',
              offersCount: value['offersCount'] is num
                  ? (value['offersCount'] as num).toInt()
                  : 0,
              createdAt: createdAt,
              acceptedProfessionalId:
                  value['acceptedProfessionalId']?.toString(),
              acceptedProfessionalName:
                  value['acceptedProfessionalName']?.toString(),
              acceptedOfferPrice: value['acceptedOfferPrice']?.toString(),
              acceptedOfferEta: value['acceptedOfferEta']?.toString(),
            ),
          );
        }
      }
    }

    requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return requests;
  }

  static List<MarketplaceOfferItem> offersFromSnapshot(Object? snapshotValue) {
    final offers = <MarketplaceOfferItem>[];

    if (snapshotValue is Map) {
      for (final entry in snapshotValue.entries) {
        final value = entry.value;
        if (value is Map) {
          final createdAtValue = value['createdAt'];
          final createdAt = createdAtValue is int
              ? DateTime.fromMillisecondsSinceEpoch(createdAtValue)
              : DateTime.now();
          offers.add(
            MarketplaceOfferItem(
              id: entry.key.toString(),
              professionalId: value['professionalId']?.toString() ??
                  value['professionalName']?.toString() ??
                  'professional',
              professionalName:
                  value['professionalName']?.toString() ?? 'Professionnel',
              planLabel: value['planLabel']?.toString() ?? 'Pro',
              price: value['price']?.toString() ?? 'À confirmer',
              eta: value['eta']?.toString() ?? 'Disponibilité à confirmer',
              message: value['message']?.toString() ?? 'Offre envoyée',
              phone: value['phone']?.toString() ?? 'Téléphone non renseigné',
              createdAt: createdAt,
              isAccepted: value['accepted'] == true,
              highlighted: value['highlighted'] == true,
            ),
          );
        }
      }
    }

    return offers;
  }

  static MarketplaceRequestDetails requestDetailsFromSnapshot(
    String requestId,
    Object? snapshotValue,
  ) {
    if (snapshotValue is Map) {
      final acceptedOfferId = snapshotValue['acceptedOfferId']?.toString();
      final offers = offersFromSnapshot(snapshotValue['offers']).map((offer) {
        if (acceptedOfferId == null) {
          return offer;
        }
        return MarketplaceOfferItem(
          id: offer.id,
          professionalId: offer.professionalId,
          professionalName: offer.professionalName,
          planLabel: offer.planLabel,
          price: offer.price,
          eta: offer.eta,
          message: offer.message,
          phone: offer.phone,
          createdAt: offer.createdAt,
          isAccepted: offer.id == acceptedOfferId,
          highlighted: offer.highlighted,
        );
      }).toList()
        ..sort((a, b) {
          if (a.isAccepted == b.isAccepted) {
            return b.createdAt.compareTo(a.createdAt);
          }
          return a.isAccepted ? -1 : 1;
        });

      return MarketplaceRequestDetails(
        offers: offers,
        status: snapshotValue['status']?.toString() ?? 'awaiting_offers',
        offersStatus: snapshotValue['offersStatus']?.toString() ?? 'open',
        acceptedOfferId: acceptedOfferId,
      );
    }

    return MarketplaceRequestDetails(
      offers: const [],
      status: 'awaiting_offers',
      offersStatus: 'open',
    );
  }

  static List<SubscribedProfessionalItem> subscribedProfessionalsFromSnapshot(
      Object? snapshotValue) {
    final professionals = <SubscribedProfessionalItem>[];

    if (snapshotValue is Map) {
      for (final categoryEntry in snapshotValue.entries) {
        final categoryMap = categoryEntry.value;
        if (categoryMap is Map) {
          for (final professionalValue in categoryMap.values) {
            if (professionalValue is Map &&
                professionalValue['subscribed'] == true) {
              professionals.add(
                SubscribedProfessionalItem(
                  id: professionalValue['id']?.toString() ??
                      professionalValue['professionalId']?.toString() ??
                      '${categoryEntry.key}_${professionals.length}',
                  name:
                      professionalValue['name']?.toString() ?? 'Professionnel',
                  phone: professionalValue['phone']?.toString() ??
                      '+221 77 000 00 00',
                  service: professionalValue['service']?.toString() ??
                      categoryEntry.key.toString(),
                  planLabel:
                      professionalValue['subscriptionPlan']?.toString() ??
                          'pro',
                ),
              );
            }
          }
        }
      }
    }

    return professionals;
  }

  static bool isRequestLocked(MarketplaceRequestItem request) {
    return request.offersStatus == 'accepted' ||
        request.offersStatus == 'closed' ||
        request.acceptedProfessionalId != null ||
        request.acceptedProfessionalName != null;
  }

  static List<ProSentOfferItem> sentOffersFromRoot(
    Object? rootSnapshot, {
    String? professionalId,
  }) {
    final offers = <ProSentOfferItem>[];

    if (rootSnapshot is! Map) {
      return offers
        ..sort((a, b) {
          if (a.isAccepted != b.isAccepted) {
            return a.isAccepted ? -1 : 1;
          }
          return b.createdAt.compareTo(a.createdAt);
        });
    }

    final requestsSnapshot = rootSnapshot['requests'];
    if (requestsSnapshot is Map) {
      for (final requestEntry in requestsSnapshot.entries) {
        final requestValue = requestEntry.value;
        if (requestValue is! Map) {
          continue;
        }

        final acceptedOfferId = requestValue['acceptedOfferId']?.toString();
        final offersSnapshot = requestValue['offers'];
        if (offersSnapshot is! Map) {
          continue;
        }

        for (final offerEntry in offersSnapshot.entries) {
          final offerValue = offerEntry.value;
          if (offerValue is! Map) {
            continue;
          }

          final currentProfessionalName =
              offerValue['professionalName']?.toString() ?? 'Professionnel';
          final currentProfessionalId =
              offerValue['professionalId']?.toString() ??
                  currentProfessionalName;
          if (professionalId != null &&
              professionalId.isNotEmpty &&
              currentProfessionalId != professionalId) {
            continue;
          }

          final createdAtValue = offerValue['createdAt'];
          final createdAt = createdAtValue is int
              ? DateTime.fromMillisecondsSinceEpoch(createdAtValue)
              : DateTime.now();

          offers.add(
            ProSentOfferItem(
              offerId: offerEntry.key.toString(),
              requestId: requestEntry.key.toString(),
              professionalId: currentProfessionalId,
              requestService: requestValue['service']?.toString() ?? 'Service',
              requestLocation: requestValue['location']?.toString() ?? 'Dakar',
              requestUrgency: requestValue['urgency']?.toString() ?? 'Standard',
              clientPhone: requestValue['phone']?.toString() ??
                  'Téléphone non renseigné',
              professionalName: currentProfessionalName,
              planLabel: offerValue['planLabel']?.toString() ?? 'Pro',
              price: offerValue['price']?.toString() ?? 'À confirmer',
              eta: offerValue['eta']?.toString() ?? 'Disponibilité à confirmer',
              message: offerValue['message']?.toString() ?? 'Offre envoyée',
              createdAt: createdAt,
              requestStatus:
                  requestValue['status']?.toString() ?? 'awaiting_offers',
              requestOffersStatus:
                  requestValue['offersStatus']?.toString() ?? 'open',
              isAccepted: acceptedOfferId == offerEntry.key.toString() ||
                  offerValue['accepted'] == true,
            ),
          );
        }
      }
    }

    offers.sort((a, b) {
      if (a.isAccepted != b.isAccepted) {
        return a.isAccepted ? -1 : 1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });
    return offers;
  }

  static Future<void> submitOffer({
    required String requestId,
    required MarketplaceOfferItem offer,
  }) async {
    if (!FirebaseBootstrap.isReady) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      return;
    }

    final requestRef = FirebaseDatabase.instance.ref('requests/$requestId');
    final requestSnapshot = await requestRef.get();
    final requestValue = requestSnapshot.value;
    if (requestValue is Map) {
      final offersStatus = requestValue['offersStatus']?.toString();
      final acceptedOfferId = requestValue['acceptedOfferId']?.toString();
      final status = requestValue['status']?.toString();
      final isLocked = offersStatus == 'accepted' ||
          offersStatus == 'closed' ||
          acceptedOfferId != null ||
          status == 'completed' ||
          status == 'cancelled';
      if (isLocked) {
        throw StateError('Cette demande n’accepte plus de nouvelles offres.');
      }
    }

    final offerRef = requestRef.child('offers').push();
    await offerRef.set({
      'professionalName': offer.professionalName,
      'professionalId': offer.professionalId,
      'planLabel': offer.planLabel,
      'price': offer.price,
      'eta': offer.eta,
      'message': offer.message,
      'phone': offer.phone,
      'accepted': false,
      'highlighted': offer.highlighted,
      'createdAt': ServerValue.timestamp,
    });

    final updatedRequestSnapshot = await requestRef.get();
    final currentValue = updatedRequestSnapshot.value;
    final currentCount =
        currentValue is Map && currentValue['offersCount'] is num
            ? (currentValue['offersCount'] as num).toInt()
            : 0;
    await requestRef.update({
      'offersCount': currentCount + 1,
      'offersStatus': 'open',
      'status': 'awaiting_offers',
    });

    await AppPreferencesService.updateRecentRequestStatus(
      requestId: requestId,
      status: 'awaiting_offers',
      offersStatus: 'open',
      offersCount: currentCount + 1,
    );
  }

  static Future<void> acceptOffer({
    required String requestId,
    required MarketplaceOfferItem offer,
  }) async {
    if (!FirebaseBootstrap.isReady) {
      return;
    }

    final requestRef = FirebaseDatabase.instance.ref('requests/$requestId');
    final offersSnapshot = await requestRef.child('offers').get();
    if (offersSnapshot.value is Map) {
      final updates = <String, Object?>{};
      final offersMap = offersSnapshot.value as Map;
      for (final entry in offersMap.entries) {
        updates['offers/${entry.key}/accepted'] =
            entry.key.toString() == offer.id;
      }
      if (updates.isNotEmpty) {
        await requestRef.update(updates);
      }
    }

    await requestRef.update({
      'status': 'accepted',
      'offersStatus': 'accepted',
      'acceptedOfferId': offer.id,
      'acceptedProfessionalId': offer.professionalId,
      'acceptedProfessionalName': offer.professionalName,
      'acceptedOfferPrice': offer.price,
      'acceptedOfferEta': offer.eta,
      'acceptedAt': ServerValue.timestamp,
    });

    final requestSnapshot = await requestRef.get();
    final currentValue = requestSnapshot.value;
    final currentCount =
        currentValue is Map && currentValue['offersCount'] is num
            ? (currentValue['offersCount'] as num).toInt()
            : null;
    await AppPreferencesService.updateRecentRequestStatus(
      requestId: requestId,
      status: 'accepted',
      offersStatus: 'accepted',
      offersCount: currentCount,
      acceptedProfessionalId: offer.professionalId,
      acceptedProfessionalName: offer.professionalName,
      acceptedOfferPrice: offer.price,
      acceptedOfferEta: offer.eta,
    );
  }
}
