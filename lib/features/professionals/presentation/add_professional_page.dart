import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../core/services/app_preferences_service.dart';
import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/services/pro_subscription_service.dart';
import '../../../core/services/professional_admin_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

class AddProfessionalPage extends StatefulWidget {
  const AddProfessionalPage({super.key});

  @override
  State<AddProfessionalPage> createState() => _AddProfessionalPageState();
}

class _AddProfessionalPageState extends State<AddProfessionalPage> {
  List<String> _serviceOptions = const [];
  bool _isLoadingServices = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _responseTimeController = TextEditingController(
    text: 'Répond en moins de 15 min',
  );

  String _selectedService = '';
  final String _selectedPlanId = ProSubscriptionService.plans.first.id;
  bool _availableNow = true;
  final bool _isSubscribed = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadServiceOptions();
  }

  Future<void> _loadServiceOptions() async {
    if (!FirebaseBootstrap.isReady) {
      if (!mounted) return;
      setState(() {
        _serviceOptions = const [];
        _selectedService = '';
        _isLoadingServices = false;
      });
      return;
    }

    try {
      final snapshot =
          await FirebaseDatabase.instance.ref('home/categories').get();
      final loadedOptions =
          ProfessionalAdminService.serviceOptionsFromCategories(
        snapshot.value,
      );

      if (!mounted) return;
      setState(() {
        _serviceOptions = loadedOptions;
        if (_serviceOptions.isEmpty) {
          _selectedService = '';
        } else if (_selectedService.isEmpty ||
            !_serviceOptions.contains(_selectedService)) {
          _selectedService = _serviceOptions.first;
        }
        _isLoadingServices = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _serviceOptions = const [];
        _selectedService = '';
        _isLoadingServices = false;
      });
    }
  }

  Future<void> _saveProfessional() async {
    final l10n = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    final location = _locationController.text.trim();
    final price = _priceController.text.trim();
    final phone = _phoneController.text.trim();

    if (_selectedService.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addProfessionalNoService)),
      );
      return;
    }

    if (name.isEmpty || location.isEmpty || price.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addProfessionalFillAll)),
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
        'distance': l10n.serviceSearchDefaultPrice,
        'verified': false,
        'availableNow': _availableNow,
        'subscribed': _isSubscribed,
        'subscriptionPlan': _isSubscribed ? _selectedPlanId : 'none',
        'canReceiveRequests': _isSubscribed,
        'canSendOffers': _isSubscribed,
        'responseTime': _responseTimeController.text.trim().isEmpty
            ? l10n.serviceSearchDefaultResponseTime
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

      await AppPreferencesService.setCurrentProfessional(
        CurrentProfessionalSummary(
          professionalId: professionalId,
          name: name,
          phone: phone,
          service: _selectedService,
          planLabel: _isSubscribed ? _selectedPlanId : 'none',
          isSubscribed: _isSubscribed,
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addProfessionalSuccess)),
      );

      _nameController.clear();
      _locationController.clear();
      _priceController.clear();
      _phoneController.clear();
      setState(() => _selectedService =
          _serviceOptions.isEmpty ? '' : _serviceOptions.first);
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addProfessionalSaveFailed)),
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileAddProfessional)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.addProfessionalInfoTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.addProfessionalNameLabel,
                prefixIcon: const Icon(Icons.person_outline),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _serviceOptions.contains(_selectedService)
                  ? _selectedService
                  : null,
              decoration: InputDecoration(
                labelText: l10n.addProfessionalServiceLabel,
                border: const OutlineInputBorder(),
                suffixIcon: _isLoadingServices
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
              ),
              items: _serviceOptions
                  .map((service) =>
                      DropdownMenuItem(value: service, child: Text(service)))
                  .toList(),
              onChanged: _isLoadingServices
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _selectedService = value);
                      }
                    },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: l10n.addProfessionalLocationLabel,
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: l10n.addProfessionalPriceLabel,
                prefixIcon: const Icon(Icons.payments_outlined),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: l10n.addProfessionalPhoneLabel,
                prefixIcon: const Icon(Icons.phone_outlined),
                hintText: l10n.addProfessionalPhoneHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _responseTimeController,
              decoration: InputDecoration(
                labelText: l10n.addProfessionalResponseLabel,
                prefixIcon: const Icon(Icons.bolt_outlined),
                hintText: l10n.addProfessionalResponseHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _availableNow,
              onChanged: (value) => setState(() => _availableNow = value),
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.addProfessionalAvailableNowTitle),
              subtitle: Text(l10n.addProfessionalAvailableNowSubtitle),
            ),
            const SizedBox(height: 8),
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: AppColors.primary.withValues(alpha: 0.08),
            //     borderRadius: BorderRadius.circular(18),
            //     border: Border.all(
            //       color: AppColors.primary.withValues(alpha: 0.18),
            //     ),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       SwitchListTile(
            //         value: _isSubscribed,
            //         onChanged: (value) => setState(() => _isSubscribed = value),
            //         contentPadding: EdgeInsets.zero,
            //         title:
            //             const Text('Abonner ce professionnel à LigueyPro Premium'),
            //         subtitle: const Text(
            //             'Les abonnés reçoivent les demandes et peuvent émettre des offres.'),
            //       ),
            //       if (_isSubscribed) ...[
            //         const SizedBox(height: 8),
            //         DropdownButtonFormField<String>(
            //           initialValue: _selectedPlanId,
            //           decoration: const InputDecoration(
            //             labelText: 'Plan Premium',
            //             border: OutlineInputBorder(),
            //           ),
            //           items: ProSubscriptionService.plans
            //               .map(
            //                 (plan) => DropdownMenuItem(
            //                   value: plan.id,
            //                   child: Text(
            //                       '${plan.name} • ${ProSubscriptionService.formatFcfa(plan.priceFcfa)}/mois'),
            //                 ),
            //               )
            //               .toList(),
            //           onChanged: (value) {
            //             if (value != null) {
            //               setState(() => _selectedPlanId = value);
            //             }
            //           },
            //         ),
            //         const SizedBox(height: 8),
            //         Align(
            //           alignment: Alignment.centerLeft,
            //           child: TextButton.icon(
            //             onPressed: () => context.push('/pro-subscription'),
            //             icon: const Icon(Icons.workspace_premium_outlined),
            //             label: const Text('Voir les détails des abonnements'),
            //           ),
            //         ),
            //       ],
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 20),
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
                  : Text(l10n.addProfessionalSave),
            ),
          ],
        ),
      ),
    );
  }
}
