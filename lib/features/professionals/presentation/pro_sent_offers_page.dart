import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/services/app_preferences_service.dart';
import '../../../core/services/offer_marketplace_service.dart';
import '../../../core/theme/app_colors.dart';

class ProSentOffersPage extends StatefulWidget {
  const ProSentOffersPage({super.key});

  @override
  State<ProSentOffersPage> createState() => _ProSentOffersPageState();
}

class _ProSentOffersPageState extends State<ProSentOffersPage> {
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

  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String _requestStatusLabel(ProSentOfferItem offer) {
    if (offer.isAccepted) {
      return 'Offre retenue';
    }
    switch (offer.requestOffersStatus) {
      case 'closed':
        return 'Clôturée';
      case 'accepted':
        return 'Attribuée';
      default:
        return 'En attente client';
    }
  }

  Color _requestStatusColor(ProSentOfferItem offer) {
    if (offer.isAccepted) {
      return AppColors.success;
    }
    switch (offer.requestOffersStatus) {
      case 'closed':
        return AppColors.muted;
      case 'accepted':
        return AppColors.primary;
      default:
        return AppColors.navy;
    }
  }

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
          ),
          child: const Column(
            children: [
              Icon(Icons.inbox_outlined, size: 42, color: AppColors.primary),
              SizedBox(height: 12),
              Text(
                'Aucune offre envoyée',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Les offres que vous émettez depuis l’espace Pro apparaîtront ici avec leur statut.',
                style: TextStyle(color: AppColors.muted, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOffers(
    List<ProSentOfferItem> offers,
    List<SubscribedProfessionalItem> professionals,
  ) {
    final currentProfessional = _resolveCurrentProfessional(professionals);
    final filteredOffers = currentProfessional == null
        ? const <ProSentOfferItem>[]
        : offers
            .where(
              (offer) => offer.professionalId == currentProfessional.id,
            )
            .toList();
    final acceptedCount =
        filteredOffers.where((offer) => offer.isAccepted).length;
    final pendingCount = filteredOffers.length - acceptedCount;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.navy, Color(0xFF1D5D90)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mes offres envoyées',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Suivez vos propositions, voyez celles qui ont été retenues et contactez rapidement le client.',
                style: TextStyle(color: Colors.white70, height: 1.4),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/back-office'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white38),
                      ),
                      icon: const Icon(Icons.dashboard_customize_outlined),
                      label: const Text('Tableau BO'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/pro-leads'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white38),
                      ),
                      icon: const Icon(Icons.campaign_outlined),
                      label: const Text('Demandes'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
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
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentProfessional?.name ??
                                'Aucun professionnel actif',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (currentProfessional != null)
                            Text(
                              '${currentProfessional.service} • ${currentProfessional.planLabel.toUpperCase()}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: professionals.isEmpty
                          ? null
                          : () => _showProfessionalSelector(professionals),
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text('Changer'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${filteredOffers.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Offres',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$acceptedCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Acceptées',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$pendingCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'En attente',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (currentProfessional == null)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
            ),
            child: const Text(
              'Aucun professionnel courant n’est défini. Ajoutez ou abonnez un professionnel pour suivre ses offres.',
              style: TextStyle(color: AppColors.muted),
            ),
          )
        else if (filteredOffers.isEmpty)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
            ),
            child: Text(
              'Aucune offre n’a encore été envoyée pour ${currentProfessional.name}.',
              style: const TextStyle(color: AppColors.muted),
            ),
          )
        else
          ...filteredOffers.map(
            (offer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _requestStatusColor(offer).withValues(alpha: 0.22),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            offer.requestService,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _requestStatusColor(offer)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _requestStatusLabel(offer),
                            style: TextStyle(
                              color: _requestStatusColor(offer),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${offer.requestUrgency} • ${offer.requestLocation}',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      offer.price,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${offer.planLabel.toUpperCase()} • ${offer.eta}',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      offer.message,
                      style: const TextStyle(height: 1.45),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Envoyée le ${offer.createdAt.day}/${offer.createdAt.month}/${offer.createdAt.year}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _launchPhone(offer.clientPhone),
                            icon: const Icon(Icons.phone_outlined),
                            label: const Text('Appeler le client'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: null,
                            style: FilledButton.styleFrom(
                              backgroundColor: _requestStatusColor(offer),
                            ),
                            icon: Icon(
                              offer.isAccepted
                                  ? Icons.verified_outlined
                                  : Icons.schedule_outlined,
                            ),
                            label: Text(_requestStatusLabel(offer)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mes offres envoyées'),
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
                final professionals = root is Map
                    ? OfferMarketplaceService
                        .subscribedProfessionalsFromSnapshot(
                        root['professionals'],
                      )
                    : OfferMarketplaceService
                        .subscribedProfessionalsFromSnapshot(
                        null,
                      );
                final offers = OfferMarketplaceService.sentOffersFromRoot(
                  root,
                  professionalId: _currentProfessional?.professionalId,
                );
                if (offers.isEmpty && professionals.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildOffers(offers, professionals);
              },
            )
          : _buildOffers(
              OfferMarketplaceService.sentOffersFromRoot(
                null,
                professionalId: _currentProfessional?.professionalId,
              ),
              OfferMarketplaceService.subscribedProfessionalsFromSnapshot(null),
            ),
    );
  }
}
