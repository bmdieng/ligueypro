import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/pro_subscription_service.dart';
import '../../../core/services/professional_admin_service.dart';
import '../../../core/services/professional_credit_service.dart';
import '../../../core/theme/app_colors.dart';

class OfferAdminPage extends StatefulWidget {
  const OfferAdminPage({super.key});

  @override
  State<OfferAdminPage> createState() => _OfferAdminPageState();
}

class _OfferAdminPageState extends State<OfferAdminPage> {
  List<ProSubscriptionPlan> _plans = ProSubscriptionService.defaultPlans;
  List<Map<String, dynamic>> _pendingPayments = const [];
  PublicationSettings _publicationSettings = PublicationSettings.defaultSettings;
  final TextEditingController _minJobsController = TextEditingController();
  final TextEditingController _minReviewsController = TextEditingController();
  final TextEditingController _minRatingController = TextEditingController();
  bool _isSaving = false;
  bool _isApproving = false;

  @override
  void initState() {
    super.initState();
    _seedDefaultOffersIfNeeded();
    _loadPlans();
    _loadPublicationSettings();
    _loadPendingPayments();
  }

  Future<void> _loadPublicationSettings() async {
    try {
      final snapshot = await FirebaseDatabase.instance.ref('settings').get();
      final settings = PublicationSettings.fromRoot(snapshot.value);
      if (!mounted) {
        return;
      }
      setState(() {
        _publicationSettings = settings;
        _minJobsController.text = settings.minCompletedJobs.toString();
        _minReviewsController.text = settings.minReviewsCount.toString();
        _minRatingController.text = settings.minRatingAverage.toString();
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _publicationSettings = PublicationSettings.defaultSettings;
          _minJobsController.text =
              PublicationSettings.defaultSettings.minCompletedJobs.toString();
          _minReviewsController.text =
              PublicationSettings.defaultSettings.minReviewsCount.toString();
          _minRatingController.text =
              PublicationSettings.defaultSettings.minRatingAverage.toString();
        });
      }
    }
  }

  Future<void> _savePublicationSettings() async {
    final minJobs = int.tryParse(_minJobsController.text.trim()) ?? 0;
    final minReviews = int.tryParse(_minReviewsController.text.trim()) ?? 0;
    final minRating = double.tryParse(_minRatingController.text.trim()) ?? 0.0;

    final settings = _publicationSettings.copyWith(
      minCompletedJobs: minJobs,
      minReviewsCount: minReviews,
      minRatingAverage: minRating,
    );

    setState(() => _publicationSettings = settings);

    try {
      await FirebaseDatabase.instance.ref('settings/publication').set(settings.toJson());
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Règles de publication enregistrées.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec de l’enregistrement des règles.')),
      );
    }
  }

  Future<void> _seedDefaultOffersIfNeeded() async {
    await ProSubscriptionService.ensureDefaultOffersInFirebase();
  }

  Future<void> _loadPlans() async {
    final snapshot = await FirebaseDatabase.instance.ref('offers').get();
    if (!mounted) {
      return;
    }

    final configuredPlans = ProSubscriptionService.plansFromRoot({
      'offers': snapshot.value,
    });
    setState(() {
      _plans = configuredPlans;
    });
  }

  Future<void> _savePlans() async {
    setState(() => _isSaving = true);
    try {
      final payload = <String, Object>{};
      for (final plan in _plans) {
        payload[plan.id] = plan.toJson();
      }
      await FirebaseDatabase.instance.ref('offers').set(payload);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Offres enregistrées dans le back-office.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec de l’enregistrement des offres.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _loadPendingPayments() async {
    try {
      final pendingPayments = await ProfessionalCreditService.getPendingPayments();
      if (!mounted) {
        return;
      }
      setState(() {
        _pendingPayments = pendingPayments;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _pendingPayments = const []);
      }
    }
  }

  Future<void> _approvePayment(Map<String, dynamic> payment) async {
    final paymentId = payment['paymentId']?.toString();
    final professionalId = payment['professionalId']?.toString();
    final professionalService = payment['professionalService']?.toString() ?? 'professionals';
    final offerId = payment['offerId']?.toString();

    if (paymentId == null || professionalId == null || offerId == null) {
      return;
    }

    setState(() => _isApproving = true);
    try {
      await ProfessionalCreditService.approvePaymentAndCredit(
        paymentId: paymentId,
        professionalId: professionalId,
        professionalService: professionalService,
        offerId: offerId,
      );
      await _loadPendingPayments();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paiement validé et crédits ajoutés.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de valider ce paiement.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isApproving = false);
      }
    }
  }

  Future<void> _showEditDialog({ProSubscriptionPlan? existing}) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final priceController = TextEditingController(
      text: existing == null ? '5000' : existing.priceFcfa.toString(),
    );
    final leadsController = TextEditingController(
      text: existing == null ? '10' : existing.leadsPerMonth.toString(),
    );
    final billingController = TextEditingController(
      text: existing?.billingLabel ?? '/mois',
    );
    final paymentController = TextEditingController(
      text: existing?.paymentMethod ?? 'Orange Money',
    );
    final featureController = TextEditingController(
      text: existing == null ? '' : existing.features.join('\n'),
    );

    final result = await showDialog<ProSubscriptionPlan?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Nouvelle offre' : 'Modifier l’offre'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de l’offre',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Prix en FCFA',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: leadsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Demandes incluses',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: billingController,
                  decoration: const InputDecoration(
                    labelText: 'Libellé de facturation',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: paymentController,
                  decoration: const InputDecoration(
                    labelText: 'Paiement',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: featureController,
                  minLines: 3,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Avantages (un par ligne)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final price = int.tryParse(priceController.text.trim()) ?? 0;
              final leads = int.tryParse(leadsController.text.trim()) ?? 0;
              final billing = billingController.text.trim();
              final paymentMethod = paymentController.text.trim();
              final featureList = featureController.text
                  .split('\n')
                  .map((feature) => feature.trim())
                  .where((feature) => feature.isNotEmpty)
                  .toList();

              if (name.isEmpty || price <= 0 || leads <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Renseignez un nom, un prix et des demandes valides.')),
                );
                return;
              }

              final id = (existing?.id ?? name).toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
              Navigator.of(context).pop(
                ProSubscriptionPlan(
                  id: id,
                  name: name,
                  priceFcfa: price,
                  leadsPerMonth: leads,
                  billingLabel: billing.isEmpty ? '/mois' : billing,
                  paymentMethod: paymentMethod.isEmpty ? 'Orange Money' : paymentMethod,
                  features: featureList.isEmpty
                      ? ['Offre paramétrée depuis le back-office']
                      : featureList,
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      final index = _plans.indexWhere((plan) => plan.id == result.id);
      if (index >= 0) {
        _plans[index] = result;
      } else {
        _plans.add(result);
      }
    });
  }

  @override
  void dispose() {
    _minJobsController.dispose();
    _minReviewsController.dispose();
    _minRatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Offres / packs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => context.go('/admin-professionals'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Paramétrage des offres visibles par les professionnels',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _savePlans,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(_isSaving ? 'Enregistrement...' : 'Enregistrer'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Règles de publication des profils non pro',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minJobsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Missions minimum',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _minReviewsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Avis minimum',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _minRatingController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Note moyenne minimum (ex: 4.0)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Les profils non pro restent visibles uniquement s’ils dépassent les seuils ci-dessus.',
                          style: TextStyle(color: AppColors.muted, fontSize: 12),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _savePublicationSettings,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Sauvegarder'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.receipt_long_outlined, color: AppColors.navy),
                      const SizedBox(width: 10),
                      const Text(
                        'Paiements en attente',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                      const Spacer(),
                      if (_isApproving)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_pendingPayments.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Aucun paiement à valider pour le moment.'),
                    )
                  else
                    ..._pendingPayments.map(
                      (payment) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    payment['professionalName']?.toString() ?? 'Professionnel',
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('${payment['paymentMethod'] ?? 'Paiement'} • ${payment['amountFcfa'] ?? 0} FCFA'),
                                  Text('Pack: ${payment['offerId'] ?? 'inconnu'}'),
                                ],
                              ),
                            ),
                            FilledButton(
                              onPressed: () => _approvePayment(payment),
                              style: FilledButton.styleFrom(backgroundColor: AppColors.success),
                              child: const Text('Valider'),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _plans.length,
                itemBuilder: (context, index) {
                  final plan = _plans[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        '${plan.name} • ${ProSubscriptionService.formatFcfa(plan.priceFcfa)}${plan.billingLabel}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('${plan.leadsPerMonth} demandes incluses'),
                          Text('Paiement : ${plan.paymentMethod}'),
                          const SizedBox(height: 8),
                          ...plan.features.map(
                            (feature) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check, size: 16, color: AppColors.success),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(feature)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        tooltip: 'Modifier',
                        onPressed: () => _showEditDialog(existing: plan),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditDialog(),
        backgroundColor: AppColors.navy,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Nouvelle offre'),
      ),
    );
  }
}
