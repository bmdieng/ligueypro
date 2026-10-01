import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/app_preferences_service.dart';
import '../../../core/services/pro_subscription_service.dart';
import '../../../core/services/professional_credit_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

class ProSubscriptionPage extends StatefulWidget {
  const ProSubscriptionPage({super.key});

  @override
  State<ProSubscriptionPage> createState() => _ProSubscriptionPageState();
}

class _ProSubscriptionPageState extends State<ProSubscriptionPage> {
  List<ProSubscriptionPlan> _plans = ProSubscriptionService.defaultPlans;
  String _selectedPlanId = ProSubscriptionService.defaultPlans.first.id;
  bool _isSubmitting = false;
  CurrentProfessionalSummary? _currentProfessional;

  @override
  void initState() {
    super.initState();
    _seedDefaultOffersIfNeeded();
    _loadPlans();
    _loadCurrentProfessional();
  }

  Future<void> _seedDefaultOffersIfNeeded() async {
    await ProSubscriptionService.ensureDefaultOffersInFirebase();
  }

  Future<void> _loadCurrentProfessional() async {
    final summary = await AppPreferencesService.getCurrentProfessional();
    if (!mounted) {
      return;
    }
    setState(() {
      _currentProfessional = summary;
    });
  }

  Future<void> _loadPlans() async {
    final snapshot = await FirebaseDatabase.instance.ref().get();
    if (!mounted) {
      return;
    }

    final configuredPlans = ProSubscriptionService.plansFromRoot(snapshot.value);
    setState(() {
      _plans = configuredPlans;
      _selectedPlanId = configuredPlans.first.id;
    });
  }

  Future<void> _activatePlan() async {
    final selectedPlan = _plans.firstWhere(
      (plan) => plan.id == _selectedPlanId,
      orElse: () => _plans.first,
    );

    if (_currentProfessional == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun profil professionnel actif. Sélectionnez votre compte pour continuer.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ProfessionalCreditService.createPaymentRequest(
        professionalId: _currentProfessional!.professionalId,
        professionalName: _currentProfessional!.name,
        professionalService: _currentProfessional!.service,
        offerId: selectedPlan.id,
        amountFcfa: selectedPlan.priceFcfa,
        paymentMethod: selectedPlan.paymentMethod,
      );

      final paymentDeepLink = ProSubscriptionService.buildPaymentDeepLink(
        paymentMethod: selectedPlan.paymentMethod,
        amountFcfa: selectedPlan.priceFcfa,
        professionalName: _currentProfessional!.name,
      );
      final fallbackUrl = ProSubscriptionService.buildPaymentFallbackUrl(
        paymentMethod: selectedPlan.paymentMethod,
        amountFcfa: selectedPlan.priceFcfa,
      );

      if (await canLaunchUrl(paymentDeepLink)) {
        await launchUrl(paymentDeepLink, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(fallbackUrl)) {
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Paiement ${selectedPlan.paymentMethod} préparé pour ${selectedPlan.name}. Ouvrez l’application puis confirmez le paiement.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le paiement n’a pas pu être enregistré. Réessayez.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedPlan = _plans.firstWhere(
      (plan) => plan.id == _selectedPlanId,
      orElse: () => _plans.first,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.proSubscriptionTitle)),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acheter un pack pour recevoir plus de demandes',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Paiement local simple : Orange Money ou Wave. Plus besoin d’une vraie version Pro séparée.',
                    style: const TextStyle(color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ProSubscriptionService.paymentOptions
                        .map(
                          (method) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              method,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ..._plans.map(
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
                              '${ProSubscriptionService.formatFcfa(plan.priceFcfa)}${plan.billingLabel}',
                              style: const TextStyle(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.proSubscriptionLeadsIncluded(plan.leadsPerMonth),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pack sélectionné : ${selectedPlan.name}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${ProSubscriptionService.formatFcfa(selectedPlan.priceFcfa)} • Paiement ${selectedPlan.paymentMethod}',
                    style: const TextStyle(height: 1.45),
                  ),
                ],
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
                : Text('Payer ${selectedPlan.name} • ${ProSubscriptionService.formatFcfa(selectedPlan.priceFcfa)}'),
          ),
        ),
      ),
    );
  }
}
