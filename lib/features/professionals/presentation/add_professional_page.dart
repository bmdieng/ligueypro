import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/app_preferences_service.dart';
import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/services/pro_subscription_service.dart';
import '../../../core/theme/app_colors.dart';

class AddProfessionalPage extends StatefulWidget {
  const AddProfessionalPage({super.key});

  @override
  State<AddProfessionalPage> createState() => _AddProfessionalPageState();
}

class _AddProfessionalPageState extends State<AddProfessionalPage> {
  static const List<String> _serviceOptions = [
    'Plombier',
    'Électricien',
    'Ménage',
    'Climatisation',
    'Jardinage',
    'Autre',
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _responseTimeController = TextEditingController(
    text: 'Répond en moins de 15 min',
  );

  String _selectedService = _serviceOptions.first;
  String _selectedPlanId = ProSubscriptionService.plans.first.id;
  bool _availableNow = true;
  bool _isSubscribed = false;
  bool _isSaving = false;

  Future<void> _saveProfessional() async {
    final name = _nameController.text.trim();
    final location = _locationController.text.trim();
    final price = _priceController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || location.isEmpty || price.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final localProfessionalId =
          'professional_${DateTime.now().millisecondsSinceEpoch}';
      final professionalData = {
        'id': localProfessionalId,
        'name': name,
        'service': _selectedService,
        'location': location,
        'price': price,
        'phone': phone,
        'rating': '⭐ 0.0',
        'ratingAverage': 0.0,
        'reviewsCount': 0,
        'distance': 'À confirmer',
        'verified': false,
        'availableNow': _availableNow,
        'subscribed': _isSubscribed,
        'subscriptionPlan': _isSubscribed ? _selectedPlanId : 'none',
        'canReceiveRequests': _isSubscribed,
        'canSendOffers': _isSubscribed,
        'responseTime': _responseTimeController.text.trim().isEmpty
            ? 'Réponse rapide'
            : _responseTimeController.text.trim(),
        'completedJobs': 0,
        'reviews': {},
        'createdAt': ServerValue.timestamp,
      };

      var professionalId = localProfessionalId;

      if (FirebaseBootstrap.isReady) {
        final ref = FirebaseDatabase.instance
            .ref('professionals/$_selectedService')
            .push();
        professionalId = ref.key ?? localProfessionalId;
        professionalData['id'] = professionalId;
        await ref.set(professionalData);
      }

      if (_isSubscribed) {
        await AppPreferencesService.setCurrentProfessional(
          CurrentProfessionalSummary(
            professionalId: professionalId,
            name: name,
            phone: phone,
            service: _selectedService,
            planLabel: _selectedPlanId,
          ),
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Professionnel ajouté avec succès.')),
      );

      _nameController.clear();
      _locationController.clear();
      _priceController.clear();
      _phoneController.clear();
      setState(() => _selectedService = _serviceOptions.first);
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Échec de l’ajout du professionnel. Réessayez.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _phoneController.dispose();
    _responseTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un professionnel')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Informations du professionnel',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du professionnel',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedService,
              decoration: const InputDecoration(
                labelText: 'Service',
                border: OutlineInputBorder(),
              ),
              items: _serviceOptions
                  .map((service) =>
                      DropdownMenuItem(value: service, child: Text(service)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedService = value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Zone d’intervention',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Prix / Tarification',
                prefixIcon: Icon(Icons.payments_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Téléphone',
                prefixIcon: Icon(Icons.phone_outlined),
                hintText: '+221 77 000 00 00',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _responseTimeController,
              decoration: const InputDecoration(
                labelText: 'Délai de réponse estimé',
                prefixIcon: Icon(Icons.bolt_outlined),
                hintText: 'Ex. Répond en moins de 15 min',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _availableNow,
              onChanged: (value) => setState(() => _availableNow = value),
              contentPadding: EdgeInsets.zero,
              title: const Text('Disponible immédiatement'),
              subtitle:
                  const Text('Visible comme disponible dans les résultats.'),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    value: _isSubscribed,
                    onChanged: (value) => setState(() => _isSubscribed = value),
                    contentPadding: EdgeInsets.zero,
                    title:
                        const Text('Abonner ce professionnel à LigueyPro Pro'),
                    subtitle: const Text(
                        'Les abonnés reçoivent les demandes et peuvent émettre des offres.'),
                  ),
                  if (_isSubscribed) ...[
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedPlanId,
                      decoration: const InputDecoration(
                        labelText: 'Plan Pro',
                        border: OutlineInputBorder(),
                      ),
                      items: ProSubscriptionService.plans
                          .map(
                            (plan) => DropdownMenuItem(
                              value: plan.id,
                              child: Text(
                                  '${plan.name} • ${ProSubscriptionService.formatFcfa(plan.priceFcfa)}/mois'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedPlanId = value);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => context.push('/pro-subscription'),
                        icon: const Icon(Icons.workspace_premium_outlined),
                        label: const Text('Voir les détails des abonnements'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _isSaving ? null : _saveProfessional,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navy,
                padding: const EdgeInsets.all(16),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Enregistrer le professionnel'),
            ),
          ],
        ),
      ),
    );
  }
}
