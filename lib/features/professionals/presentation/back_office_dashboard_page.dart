import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/services/app_preferences_service.dart';
import '../../../core/services/offer_marketplace_service.dart';
import '../../../core/theme/app_colors.dart';

class BackOfficeDashboardPage extends StatefulWidget {
  const BackOfficeDashboardPage({super.key});

  @override
  State<BackOfficeDashboardPage> createState() =>
      _BackOfficeDashboardPageState();
}

class _BackOfficeDashboardPageState extends State<BackOfficeDashboardPage> {
  CurrentProfessionalSummary? _currentProfessional;

  _BackOfficeStats _computeStats(
    List<MarketplaceRequestItem> requests,
    List<ProSentOfferItem> offers,
  ) {
    final now = DateTime.now();
    final openRequests = requests
        .where((request) => !OfferMarketplaceService.isRequestLocked(request))
        .length;
    final lockedRequests =
        requests.where(OfferMarketplaceService.isRequestLocked).length;
    final requestsWithOffers =
        requests.where((request) => request.offersCount > 0).length;
    final acceptedOffers = offers.where((offer) => offer.isAccepted).length;
    final last24hOffers = offers
        .where((offer) => now.difference(offer.createdAt).inHours < 24)
        .length;
    final conversionRate =
        offers.isEmpty ? 0.0 : (acceptedOffers / offers.length) * 100;
    final coverageRate =
        requests.isEmpty ? 0.0 : (requestsWithOffers / requests.length) * 100;
    final averageOffersPerRequest =
        requests.isEmpty ? 0.0 : offers.length / requests.length;

    return _BackOfficeStats(
      openRequests: openRequests,
      lockedRequests: lockedRequests,
      requestsWithOffers: requestsWithOffers,
      acceptedOffers: acceptedOffers,
      last24hOffers: last24hOffers,
      conversionRate: conversionRate,
      coverageRate: coverageRate,
      averageOffersPerRequest: averageOffersPerRequest,
    );
  }

  List<_ProfessionalPerformance> _buildLeaderboard(
    List<ProSentOfferItem> offers,
  ) {
    final byProfessional = <String, _ProfessionalPerformance>{};

    for (final offer in offers) {
      final current = byProfessional[offer.professionalId];
      if (current == null) {
        byProfessional[offer.professionalId] = _ProfessionalPerformance(
          professionalId: offer.professionalId,
          professionalName: offer.professionalName,
          planLabel: offer.planLabel,
          offersCount: 1,
          acceptedCount: offer.isAccepted ? 1 : 0,
        );
        continue;
      }

      byProfessional[offer.professionalId] = current.copyWith(
        offersCount: current.offersCount + 1,
        acceptedCount: current.acceptedCount + (offer.isAccepted ? 1 : 0),
      );
    }

    final leaderboard = byProfessional.values.toList()
      ..sort((a, b) {
        if (a.acceptedCount != b.acceptedCount) {
          return b.acceptedCount.compareTo(a.acceptedCount);
        }
        return b.offersCount.compareTo(a.offersCount);
      });
    return leaderboard.take(3).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentProfessional();
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

  Future<void> _lockBackOffice() async {
    await AppPreferencesService.lockBackOffice();
    if (!mounted) {
      return;
    }

    context.go('/back-office');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Back-office'),
        toolbarHeight: 52,
        actions: [
          IconButton(
            tooltip: 'Verrouiller',
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
                return _buildContent(context, root);
              },
            )
          : _buildContent(context, null),
    );
  }

