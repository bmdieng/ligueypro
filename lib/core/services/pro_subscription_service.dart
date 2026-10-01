import 'package:firebase_database/firebase_database.dart';

class ProSubscriptionPlan {
  const ProSubscriptionPlan({
    required this.id,
    required this.name,
    required this.priceFcfa,
    required this.leadsPerMonth,
    required this.billingLabel,
    required this.paymentMethod,
    required this.features,
  });

  final String id;
  final String name;
  final int priceFcfa;
  final int leadsPerMonth;
  final String billingLabel;
  final String paymentMethod;
  final List<String> features;

  Map<String, Object> toJson() => {
        'id': id,
        'name': name,
        'priceFcfa': priceFcfa,
        'leadsPerMonth': leadsPerMonth,
        'billingLabel': billingLabel,
        'paymentMethod': paymentMethod,
        'features': features,
      };
}

class ProSubscriptionService {
  ProSubscriptionService._();

  static const paymentOptions = ['Orange Money', 'Wave'];

  static const List<ProSubscriptionPlan> defaultPlans = [
    ProSubscriptionPlan(
      id: 'starter',
      name: 'Starter',
      priceFcfa: 5000,
      leadsPerMonth: 10,
      billingLabel: '/mois',
      paymentMethod: 'Orange Money',
      features: [
        '10 demandes incluses par mois',
        'Profil visible dans les résultats',
        'Réception des demandes qualifiées',
      ],
    ),
    ProSubscriptionPlan(
      id: 'plus',
      name: 'Plus',
      priceFcfa: 12000,
      leadsPerMonth: 25,
      billingLabel: '/mois',
      paymentMethod: 'Wave',
      features: [
        '25 demandes incluses par mois',
        'Mise en avant dans votre ville',
        'Meilleure visibilité pour capter plus de clients',
      ],
    ),
    ProSubscriptionPlan(
      id: 'premium',
      name: 'Premium',
      priceFcfa: 25000,
      leadsPerMonth: 60,
      billingLabel: '/mois',
      paymentMethod: 'Orange Money',
      features: [
        '60 demandes incluses par mois',
        'Priorité dans les résultats',
        'Support plus réactif et meilleure exposition',
      ],
    ),
    ProSubscriptionPlan(
      id: 'boost',
      name: 'Boost profil',
      priceFcfa: 3000,
      leadsPerMonth: 7,
      billingLabel: '/7 jours',
      paymentMethod: 'Wave',
      features: [
        'Apparition en tête des résultats',
        'Visibilité locale pendant 7 jours',
        'Idéal pour booster une activité rapidement',
      ],
    ),
  ];

  static List<ProSubscriptionPlan> _runtimePlans = List.unmodifiable(defaultPlans);

  static List<ProSubscriptionPlan> get plans => _runtimePlans;

  static Map<String, Object> defaultOffersPayload() {
    final payload = <String, Object>{};
    for (final plan in defaultPlans) {
      payload[plan.id] = plan.toJson();
    }
    return payload;
  }

  static Future<void> ensureDefaultOffersInFirebase() async {
    try {
      final snapshot = await FirebaseDatabase.instance.ref('offers').get();
      final currentValue = snapshot.value;
      final parsedOffers = plansFromRoot({'offers': currentValue});
      if (parsedOffers.isNotEmpty && currentValue != null) {
        return;
      }
      await FirebaseDatabase.instance.ref('offers').set(defaultOffersPayload());
    } catch (_) {
      // If Firebase is unavailable, keep the built-in defaults so the app still works.
    }
  }

  static void hydratePlansFromRoot(Object? root) {
    final parsed = plansFromRoot(root);
    if (parsed.isNotEmpty) {
      _runtimePlans = List.unmodifiable(parsed);
    }
  }

