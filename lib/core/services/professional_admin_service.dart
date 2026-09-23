import 'package:firebase_database/firebase_database.dart';

class ProfessionalAdminDraft {
  const ProfessionalAdminDraft({
    this.id,
    this.existingService,
    required this.name,
    required this.service,
    required this.location,
    required this.price,
    required this.phone,
    required this.responseTime,
    required this.availableNow,
    required this.verified,
    required this.subscribed,
    required this.subscriptionPlan,
    required this.completedJobs,
    this.ratingAverage = 0,
    this.reviewsCount = 0,
  });

  final String? id;
  final String? existingService;
  final String name;
  final String service;
  final String location;
  final String price;
  final String phone;
  final String responseTime;
  final bool availableNow;
  final bool verified;
  final bool subscribed;
  final String subscriptionPlan;
  final int completedJobs;
  final double ratingAverage;
  final int reviewsCount;
}

class ProfessionalAdminItem {
  const ProfessionalAdminItem({
    required this.id,
    required this.name,
    required this.service,
    required this.location,
    required this.price,
    required this.phone,
    required this.responseTime,
    required this.availableNow,
    required this.verified,
    required this.subscribed,
    required this.subscriptionPlan,
    required this.completedJobs,
    required this.ratingAverage,
    required this.reviewsCount,
    required this.path,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String service;
  final String location;
  final String price;
  final String phone;
  final String responseTime;
  final bool availableNow;
  final bool verified;
  final bool subscribed;
  final String subscriptionPlan;
  final int completedJobs;
  final double ratingAverage;
  final int reviewsCount;
  final String path;
  final DateTime? createdAt;
}

class ProfessionalAdminService {
  ProfessionalAdminService._();

  static List<String> serviceOptionsFromRoot(Object? root) {
    final home = root is Map ? root['home'] : null;
    final categories = home is Map ? home['categories'] : null;
    return serviceOptionsFromCategories(categories);
  }

  static List<String> serviceOptionsFromCategories(Object? categoriesRoot) {
    final entries = <_CategoryEntry>[];
    var fallbackOrder = 0;

    void collect(Object? value) {
      if (value is Map) {
        final label = value['label']?.toString();
        if (label != null && label.trim().isNotEmpty) {
          final rawOrder = value['order'];
          final order = rawOrder is num
              ? rawOrder.toInt()
              : int.tryParse(rawOrder?.toString() ?? '') ?? fallbackOrder;
          entries.add(_CategoryEntry(label.trim(), order));
          fallbackOrder++;
          return;
        }

        for (final item in value.values) {
          collect(item);
        }
        return;
      }

      if (value is List) {
        for (final item in value) {
          collect(item);
        }
      }
    }

    collect(categoriesRoot);

    entries.sort((a, b) {
      if (a.order != b.order) {
        return a.order.compareTo(b.order);
      }
      return a.label.toLowerCase().compareTo(b.label.toLowerCase());
    });

    final seen = <String>{};
    return entries
        .where((entry) => seen.add(entry.label.toLowerCase()))
        .map((entry) => entry.label)
        .toList();
  }

  static List<ProfessionalAdminItem> professionalsFromRoot(Object? root) {
    final professionalsRoot = root is Map ? root['professionals'] : null;
    return professionalsFromSnapshot(professionalsRoot);
  }

  static List<ProfessionalAdminItem> professionalsFromSnapshot(
    Object? snapshotValue,
  ) {
    final professionals = <ProfessionalAdminItem>[];

    if (snapshotValue is Map) {
      for (final serviceEntry in snapshotValue.entries) {
        final serviceValue = serviceEntry.value;
        if (serviceValue is! Map) {
          continue;
        }

        for (final professionalEntry in serviceValue.entries) {
          final value = professionalEntry.value;
          if (value is! Map) {
            continue;
          }

          final name = value['name']?.toString().trim();
          if (name == null || name.isEmpty) {
            continue;
          }

          final rawRating = value['ratingAverage'];
          final rawReviewsCount = value['reviewsCount'];
          final rawCompletedJobs = value['completedJobs'];
          final rawCreatedAt = value['createdAt'];

          professionals.add(
            ProfessionalAdminItem(
              id: value['id']?.toString() ?? professionalEntry.key.toString(),
              name: name,
              service: value['service']?.toString().trim().isNotEmpty == true
                  ? value['service'].toString().trim()
                  : serviceEntry.key.toString(),
              location: value['location']?.toString().trim().isNotEmpty == true
                  ? value['location'].toString().trim()
                  : 'Localisation non renseignée',
              price: value['price']?.toString().trim().isNotEmpty == true
                  ? value['price'].toString().trim()
                  : 'Tarif à confirmer',
              phone: value['phone']?.toString().trim() ?? '',
              responseTime:
                  value['responseTime']?.toString().trim().isNotEmpty == true
                      ? value['responseTime'].toString().trim()
                      : 'Temps de réponse non renseigné',
              availableNow: value['availableNow'] != false,
              verified: value['verified'] == true,
              subscribed: value['subscribed'] == true,
              subscriptionPlan: value['subscriptionPlan']?.toString() ?? 'none',
              completedJobs:
                  rawCompletedJobs is num ? rawCompletedJobs.toInt() : 0,
              ratingAverage: rawRating is num ? rawRating.toDouble() : 0,
              reviewsCount:
                  rawReviewsCount is num ? rawReviewsCount.toInt() : 0,
              path:
                  'professionals/${serviceEntry.key}/${professionalEntry.key}',
              createdAt: rawCreatedAt is num
                  ? DateTime.fromMillisecondsSinceEpoch(rawCreatedAt.toInt())
                  : null,
            ),
          );
        }
      }
    }

    professionals.sort((a, b) {
      if (a.subscribed != b.subscribed) {
        return a.subscribed ? -1 : 1;
      }
      if (a.verified != b.verified) {
        return a.verified ? -1 : 1;
      }
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return professionals;
  }

  static Future<void> saveProfessional(ProfessionalAdminDraft draft) async {
    final professionalsRef = FirebaseDatabase.instance.ref('professionals');
    final existingService = draft.existingService ?? draft.service;
    final hasExistingId = draft.id != null && draft.id!.trim().isNotEmpty;

    DatabaseReference targetRef;
    String professionalId;

    if (hasExistingId) {
      professionalId = draft.id!.trim();
      targetRef = professionalsRef.child('${draft.service}/$professionalId');
    } else {
      targetRef = professionalsRef.child(draft.service).push();
      professionalId = targetRef.key ??
          'professional_${DateTime.now().millisecondsSinceEpoch}';
      targetRef = professionalsRef.child('${draft.service}/$professionalId');
    }

    final payload = <String, Object>{
      'id': professionalId,
      'name': draft.name,
      'service': draft.service,
      'location': draft.location,
      'price': draft.price,
      'phone': draft.phone,
      'rating': '⭐ ${draft.ratingAverage.toStringAsFixed(1)}',
      'ratingAverage': draft.ratingAverage,
      'reviewsCount': draft.reviewsCount,
      'distance': 'À confirmer',
      'verified': draft.verified,
      'availableNow': draft.availableNow,
      'subscribed': draft.subscribed,
      'subscriptionPlan': draft.subscribed ? draft.subscriptionPlan : 'none',
      'canReceiveRequests': draft.subscribed,
      'canSendOffers': draft.subscribed,
      'responseTime': draft.responseTime,
      'completedJobs': draft.completedJobs,
      'updatedAt': ServerValue.timestamp,
    };

    if (!hasExistingId) {
      payload['reviews'] = <String, Object>{};
      payload['createdAt'] = ServerValue.timestamp;
    }

    if (hasExistingId && existingService != draft.service) {
      final previousRef =
          professionalsRef.child('$existingService/$professionalId');
      final previousSnapshot = await previousRef.get();
      final previousValue = previousSnapshot.value;
      if (previousValue is Map) {
        final merged = Map<String, Object>.from(
          previousValue.map(
            (key, value) => MapEntry(key.toString(), value as Object),
          ),
        )..addAll(payload);
        await targetRef.set(merged);
        await previousRef.remove();
        return;
      }
    }

    if (hasExistingId) {
      await targetRef.update(payload);
    } else {
      await targetRef.set(payload);
    }
  }

  static Future<void> deleteProfessional(ProfessionalAdminItem professional) {
    return FirebaseDatabase.instance.ref(professional.path).remove();
  }
}

class _CategoryEntry {
  const _CategoryEntry(this.label, this.order);

  final String label;
  final int order;
}
