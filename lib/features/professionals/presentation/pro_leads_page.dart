import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/services/app_preferences_service.dart';
import '../../../core/services/offer_marketplace_service.dart';
import '../../../core/theme/app_colors.dart';

class ProLeadsPage extends StatefulWidget {
  const ProLeadsPage({super.key});

  @override
  State<ProLeadsPage> createState() => _ProLeadsPageState();
}

class _ProLeadsPageState extends State<ProLeadsPage> {
  CurrentProfessionalSummary? _currentProfessional;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfessional();
  }

  Future<void> _loadCurrentProfessional() async {
    final summary = await AppPreferencesService.getCurrentProfessional();
    if (!mounted) return;
    setState(() {
      _currentProfessional = summary;
    });
  }

  Future<void> _setCurrentProfessional(
    SubscribedProfessionalItem professional,
  ) async {
    final summary = CurrentProfessionalSummary(
      professionalId: professional.id,
      name: professional.name,
      phone: professional.phone,
      service: professional.service,
      planLabel: professional.planLabel,
    );
    await AppPreferencesService.setCurrentProfessional(summary);
    if (!mounted) return;
    setState(() {
      _currentProfessional = summary;
    });
  }

  Future<void> _lockBackOffice() async {
    await AppPreferencesService.lockBackOffice();
    if (!mounted) return;
    context.go('/back-office');
  }

  SubscribedProfessionalItem? _resolveCurrentProfessional(
    List<SubscribedProfessionalItem> professionals,
  ) {
    if (professionals.isEmpty) {
      return null;
    }

    final current = _currentProfessional;
    if (current != null) {
      for (final professional in professionals) {
        if (professional.id == current.professionalId) {
          return professional;
        }
      }
    }

    final fallback = professionals.first;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_currentProfessional?.professionalId != fallback.id) {
        _setCurrentProfessional(fallback);
      }
    });
    return fallback;
  }

  Future<void> _showProfessionalSelector(
    List<SubscribedProfessionalItem> professionals,
  ) async {
    if (professionals.isEmpty) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: professionals.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final professional = professionals[index];
              final isSelected =
                  professional.id == _currentProfessional?.professionalId;
              return ListTile(
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected ? AppColors.primary : AppColors.muted,
                ),
                title: Text(professional.name),
                subtitle: Text(
                  '${professional.service} • ${professional.planLabel.toUpperCase()}',
                ),
                onTap: () async {
                  await _setCurrentProfessional(professional);
                  if (!sheetContext.mounted) return;
                  Navigator.of(sheetContext).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showOfferDialog(
    MarketplaceRequestItem request,
    SubscribedProfessionalItem professional,
  ) async {
    final priceController = TextEditingController(text: '15 000 FCFA');
    final etaController = TextEditingController(text: 'Disponible dans 30 min');
    final messageController = TextEditingController(
        text: 'Je peux intervenir rapidement sur cette demande.');
    var isSubmitting = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: const Text('Émettre une offre'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.14),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            professional.name,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${professional.service} • ${professional.planLabel.toUpperCase()}',
                            style: const TextStyle(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      decoration:
                          const InputDecoration(labelText: 'Prix proposé'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: etaController,
                      decoration: const InputDecoration(
                          labelText: 'Délai / disponibilité'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: messageController,
                      minLines: 3,
                      maxLines: 5,
                      decoration:
                          const InputDecoration(labelText: 'Message au client'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Annuler'),
                ),
                FilledButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          setLocalState(() => isSubmitting = true);
                          try {
                            await OfferMarketplaceService.submitOffer(
                              requestId: request.id,
                              offer: MarketplaceOfferItem(
                                id: 'draft_offer_${DateTime.now().millisecondsSinceEpoch}',
                                professionalId: professional.id,
                                professionalName: professional.name,
                                planLabel: professional.planLabel,
                                price: priceController.text.trim().isEmpty
                                    ? 'À confirmer'
                                    : priceController.text.trim(),
                                eta: etaController.text.trim().isEmpty
                                    ? 'Disponibilité à confirmer'
                                    : etaController.text.trim(),
                                message: messageController.text.trim().isEmpty
                                    ? 'Offre envoyée'
                                    : messageController.text.trim(),
                                phone: professional.phone,
                                createdAt: DateTime.now(),
                                highlighted:
                                    professional.planLabel == 'business' ||
                                        professional.planLabel == 'pro',
                              ),
                            );
                          } on StateError catch (error) {
                            if (!dialogContext.mounted || !mounted) return;
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(content: Text(error.message)),
                            );
                            return;
                          }
                          if (!dialogContext.mounted || !mounted) return;
                          Navigator.of(dialogContext).pop();
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Offre envoyée pour ${request.service}.')),
                          );
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Envoyer l’offre'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLeads(
    List<MarketplaceRequestItem> requests,
    SubscribedProfessionalItem? currentProfessional,
  ) {
    final matchingRequests = currentProfessional == null
        ? requests
        : requests
            .where(
              (request) =>
                  request.service.toLowerCase() ==
                  currentProfessional.service.toLowerCase(),
            )
            .toList();

    final sortedRequests = [...matchingRequests]..sort((a, b) {
        final aLocked = OfferMarketplaceService.isRequestLocked(a);
        final bLocked = OfferMarketplaceService.isRequestLocked(b);
        if (aLocked != bLocked) {
          return aLocked ? 1 : -1;
        }
        return b.createdAt.compareTo(a.createdAt);
      });

    if (currentProfessional == null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
            child: const Text(
              'Aucun professionnel courant n’est défini. Ajoutez ou abonnez un professionnel pour accéder aux demandes.',
              style: TextStyle(color: AppColors.muted, height: 1.4),
            ),
          ),
        ],
      );
    }

    if (sortedRequests.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              'Aucune demande ouverte pour ${currentProfessional.service} pour le moment.',
              style: const TextStyle(color: AppColors.muted, height: 1.4),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sortedRequests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final request = sortedRequests[index];
        final isLocked = OfferMarketplaceService.isRequestLocked(request);
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isLocked
                  ? AppColors.success.withValues(alpha: 0.22)
                  : AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      request.service,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isLocked
                          ? AppColors.success.withValues(alpha: 0.12)
                          : AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      isLocked ? 'Déjà attribuée' : request.urgency,
                      style: TextStyle(
                          color:
                              isLocked ? AppColors.success : AppColors.primary,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(request.description,
                  style: const TextStyle(color: AppColors.muted, height: 1.45)),
              const SizedBox(height: 10),
              Text('${request.location} • ${request.phone}',
                  style: const TextStyle(color: AppColors.muted)),
              const SizedBox(height: 10),
              Text('${request.offersCount} offre(s) déjà envoyée(s)',
                  style: const TextStyle(
                      color: AppColors.navy, fontWeight: FontWeight.w700)),
              if (request.acceptedProfessionalName != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Attribuée à ${request.acceptedProfessionalName}',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: isLocked
                    ? null
                    : () => _showOfferDialog(request, currentProfessional),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      isLocked ? AppColors.success : AppColors.navy,
                ),
                icon: Icon(
                  isLocked
                      ? Icons.verified_outlined
                      : Icons.local_offer_outlined,
                ),
                label: Text(
                  isLocked ? 'Offre non disponible' : 'Faire une offre',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderActions(
    BuildContext context,
    List<SubscribedProfessionalItem> professionals,
    SubscribedProfessionalItem? currentProfessional,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Professionnel courant',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentProfessional?.name ??
                            'Aucun professionnel actif',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (currentProfessional != null)
                        Text(
                          '${currentProfessional.service} • ${currentProfessional.planLabel.toUpperCase()}',
                          style: const TextStyle(color: AppColors.muted),
                        ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: professionals.isEmpty
                      ? null
                      : () => _showProfessionalSelector(professionals),
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('Changer'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/back-office'),
                  icon: const Icon(Icons.dashboard_customize_outlined),
                  label: const Text('Tableau BO'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/pro-sent-offers'),
                  icon: const Icon(Icons.inventory_2_outlined),
                  label: const Text('Mes offres'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Espace Pro'),
        actions: [
          IconButton(
            tooltip: 'Verrouiller le BO',
            onPressed: _lockBackOffice,
            icon: const Icon(Icons.lock_outline),
          ),
        ],
      ),
      body: FirebaseBootstrap.isReady
          ? StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance.ref().onValue,
              builder: (context, snapshot) {
                final root = snapshot.data?.snapshot.value;
                final requests = root is Map
                    ? OfferMarketplaceService.requestsFromSnapshot(
                        root['requests'])
                  : const <MarketplaceRequestItem>[];
                final professionals = root is Map
                    ? OfferMarketplaceService
                        .subscribedProfessionalsFromSnapshot(
                            root['professionals'])
                    : OfferMarketplaceService
                        .subscribedProfessionalsFromSnapshot(null);
                final currentProfessional =
                    _resolveCurrentProfessional(professionals);
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [AppColors.navy, Color(0xFF1D5D90)]),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Demandes disponibles',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800)),
                          SizedBox(height: 8),
                          Text(
                              'Les professionnels abonnés peuvent consulter les demandes ouvertes et envoyer leurs offres aux clients.',
                              style: TextStyle(
                                  color: Colors.white70, height: 1.4)),
                        ],
                      ),
                    ),
                    _buildHeaderActions(
                      context,
                      professionals,
                      currentProfessional,
                    ),
                    Expanded(child: _buildLeads(requests, currentProfessional)),
                  ],
                );
              },
            )
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.navy, Color(0xFF1D5D90)]),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Demandes disponibles',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800)),
                      SizedBox(height: 8),
                      Text(
                          'Les professionnels abonnés peuvent consulter les demandes ouvertes et envoyer leurs offres aux clients.',
                          style: TextStyle(color: Colors.white70, height: 1.4)),
                    ],
                  ),
                ),
                Builder(
                  builder: (context) {
                    final professionals = OfferMarketplaceService
                        .subscribedProfessionalsFromSnapshot(
                      null,
                    );
                    final currentProfessional =
                        _resolveCurrentProfessional(professionals);
                    return Expanded(
                      child: Column(
                        children: [
                          _buildHeaderActions(
                            context,
                            professionals,
                            currentProfessional,
                          ),
                          Expanded(
                            child: _buildLeads(
                              const <MarketplaceRequestItem>[],
                              currentProfessional,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
