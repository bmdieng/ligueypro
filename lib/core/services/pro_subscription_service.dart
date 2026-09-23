class ProSubscriptionPlan {
  const ProSubscriptionPlan({
    required this.id,
    required this.name,
    required this.priceFcfa,
    required this.leadsPerMonth,
    required this.features,
  });

  final String id;
  final String name;
  final int priceFcfa;
  final int leadsPerMonth;
  final List<String> features;
}

class ProSubscriptionService {
  ProSubscriptionService._();

  static const plans = [
    ProSubscriptionPlan(
      id: 'starter',
      name: 'Starter',
      priceFcfa: 9900,
      leadsPerMonth: 20,
      features: [
        'Recevoir des demandes qualifiées',
        'Émettre des offres aux clients',
        'Profil visible dans les résultats',
      ],
    ),
    ProSubscriptionPlan(
      id: 'pro',
      name: 'Pro',
      priceFcfa: 19900,
      leadsPerMonth: 80,
      features: [
        'Toutes les demandes de votre zone',
        'Offres prioritaires',
        'Badge Abonné Pro',
        'Statistiques et support prioritaire',
      ],
    ),
    ProSubscriptionPlan(
      id: 'business',
      name: 'Business',
      priceFcfa: 49900,
      leadsPerMonth: 250,
      features: [
        'Équipe multi-agents',
        'Reporting avancé',
        'API et intégrations',
        'Accompagnement commercial',
      ],
    ),
  ];

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
