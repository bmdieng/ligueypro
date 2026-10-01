import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/app_preferences_service.dart';
import '../../../core/services/professional_credit_service.dart';
import '../../../core/theme/app_colors.dart';

class ProAccountPage extends StatefulWidget {
  const ProAccountPage({super.key});

  @override
  State<ProAccountPage> createState() => _ProAccountPageState();
}

class _ProAccountPageState extends State<ProAccountPage> {
  CurrentProfessionalSummary? _currentProfessional;
  Map<String, dynamic> _account = {
    'creditBalance': 0,
    'boostUntil': 0,
    'subscribed': false,
    'planLabel': 'starter',
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccount();
  }

  Future<void> _loadAccount() async {
    final summary = await AppPreferencesService.getCurrentProfessional();
    if (!mounted) {
      return;
    }

    if (summary != null) {
      final remoteAccount = await ProfessionalCreditService.getProfessionalAccount(
        professionalId: summary.professionalId,
        professionalService: summary.service,
      );

      final refreshedSummary = CurrentProfessionalSummary(
        professionalId: summary.professionalId,
        name: summary.name,
        phone: summary.phone,
        service: summary.service,
        planLabel: remoteAccount['planLabel']?.toString() ?? summary.planLabel,
        isSubscribed: remoteAccount['subscribed'] == true || summary.isSubscribed,
      );

      if (refreshedSummary.planLabel != summary.planLabel ||
          refreshedSummary.isSubscribed != summary.isSubscribed) {
        await AppPreferencesService.setCurrentProfessional(refreshedSummary);
      }

      setState(() {
        _currentProfessional = refreshedSummary;
        _isLoading = false;
      });

      if (!mounted) {
        return;
      }

      setState(() {
        _account = remoteAccount;
      });
      return;
    }

    setState(() {
      _currentProfessional = null;
      _isLoading = false;
    });
  }

  Future<void> _activateBoost() async {
    final professional = _currentProfessional;
    if (professional == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun profil professionnel sélectionné.')),
      );
      return;
    }

    try {
      await ProfessionalCreditService.activateBoost(
        professionalId: professional.professionalId,
        professionalService: professional.service,
        days: 7,
      );
      await _loadAccount();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Boost activé pendant 7 jours.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le boost n’a pas pu être activé.')),
      );
    }
  }

  Future<void> _consumeCredit() async {
    final professional = _currentProfessional;
    if (professional == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun profil professionnel sélectionné.')),
      );
      return;
    }

    final currentBalance = int.tryParse('${_account['creditBalance'] ?? 0}') ?? 0;
    if (currentBalance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun crédit disponible pour l’utiliser.')),
      );
      return;
    }

    try {
      await ProfessionalCreditService.consumeCredit(
        professionalId: professional.professionalId,
        professionalService: professional.service,
      );
      await _loadAccount();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('1 crédit a été consommé.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le crédit n’a pas pu être consommé.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final professional = _currentProfessional;
    final creditBalance = int.tryParse('${_account['creditBalance'] ?? 0}') ?? 0;
    final boostUntil = int.tryParse('${_account['boostUntil'] ?? 0}') ?? 0;
    final boostStatus = ProfessionalCreditService.formatBoostStatus(
      boostUntil: boostUntil,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mon compte pro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: professional == null
                  ? _buildNoProfessionalCard()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderCard(professional),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                title: 'Crédits',
                                value: '$creditBalance',
                                subtitle: 'demandes actives',
                                accent: AppColors.navy,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                title: 'Boost',
                                value: ProfessionalCreditService.isBoostActive(
                                          boostUntil: boostUntil,
                                        )
                                    ? 'Oui'
                                    : 'Non',
                                subtitle: boostStatus,
                                accent: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Statut du profil',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildStatusRow(
                                'Abonnement',
                                professional.isSubscribed ? 'Pro actif' : 'Non pro connecté',
                              ),
                              _buildStatusRow(
                                'Pack',
                                professional.isSubscribed
                                    ? (_account['planLabel'] ?? 'starter').toString().toUpperCase()
                                    : 'NONE',
                              ),
                              _buildStatusRow(
                                'Service',
                                professional.service,
                              ),
                              _buildStatusRow(
                                'Boost',
                                boostStatus,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: _activateBoost,
                                icon: const Icon(Icons.flash_on_outlined),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.navy,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                label: const Text('Boost 7 jours'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _consumeCredit,
                                icon: const Icon(Icons.remove_circle_outline),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                label: const Text('Utiliser 1 crédit'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () => context.push('/pro-subscription'),
                          icon: const Icon(Icons.add_circle_outline),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.navy,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          label: const Text('Acheter un pack'),
                        ),
                      ],
                    ),
            ),
    );
  }

  Widget _buildNoProfessionalCard() {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_off_outlined, size: 52, color: AppColors.muted),
            const SizedBox(height: 16),
            const Text(
              'Aucun profil professionnel actif',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sélectionnez un professionnel ou activez votre compte pour voir votre solde de crédits.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () => context.push('/pro-subscription'),
              icon: const Icon(Icons.workspace_premium_outlined),
              label: const Text('Activer un pack'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(CurrentProfessionalSummary professional) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, Color(0xFF1C5A8B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, size: 28, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      professional.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      professional.service,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              professional.planLabel.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
