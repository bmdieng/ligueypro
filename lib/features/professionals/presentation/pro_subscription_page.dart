import 'package:flutter/material.dart';

import '../../../core/services/pro_subscription_service.dart';
import '../../../core/theme/app_colors.dart';

class ProSubscriptionPage extends StatefulWidget {
  const ProSubscriptionPage({super.key});

  @override
  State<ProSubscriptionPage> createState() => _ProSubscriptionPageState();
}

class _ProSubscriptionPageState extends State<ProSubscriptionPage> {
  String _selectedPlanId = ProSubscriptionService.plans[1].id;
  bool _isSubmitting = false;

  Future<void> _activatePlan() async {
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Abonnement Pro simulé activé. Branchez ensuite votre moyen d’encaissement réel.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedPlan = ProSubscriptionService.plans.firstWhere(
      (plan) => plan.id == _selectedPlanId,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Abonnement Pro')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.navy, Color(0xFF1D5D90)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recevez des demandes et envoyez des offres',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'L’abonnement remplace le paiement client dans l’app. Les professionnels paient pour recevoir des opportunités et répondre avec leurs offres.',
                    style: TextStyle(color: Colors.white70, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...ProSubscriptionService.plans.map(
              (plan) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => setState(() => _selectedPlanId = plan.id),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _selectedPlanId == plan.id
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.08),
                        width: _selectedPlanId == plan.id ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                plan.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              '${ProSubscriptionService.formatFcfa(plan.priceFcfa)}/mois',
                              style: const TextStyle(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${plan.leadsPerMonth} demandes incluses par mois',
                          style: const TextStyle(color: AppColors.muted),
                        ),
                        const SizedBox(height: 10),
                        ...plan.features.map(
                          (feature) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Icon(Icons.check_circle,
                                      size: 16, color: AppColors.success),
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(feature)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.18)),
              ),
              child: Text(
                'Plan choisi : ${selectedPlan.name}. Les professionnels abonnés peuvent recevoir les demandes et proposer leurs offres sans encaissement client dans l’application.',
                style: const TextStyle(height: 1.45),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _isSubmitting ? null : _activatePlan,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.navy,
              padding: const EdgeInsets.all(16),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Text('Choisir ${selectedPlan.name}'),
          ),
        ),
      ),
    );
  }
}