  static List<ProSubscriptionPlan> plansFromRoot(Object? root) {
    final rootMap = root is Map ? root : const <String, Object>{};
    final offersRoot = rootMap['offers'] ?? rootMap['pricing'];
    final parsedOffers = <ProSubscriptionPlan>[];

    void collect(Object? value) {
      if (value is Map) {
        final planLikeEntries = value.entries.where((entry) {
          final nested = entry.value;
          return nested is Map &&
              (nested['priceFcfa'] != null || nested['name'] != null);
        }).toList();

        if (planLikeEntries.isNotEmpty) {
          for (final entry in planLikeEntries) {
            final planMap = entry.value as Map;
            final rawId = planMap['id']?.toString() ?? entry.key.toString();
            final rawName = planMap['name']?.toString() ?? rawId;
            final rawPrice = planMap['priceFcfa'];
            final rawLeads = planMap['leadsPerMonth'];
            final rawBilling = planMap['billingLabel']?.toString() ?? '/mois';
            final paymentMethod =
                planMap['paymentMethod']?.toString() ?? 'Orange Money';
            final rawFeatures = planMap['features'];

            final parsedFeatures = <String>[];
            if (rawFeatures is List) {
              for (final feature in rawFeatures) {
                final valueText = feature?.toString();
                if (valueText != null && valueText.trim().isNotEmpty) {
                  parsedFeatures.add(valueText.trim());
                }
              }
            }

            final priceValue = rawPrice is num ? rawPrice.toInt() : 0;
            final leadsValue = rawLeads is num ? rawLeads.toInt() : 0;

            parsedOffers.add(
              ProSubscriptionPlan(
                id: rawId,
                name: rawName,
                priceFcfa: priceValue,
                leadsPerMonth: leadsValue,
                billingLabel: rawBilling,
                paymentMethod: paymentMethod,
                features: parsedFeatures.isEmpty
                    ? ['Offre configurée depuis le back-office']
                    : parsedFeatures,
              ),
            );
          }
          return;
        }

        final rawId = value['id']?.toString();
        final rawName = value['name']?.toString();
        final rawPrice = value['priceFcfa'];
        final rawLeads = value['leadsPerMonth'];
        final rawBilling = value['billingLabel']?.toString() ?? '/mois';
        final paymentMethod = value['paymentMethod']?.toString() ?? 'Orange Money';
        final rawFeatures = value['features'];

        if ((rawId != null || rawName != null) && rawPrice is num) {
          final parsedFeatures = <String>[];
          if (rawFeatures is List) {
            for (final feature in rawFeatures) {
              final valueText = feature?.toString();
              if (valueText != null && valueText.trim().isNotEmpty) {
                parsedFeatures.add(valueText.trim());
              }
            }
          }

          parsedOffers.add(
            ProSubscriptionPlan(
              id: rawId ?? rawName!.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-'),
              name: rawName ?? 'Offre',
              priceFcfa: rawPrice.toInt(),
              leadsPerMonth: rawLeads is num ? rawLeads.toInt() : 0,
              billingLabel: rawBilling,
              paymentMethod: paymentMethod,
              features: parsedFeatures.isEmpty
                  ? ['Offre configurée depuis le back-office']
                  : parsedFeatures,
            ),
          );
          return;
        }
      }

      if (value is List) {
        for (final item in value) {
          collect(item);
        }
      }
    }

    collect(offersRoot);

    if (parsedOffers.isNotEmpty) {
      return parsedOffers;
    }

    return List<ProSubscriptionPlan>.from(defaultPlans);
  }

  static String _encodePaymentParam(String value) {
    return Uri.encodeQueryComponent(value.trim());
  }

  static Uri buildPaymentDeepLink({
    required String paymentMethod,
    required int amountFcfa,
    required String professionalName,
  }) {
    final normalizedMethod = paymentMethod.toLowerCase();
    final encodedName = _encodePaymentParam(
      professionalName.isEmpty ? 'professionnel' : professionalName,
    );

    if (normalizedMethod.contains('orange')) {
      return Uri.parse(
        'orange-money://pay?amount=$amountFcfa&name=$encodedName&source=ligueypro',
      );
    }

    if (normalizedMethod.contains('wave')) {
      return Uri.parse(
        'wave://pay?amount=$amountFcfa&name=$encodedName&source=ligueypro',
      );
    }

    final fallbackQuery = _encodePaymentParam(
      'paiement $paymentMethod $amountFcfa FCFA',
    );
    return Uri.parse('https://www.google.com/search?q=$fallbackQuery');
  }

  static Uri buildPaymentFallbackUrl({
    required String paymentMethod,
    required int amountFcfa,
  }) {
    final normalizedMethod = paymentMethod.toLowerCase();
    if (normalizedMethod.contains('orange')) {
      return Uri.parse(
        'https://play.google.com/store/apps/details?id=com.orange.money',
      );
    }

    if (normalizedMethod.contains('wave')) {
      return Uri.parse(
        'https://play.google.com/store/search?q=wave%20money&c=apps',
      );
    }

    final fallbackQuery = _encodePaymentParam('paiement $paymentMethod');
    return Uri.parse('https://www.google.com/search?q=$fallbackQuery');
  }

  static String formatFcfa(int amount) {
    final digits = amount.toString();
    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      final reverseIndex = digits.length - index;
      buffer.write(digits[index]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write(' ');
      }
    }
    return '${buffer.toString()} FCFA';
  }
}