  Widget _buildContent(BuildContext context, Object? root) {
    final isCompactHeader = MediaQuery.sizeOf(context).width < 720;
    final requests = root is Map
        ? OfferMarketplaceService.requestsFromSnapshot(root['requests'])
      : const <MarketplaceRequestItem>[];
    final currentProfessionalOffers =
        OfferMarketplaceService.sentOffersFromRoot(
      root,
      professionalId: _currentProfessional?.professionalId,
    );
    final allOffers = OfferMarketplaceService.sentOffersFromRoot(root);
    final leadsForCurrentPro = _currentProfessional == null
        ? requests.length
        : requests
            .where(
              (request) =>
                  request.service.toLowerCase() ==
                  _currentProfessional!.service.toLowerCase(),
            )
            .length;
    final stats = _computeStats(requests, allOffers);
    final currentProfessionalAcceptedOffers =
        currentProfessionalOffers.where((offer) => offer.isAccepted).length;
    final leaderboard = _buildLeaderboard(allOffers);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.navy,
                    Color(0xFF154972),
                    AppColors.primary
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.navy.withValues(alpha: 0.16),
                    blurRadius: 26,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Cockpit opérationnel',
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.1,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Pilotez votre BO LigueyPro',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currentProfessional == null
                                  ? 'Sélectionnez un professionnel abonné pour suivre les demandes et la performance des offres.'
                                  : '${_currentProfessional!.name} est actif sur ${_currentProfessional!.service} avec le plan ${_currentProfessional!.planLabel.toUpperCase()}.',
                              style: const TextStyle(
                                color: Colors.white70,
                                height: 1.35,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.dashboard_customize_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (isCompactHeader)
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => context.go('/pro-leads'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white38),
                              minimumSize: const Size.fromHeight(38),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              visualDensity: VisualDensity.compact,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            icon: const Icon(Icons.campaign_outlined, size: 16),
                            label: const Text('Demandes'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => context.go('/admin-categories'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white38),
                              minimumSize: const Size.fromHeight(38),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              visualDensity: VisualDensity.compact,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            icon: const Icon(Icons.category_outlined, size: 16),
                            label: const Text('Catégories'),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.go('/pro-leads'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white38),
                              minimumSize: const Size.fromHeight(38),
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              visualDensity: VisualDensity.compact,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            icon: const Icon(Icons.campaign_outlined, size: 16),
                            label: const Text('Demandes'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.go('/admin-categories'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white38),
                              minimumSize: const Size.fromHeight(38),
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              visualDensity: VisualDensity.compact,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            icon: const Icon(Icons.category_outlined, size: 16),
                            label: const Text('Catégories'),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => context.go('/pro-sent-offers'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.navy,
                        minimumSize: const Size.fromHeight(38),
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        visualDensity: VisualDensity.compact,
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      icon: const Icon(Icons.inventory_2_outlined, size: 16),
                      label: const Text('Mes offres'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.sizeOf(context).width > 1200
                  ? 3
                  : MediaQuery.sizeOf(context).width > 800
                      ? 2
                      : 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              childAspectRatio:
                  MediaQuery.sizeOf(context).width > 1200 ? 1.45 : 1.28,
              children: [
                _MetricCard(
                  title: 'Demandes visibles',
                  value: '$leadsForCurrentPro',
                  accent: AppColors.navy,
                  icon: Icons.waves_outlined,
                ),
                _MetricCard(
                  title: 'Demandes attribuées',
                  value: '${stats.lockedRequests}',
                  accent: AppColors.success,
                  icon: Icons.verified_outlined,
                ),
                _MetricCard(
                  title: 'Offres envoyées',
                  value: '${currentProfessionalOffers.length}',
                  accent: AppColors.primary,
                  icon: Icons.local_offer_outlined,
                ),
                _MetricCard(
                  title: 'Offres retenues',
                  value: '$currentProfessionalAcceptedOffers',
                  accent: AppColors.success,
                  icon: Icons.workspace_premium_outlined,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'Performance commerciale',
              subtitle:
                  'Lecture rapide de la conversion du marketplace et de la capacité des pros à répondre.',
              icon: Icons.insights_outlined,
              content: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _KpiStrip(
                          label: 'Taux de conversion',
                          value: '${stats.conversionRate.toStringAsFixed(0)}%',
                          helper: '${stats.acceptedOffers} offre(s) retenue(s)',
                          accent: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _KpiStrip(
                          label: 'Couverture',
                          value: '${stats.coverageRate.toStringAsFixed(0)}%',
                          helper:
                              '${stats.requestsWithOffers}/${requests.length} demandes couvertes',
                          accent: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _KpiStrip(
                          label: 'Offres / demande',
                          value:
                              stats.averageOffersPerRequest.toStringAsFixed(1),
                          helper: 'Intensité moyenne',
                          accent: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _KpiStrip(
                          label: 'Activité 24h',
                          value: '${stats.last24hOffers}',
                          helper: 'Offres récentes',
                          accent: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _FunnelBar(
                    openRequests: stats.openRequests,
                    coveredRequests: stats.requestsWithOffers,
                    lockedRequests: stats.lockedRequests,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _SectionCard(
              title: 'Top professionnels',
              subtitle: leaderboard.isEmpty
                  ? 'Aucune donnée d’offre disponible pour le moment.'
                  : 'Classement par offres retenues, puis par volume d’offres envoyées.',
              icon: Icons.emoji_events_outlined,
              content: leaderboard.isEmpty
                  ? const Text(
                      'Les performances apparaîtront dès que les professionnels commenceront à répondre aux demandes.',
                      style: TextStyle(color: AppColors.muted, height: 1.4),
                    )
                  : Column(
                      children: [
                        for (var index = 0; index < leaderboard.length; index++)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: index == leaderboard.length - 1 ? 0 : 10,
                            ),
                            child: _LeaderboardTile(
                              rank: index + 1,
                              performance: leaderboard[index],
                            ),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 10),
            _SectionCard(
              title: 'Actions rapides',
              subtitle:
                  'Ouvrez vos écrans clés pour traiter plus vite les demandes et les offres.',
              icon: Icons.flash_on_outlined,
              content: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _ActionPill(
                    label: 'Demandes ouvertes',
                    icon: Icons.campaign_outlined,
                    onTap: () => context.go('/pro-leads'),
                  ),
                  _ActionPill(
                    label: 'Offres envoyées',
                    icon: Icons.inventory_2_outlined,
                    onTap: () => context.go('/pro-sent-offers'),
                  ),
                  _ActionPill(
                    label: 'Catégories',
                    icon: Icons.category_outlined,
                    onTap: () => context.go('/admin-categories'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackOfficeStats {
  const _BackOfficeStats({
    required this.openRequests,
    required this.lockedRequests,
    required this.requestsWithOffers,
    required this.acceptedOffers,
    required this.last24hOffers,
    required this.conversionRate,
    required this.coverageRate,
    required this.averageOffersPerRequest,
  });

  final int openRequests;
  final int lockedRequests;
  final int requestsWithOffers;
  final int acceptedOffers;
  final int last24hOffers;
  final double conversionRate;
  final double coverageRate;
  final double averageOffersPerRequest;
}

class _ProfessionalPerformance {
  const _ProfessionalPerformance({
    required this.professionalId,
    required this.professionalName,
    required this.planLabel,
    required this.offersCount,
    required this.acceptedCount,
  });

  final String professionalId;
  final String professionalName;
  final String planLabel;
  final int offersCount;
  final int acceptedCount;

  double get conversionRate {
    if (offersCount == 0) {
      return 0;
    }
    return (acceptedCount / offersCount) * 100;
  }

  _ProfessionalPerformance copyWith({
    int? offersCount,
    int? acceptedCount,
  }) {
    return _ProfessionalPerformance(
      professionalId: professionalId,
      professionalName: professionalName,
      planLabel: planLabel,
      offersCount: offersCount ?? this.offersCount,
      acceptedCount: acceptedCount ?? this.acceptedCount,
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.accent,
    required this.icon,
  });

  final String title;
  final String value;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiStrip extends StatelessWidget {
  const _KpiStrip({
    required this.label,
    required this.value,
    required this.helper,
    required this.accent,
  });

  final String label;
  final String value;
  final String helper;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            helper,
            style: const TextStyle(
              color: AppColors.muted,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _FunnelBar extends StatelessWidget {
  const _FunnelBar({
    required this.openRequests,
    required this.coveredRequests,
    required this.lockedRequests,
  });

  final int openRequests;
  final int coveredRequests;
  final int lockedRequests;

  @override
  Widget build(BuildContext context) {
    final maxValue = [openRequests, coveredRequests, lockedRequests]
        .reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        _FunnelStep(
          label: 'Demandes ouvertes',
          value: openRequests,
          maxValue: maxValue,
          color: AppColors.navy,
        ),
        const SizedBox(height: 8),
        _FunnelStep(
          label: 'Demandes couvertes',
          value: coveredRequests,
          maxValue: maxValue,
          color: AppColors.primary,
        ),
        const SizedBox(height: 8),
        _FunnelStep(
          label: 'Demandes attribuées',
          value: lockedRequests,
          maxValue: maxValue,
          color: AppColors.success,
        ),
      ],
    );
  }
}

class _FunnelStep extends StatelessWidget {
  const _FunnelStep({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  final String label;
  final int value;
  final int maxValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ratio = maxValue == 0 ? 0.0 : value / maxValue;

    return Row(
      children: [
        SizedBox(
          width: 118,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: ratio.clamp(0.0, 1.0),
              backgroundColor: color.withValues(alpha: 0.10),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$value',
          style: TextStyle(color: color, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  const _LeaderboardTile({
    required this.rank,
    required this.performance,
  });

  final int rank;
  final _ProfessionalPerformance performance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  performance.professionalName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${performance.planLabel.toUpperCase()} • ${performance.offersCount} offre(s) • ${performance.acceptedCount} retenue(s)',
                  style: const TextStyle(color: AppColors.muted),
                ),
              ],
            ),
          ),
          Text(
            '${performance.conversionRate.toStringAsFixed(0)}%',
            style: const TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.actionLabel,
    this.onTap,
    this.content,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onTap;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.navy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.navy),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.muted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (content != null) ...[
            const SizedBox(height: 12),
            content!,
          ],
          if (actionLabel != null && onTap != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onTap,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  minimumSize: const Size.fromHeight(42),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                icon: const Icon(Icons.arrow_forward_outlined, size: 18),
                label: Text(actionLabel!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.navy),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
