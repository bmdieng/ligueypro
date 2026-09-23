import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/services/pro_subscription_service.dart';
import '../../../core/services/professional_admin_service.dart';
import '../../../core/theme/app_colors.dart';

class ProfessionalsAdminPage extends StatelessWidget {
  const ProfessionalsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Professionnels'),
        actions: [
          IconButton(
            tooltip: 'Retour BO',
            onPressed: () => context.go('/back-office'),
            icon: const Icon(Icons.dashboard_customize_outlined),
          ),
        ],
      ),
      body: !FirebaseBootstrap.isReady
          ? const _FirebaseRequiredState()
          : StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance.ref().onValue,
              builder: (context, snapshot) {
                final root = snapshot.data?.snapshot.value;
                final professionals =
                    ProfessionalAdminService.professionalsFromRoot(root);
                final serviceOptions =
                    ProfessionalAdminService.serviceOptionsFromRoot(root);

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1240),
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _HeaderCard(
                          professionalsCount: professionals.length,
                          subscribedCount: professionals
                              .where((item) => item.subscribed)
                              .length,
                          verifiedCount: professionals
                              .where((item) => item.verified)
                              .length,
                          onCreate: serviceOptions.isEmpty
                              ? null
                              : () => _showProfessionalForm(
                                    context,
                                    serviceOptions: serviceOptions,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        if (serviceOptions.isEmpty)
                          const _MissingCategoriesState()
                        else if (professionals.isEmpty)
                          _EmptyProfessionalsState(
                            onCreate: () => _showProfessionalForm(
                              context,
                              serviceOptions: serviceOptions,
                            ),
                          )
                        else
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final crossAxisCount =
                                  constraints.maxWidth > 1100 ? 2 : 1;
                              if (crossAxisCount == 1) {
                                return Column(
                                  children: [
                                    for (final professional in professionals)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: _ProfessionalAdminCard(
                                          professional: professional,
                                          onEdit: () => _showProfessionalForm(
                                            context,
                                            serviceOptions: serviceOptions,
                                            professional: professional,
                                          ),
                                          onDelete: () => _deleteProfessional(
                                            context,
                                            professional,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              }

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: professionals.length,
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 560,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1.1,
                                ),
                                itemBuilder: (context, index) {
                                  final professional = professionals[index];
                                  return _ProfessionalAdminCard(
                                    professional: professional,
                                    onEdit: () => _showProfessionalForm(
                                      context,
                                      serviceOptions: serviceOptions,
                                      professional: professional,
                                    ),
                                    onDelete: () => _deleteProfessional(
                                      context,
                                      professional,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FirebaseBootstrap.isReady
          ? FloatingActionButton.extended(
              onPressed: () async {
                final rootSnapshot =
                    await FirebaseDatabase.instance.ref().get();
                final serviceOptions =
                    ProfessionalAdminService.serviceOptionsFromRoot(
                  rootSnapshot.value,
                );
                if (!context.mounted) {
                  return;
                }
                if (serviceOptions.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Ajoutez d’abord des catégories pour créer un professionnel.',
                      ),
                    ),
                  );
                  return;
                }

                await _showProfessionalForm(
                  context,
                  serviceOptions: serviceOptions,
                );
              },
              backgroundColor: AppColors.navy,
              icon: const Icon(Icons.person_add_alt_1_outlined),
              label: const Text('Nouveau pro'),
            )
          : null,
    );
  }

  Future<void> _deleteProfessional(
    BuildContext context,
    ProfessionalAdminItem professional,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le professionnel'),
        content: Text(
          'Supprimer ${professional.name} du service ${professional.service} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    try {
      await ProfessionalAdminService.deleteProfessional(professional);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Professionnel supprimé.')),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Échec de la suppression du professionnel.'),
        ),
      );
    }
  }

  Future<void> _showProfessionalForm(
    BuildContext context, {
    required List<String> serviceOptions,
    ProfessionalAdminItem? professional,
  }) async {
    final nameController =
        TextEditingController(text: professional?.name ?? '');
    final locationController = TextEditingController(
      text: professional?.location == 'Localisation non renseignée'
          ? ''
          : professional?.location ?? '',
    );
    final priceController = TextEditingController(
      text: professional?.price == 'Tarif à confirmer'
          ? ''
          : professional?.price ?? '',
    );
    final phoneController =
        TextEditingController(text: professional?.phone ?? '');
    final responseTimeController = TextEditingController(
      text: professional?.responseTime == 'Temps de réponse non renseigné'
          ? ''
          : professional?.responseTime ?? 'Répond en moins de 15 min',
    );
    final completedJobsController = TextEditingController(
      text: professional?.completedJobs.toString() ?? '0',
    );

    var selectedService =
        professional != null && serviceOptions.contains(professional.service)
            ? professional.service
            : serviceOptions.first;
    var isAvailableNow = professional?.availableNow ?? true;
    var isVerified = professional?.verified ?? false;
    var isSubscribed = professional?.subscribed ?? false;
    var selectedPlanId = professional != null &&
            ProSubscriptionService.plans
                .any((plan) => plan.id == professional.subscriptionPlan)
        ? professional.subscriptionPlan
        : ProSubscriptionService.plans.first.id;
    var isSaving = false;

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            professional == null
                ? 'Nouveau professionnel'
                : 'Modifier le professionnel',
          ),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedService,
                    decoration: const InputDecoration(
                      labelText: 'Service',
                      border: OutlineInputBorder(),
                    ),
                    items: serviceOptions
                        .map(
                          (service) => DropdownMenuItem(
                            value: service,
                            child: Text(service),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedService = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'Zone d’intervention',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Tarification',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Téléphone',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: responseTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Temps de réponse',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: completedJobsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Interventions réalisées',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    value: isAvailableNow,
                    onChanged: (value) =>
                        setDialogState(() => isAvailableNow = value),
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Disponible immédiatement'),
                  ),
                  SwitchListTile(
                    value: isVerified,
                    onChanged: (value) =>
                        setDialogState(() => isVerified = value),
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Profil vérifié'),
                  ),
                  SwitchListTile(
                    value: isSubscribed,
                    onChanged: (value) =>
                        setDialogState(() => isSubscribed = value),
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Abonné LigueyPro Pro'),
                  ),
                  if (isSubscribed) ...[
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: selectedPlanId,
                      decoration: const InputDecoration(
                        labelText: 'Plan Pro',
                        border: OutlineInputBorder(),
                      ),
                      items: ProSubscriptionService.plans
                          .map(
                            (plan) => DropdownMenuItem(
                              value: plan.id,
                              child: Text(
                                '${plan.name} • ${ProSubscriptionService.formatFcfa(plan.priceFcfa)}/mois',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => selectedPlanId = value);
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      final name = nameController.text.trim();
                      final location = locationController.text.trim();
                      final price = priceController.text.trim();
                      final phone = phoneController.text.trim();
                      final responseTime = responseTimeController.text.trim();
                      final completedJobs =
                          int.tryParse(completedJobsController.text.trim()) ??
                              0;

                      if (name.isEmpty || location.isEmpty || price.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Renseignez au minimum le nom, la zone et la tarification.',
                            ),
                          ),
                        );
                        return;
                      }

                      setDialogState(() => isSaving = true);
                      try {
                        await ProfessionalAdminService.saveProfessional(
                          ProfessionalAdminDraft(
                            id: professional?.id,
                            existingService: professional?.service,
                            name: name,
                            service: selectedService,
                            location: location,
                            price: price,
                            phone: phone,
                            responseTime: responseTime.isEmpty
                                ? 'Réponse rapide'
                                : responseTime,
                            availableNow: isAvailableNow,
                            verified: isVerified,
                            subscribed: isSubscribed,
                            subscriptionPlan: selectedPlanId,
                            completedJobs: completedJobs,
                            ratingAverage: professional?.ratingAverage ?? 0,
                            reviewsCount: professional?.reviewsCount ?? 0,
                          ),
                        );
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              professional == null
                                  ? 'Professionnel créé.'
                                  : 'Professionnel mis à jour.',
                            ),
                          ),
                        );
                      } catch (_) {
                        if (!context.mounted) {
                          return;
                        }
                        setDialogState(() => isSaving = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Échec de l’enregistrement du professionnel.',
                            ),
                          ),
                        );
                      }
                    },
              style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
              child: Text(
                isSaving ? 'Enregistrement...' : 'Enregistrer',
              ),
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    locationController.dispose();
    priceController.dispose();
    phoneController.dispose();
    responseTimeController.dispose();
    completedJobsController.dispose();
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.professionalsCount,
    required this.subscribedCount,
    required this.verifiedCount,
    required this.onCreate,
  });

  final int professionalsCount;
  final int subscribedCount;
  final int verifiedCount;
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, Color(0xFF154972), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestion des professionnels',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Créez, modifiez et supprimez les professionnels visibles dans l’application sans passer par Firebase Console.',
            style: TextStyle(color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroChip(label: 'Total', value: '$professionalsCount'),
              _HeroChip(label: 'Abonnés', value: '$subscribedCount'),
              _HeroChip(label: 'Vérifiés', value: '$verifiedCount'),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onCreate,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.navy,
            ),
            icon: const Icon(Icons.person_add_alt_1_outlined),
            label: const Text('Ajouter un professionnel'),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label • $value',
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ProfessionalAdminCard extends StatelessWidget {
  const _ProfessionalAdminCard({
    required this.professional,
    required this.onEdit,
    required this.onDelete,
  });

  final ProfessionalAdminItem professional;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      professional.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${professional.service} • ${professional.location}',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Modifier',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, color: AppColors.navy),
              ),
              IconButton(
                tooltip: 'Supprimer',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: AppColors.danger),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusPill(
                label: professional.verified ? 'Vérifié' : 'Standard',
                color:
                    professional.verified ? AppColors.success : AppColors.navy,
              ),
              _StatusPill(
                label: professional.subscribed
                    ? 'Plan ${professional.subscriptionPlan.toUpperCase()}'
                    : 'Non abonné',
                color: professional.subscribed
                    ? AppColors.primary
                    : AppColors.muted,
              ),
              _StatusPill(
                label:
                    professional.availableNow ? 'Disponible' : 'Indisponible',
                color: professional.availableNow
                    ? AppColors.success
                    : AppColors.danger,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Tarif',
                  value: professional.price,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoTile(
                  label: 'Réponse',
                  value: professional.responseTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Avis',
                  value: professional.reviewsCount == 0
                      ? 'Aucun avis'
                      : '${professional.ratingAverage.toStringAsFixed(1)} / 5',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoTile(
                  label: 'Interventions',
                  value: '${professional.completedJobs}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            professional.phone.isEmpty
                ? 'Téléphone non renseigné'
                : professional.phone,
            style: const TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _EmptyProfessionalsState extends StatelessWidget {
  const _EmptyProfessionalsState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          const Icon(Icons.groups_outlined, size: 42, color: AppColors.primary),
          const SizedBox(height: 12),
          const Text(
            'Aucun professionnel configuré',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Créez votre premier professionnel pour l’afficher dans la recherche, les listes et les demandes.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onCreate,
            style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
            icon: const Icon(Icons.person_add_alt_1_outlined),
            label: const Text('Créer un professionnel'),
          ),
        ],
      ),
    );
  }
}

class _MissingCategoriesState extends StatelessWidget {
  const _MissingCategoriesState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: const Column(
        children: [
          Icon(Icons.category_outlined, size: 42, color: AppColors.primary),
          SizedBox(height: 12),
          Text(
            'Aucune catégorie disponible',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8),
          Text(
            'Ajoutez d’abord des catégories dans le back-office pour pouvoir classer les professionnels.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _FirebaseRequiredState extends StatelessWidget {
  const _FirebaseRequiredState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border:
                Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
          ),
          child: const Column(
            children: [
              Icon(Icons.cloud_off_outlined, size: 42, color: AppColors.danger),
              SizedBox(height: 12),
              Text(
                'Firebase indisponible',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 8),
              Text(
                'Le CRUD des professionnels nécessite une connexion Firebase active.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
