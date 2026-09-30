import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/app_preferences_service.dart';
import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/service_category_card.dart';

class _HomeCategory {
  const _HomeCategory({
    required this.icon,
    required this.label,
    required this.order,
  });

  final IconData icon;
  final String label;
  final int order;
}

class _HomeMetrics {
  const _HomeMetrics({
    required this.verifiedProfessionalsCount,
    required this.averageResponseMinutes,
    required this.averageRating,
    required this.reviewsCount,
  });

  final int verifiedProfessionalsCount;
  final double? averageResponseMinutes;
  final double? averageRating;
  final int reviewsCount;
}

class _HomeHeroContent {
  const _HomeHeroContent({
    required this.title,
    required this.subtitle,
    required this.primaryCtaLabel,
    required this.secondaryCtaLabel,
  });

  final String title;
  final String subtitle;
  final String primaryCtaLabel;
  final String secondaryCtaLabel;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  RecentRequestSummary? _recentRequest;

  static IconData _iconFromKey(String key) {
    switch (key) {
      case 'plumbing':
        return Icons.plumbing;
      case 'bolt':
        return Icons.bolt;
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'grass':
        return Icons.grass;
      case 'build':
        return Icons.build;
      case 'directions_car':
        return Icons.directions_car;
      case 'motorcycle':
        return Icons.motorcycle;
      case 'store':
        return Icons.store;
      case 'computer':
        return Icons.computer;
      case 'child_care':
        return Icons.child_care;
      case 'security':
        return Icons.security;
      case 'person_outline':
        return Icons.person_outline;
      default:
        return Icons.more_horiz;
    }
  }

  static List<_HomeCategory> _categoriesFromSnapshot(Object? snapshotValue) {
    final categories = <_HomeCategory>[];
    var fallbackOrder = 0;

    void collectFrom(dynamic value) {
      if (value is Map) {
        final label = value['label']?.toString();
        final iconKey = value['icon']?.toString() ?? 'more_horiz';

        if (label != null && label.trim().isNotEmpty) {
          final rawOrder = value['order'];
          final order = rawOrder is num
              ? rawOrder.toInt()
              : int.tryParse(rawOrder?.toString() ?? '') ?? fallbackOrder;
          categories.add(
            _HomeCategory(
              icon: _iconFromKey(iconKey),
              label: label,
              order: order,
            ),
          );
          fallbackOrder++;
          return;
        }

        for (final item in value.values) {
          collectFrom(item);
        }
      } else if (value is List) {
        for (final item in value) {
          collectFrom(item);
        }
      }
    }

    if (snapshotValue != null) {
      collectFrom(snapshotValue);
      categories.sort((a, b) {
        final aIsOther = a.label.trim().toLowerCase() == 'autres';
        final bIsOther = b.label.trim().toLowerCase() == 'autres';

        if (aIsOther != bIsOther) {
          return aIsOther ? 1 : -1;
        }

        if (a.order != b.order) {
          return a.order.compareTo(b.order);
        }
        return a.label.toLowerCase().compareTo(b.label.toLowerCase());
      });
      debugPrint(
          'Firebase categories parsed: ${categories.length} items from $snapshotValue');
    }

    return categories;
  }

  @override
  void initState() {
    super.initState();
    _loadRecentRequest();
  }

  Future<void> _loadRecentRequest() async {
    final recentRequest = await AppPreferencesService.getRecentRequest();
    if (!mounted) return;
    setState(() {
      _recentRequest = recentRequest;
    });
  }

  String _statusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'accepted':
        return l10n.homeStatusAccepted;
      case 'awaiting_offers':
        return l10n.homeStatusAwaitingOffers;
      case 'in_progress':
        return l10n.homeStatusInProgress;
      case 'completed':
        return l10n.homeStatusCompleted;
      default:
        return l10n.homeStatusPending;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return AppColors.primary;
      case 'awaiting_offers':
        return AppColors.navy;
      case 'in_progress':
        return AppColors.navy;
      case 'completed':
        return AppColors.success;
      default:
        return AppColors.danger;
    }
  }

  Widget _buildTrustMetric(String label, String value, {String? helper}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
            if (helper != null) ...[
              const SizedBox(height: 4),
              Text(
                helper,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: AppColors.muted),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static _HomeMetrics _metricsFromRoot(Object? root) {
    final professionalsRoot = root is Map ? root['professionals'] : null;
    var verifiedProfessionalsCount = 0;
    var responseMinutesTotal = 0.0;
    var responseMinutesCount = 0;
    var weightedRatingTotal = 0.0;
    var weightedRatingCount = 0;

    void collectFrom(dynamic value) {
      if (value is Map) {
        final name = value['name']?.toString();
        if (name != null && name.trim().isNotEmpty) {
          if (value['verified'] == true) {
            verifiedProfessionalsCount++;
          }

          final responseMinutes = _parseResponseMinutes(
            value['responseTime']?.toString(),
          );
          if (responseMinutes != null) {
            responseMinutesTotal += responseMinutes;
            responseMinutesCount++;
          }

          final ratingAverage = value['ratingAverage'] is num
              ? (value['ratingAverage'] as num).toDouble()
              : _parseRating(value['rating']?.toString());
          final reviewsCount = value['reviewsCount'] is num
              ? (value['reviewsCount'] as num).toInt()
              : 0;

          if (reviewsCount > 0) {
            weightedRatingTotal += ratingAverage * reviewsCount;
            weightedRatingCount += reviewsCount;
          }
          return;
        }

        for (final nestedValue in value.values) {
          collectFrom(nestedValue);
        }
      } else if (value is List) {
        for (final item in value) {
          collectFrom(item);
        }
      }
    }

    collectFrom(professionalsRoot);

    return _HomeMetrics(
      verifiedProfessionalsCount: verifiedProfessionalsCount,
      averageResponseMinutes: responseMinutesCount == 0
          ? null
          : responseMinutesTotal / responseMinutesCount,
      averageRating: weightedRatingCount == 0
          ? null
          : weightedRatingTotal / weightedRatingCount,
      reviewsCount: weightedRatingCount,
    );
  }

  static _HomeHeroContent _defaultHeroContent(AppLocalizations l10n) {
    return _HomeHeroContent(
      title: l10n.homeDefaultHeroTitle,
      subtitle: l10n.homeDefaultHeroSubtitle,
      primaryCtaLabel: l10n.homeDefaultHeroPrimaryCta,
      secondaryCtaLabel: l10n.homeDefaultHeroSecondaryCta,
    );
  }

  static _HomeHeroContent _heroContentFromRoot(
    Object? root,
    AppLocalizations l10n,
  ) {
    final home = root is Map ? root['home'] : null;
    final hero = home is Map ? home['hero'] : null;
    final defaultHeroContent = _defaultHeroContent(l10n);
    if (hero is! Map) {
      return defaultHeroContent;
    }

    String resolveText(String key, String fallback) {
      final value = hero[key]?.toString().trim();
      if (value == null || value.isEmpty) {
        return fallback;
      }
      return value;
    }

    return _HomeHeroContent(
      title: resolveText('title', defaultHeroContent.title),
      subtitle: resolveText('subtitle', defaultHeroContent.subtitle),
      primaryCtaLabel: resolveText(
        'primaryCtaLabel',
        defaultHeroContent.primaryCtaLabel,
      ),
      secondaryCtaLabel: resolveText(
        'secondaryCtaLabel',
        defaultHeroContent.secondaryCtaLabel,
      ),
    );
  }

  static double _parseRating(String? ratingText) {
    if (ratingText == null || ratingText.isEmpty) {
      return 0;
    }

    final match = RegExp(r'\d+(?:[.,]\d+)?').firstMatch(ratingText);
    if (match == null) {
      return 0;
    }

    return double.tryParse(match.group(0)!.replaceAll(',', '.')) ?? 0;
  }

  static double? _parseResponseMinutes(String? responseTimeText) {
    if (responseTimeText == null || responseTimeText.trim().isEmpty) {
      return null;
    }

    final normalized = responseTimeText.toLowerCase();
    final match = RegExp(r'(\d+(?:[.,]\d+)?)').firstMatch(normalized);
    if (match == null) {
      return null;
    }

    final value = double.tryParse(match.group(0)!.replaceAll(',', '.'));
    if (value == null) {
      return null;
    }

    if (normalized.contains('heure') || normalized.contains('hour')) {
      return value * 60;
    }
    if (normalized.contains('jour')) {
      return value * 24 * 60;
    }
    return value;
  }

  static String _formatProfessionalsCount(int count) {
    if (count <= 0) {
      return '0';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(count % 1000 == 0 ? 0 : 1)}k';
    }
    return '$count';
  }

  static String _formatAverageResponse(
    double? minutes,
    AppLocalizations l10n,
  ) {
    if (minutes == null) {
      return l10n.homeMetricNotAvailable;
    }
    if (minutes < 60) {
      return '${minutes.round()} min';
    }

    final hours = minutes / 60;
    return '${hours.toStringAsFixed(hours >= 10 ? 0 : 1)} h';
  }

  static String _formatAverageRating(
    _HomeMetrics metrics,
    AppLocalizations l10n,
  ) {
    if (metrics.averageRating == null) {
      return l10n.homeMetricNotAvailable;
    }
    return '${metrics.averageRating!.toStringAsFixed(1)}/5';
  }

  static String? _formatReviewsCount(int count, AppLocalizations l10n) {
    if (count <= 0) {
      return null;
    }
    return l10n.homeReviewsCount(count);
  }

  Widget _buildCategories(
    BuildContext context,
    AppLocalizations l10n,
    List<_HomeCategory> categories,
  ) {
    if (categories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        ),
        child: Column(
          children: [
            const Icon(Icons.category_outlined,
                size: 40, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              l10n.homeCategoriesEmptyTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.homeCategoriesEmptyDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, height: 1.4),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 500
            ? 4
            : constraints.maxWidth > 350
                ? 3
                : 2;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.0,
          children: categories
              .map(
                (category) => ServiceCategoryCard(
                  icon: category.icon,
                  label: category.label,
                  onTap: () => context
                      .push('/services/${Uri.encodeComponent(category.label)}'),
                ),
              )
              .toList(),
        );
      },
    );
  }

  void _submitSearch(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      context.push('/services/${Uri.encodeComponent(l10n.homeSearchFallback)}');
      return;
    }

    final encodedQuery = Uri.encodeComponent(query);
    context.push('/services/$encodedQuery');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 84,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: SvgPicture.asset(
              'assets/ligueypro_logo.svg',
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: FirebaseBootstrap.isReady
            ? StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance.ref().onValue,
                builder: (context, snapshot) {
                  final root = snapshot.data?.snapshot.value;
                  final categories = root is Map
                      ? _categoriesFromSnapshot(root['home']?['categories'])
                      : const <_HomeCategory>[];
                  final metrics = _metricsFromRoot(root);
                  final heroContent = _heroContentFromRoot(root, l10n);
                  return _buildContent(
                    context,
                    l10n,
                    categories,
                    metrics,
                    heroContent,
                  );
                },
              )
            : _buildContent(
                context,
                l10n,
                const <_HomeCategory>[],
                const _HomeMetrics(
                  verifiedProfessionalsCount: 0,
                  averageResponseMinutes: null,
                  averageRating: null,
                  reviewsCount: 0,
                ),
                _defaultHeroContent(l10n),
              ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: l10n.homeNavHome),
          NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              label: l10n.homeNavRequests),
          NavigationDestination(
              icon: Icon(Icons.groups_outlined), label: l10n.homeNavPros),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: l10n.homeNavProfile),
        ],
        onDestinationSelected: (index) {
          if (index == 3) context.push('/profile');
          if (index == 1) context.push('/my-requests');
          if (index == 2) context.push('/all-professionals');
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    List<_HomeCategory> categories,
    _HomeMetrics metrics,
    _HomeHeroContent heroContent,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.homeGreeting,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(l10n.homeQuestion, style: const TextStyle(color: AppColors.muted)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.navy, Color(0xFF174B79)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                heroContent.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                heroContent.subtitle,
                style: const TextStyle(color: Colors.white70, height: 1.4),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => context.push('/request'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.navy,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.flash_on_rounded),
                      label: Text(heroContent.primaryCtaLabel),
                    ),
                  ),
                  // const SizedBox(width: 12),
                  // OutlinedButton(
                  //   onPressed: () => context.push('/all-professionals'),
                  //   style: OutlinedButton.styleFrom(
                  //     foregroundColor: Colors.white,
                  //     side: const BorderSide(color: Colors.white38),
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 16, vertical: 14),
                  //   ),
                  //   child: Text(heroContent.secondaryCtaLabel),
                  // ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildTrustMetric(
              l10n.homeMetricVerifiedPros,
              _formatProfessionalsCount(metrics.verifiedProfessionalsCount),
            ),
            const SizedBox(width: 10),
            _buildTrustMetric(
              l10n.homeMetricAverageResponse,
              _formatAverageResponse(metrics.averageResponseMinutes, l10n),
            ),
            const SizedBox(width: 10),
            _buildTrustMetric(
              l10n.homeMetricAverageRating,
              _formatAverageRating(metrics, l10n),
              helper: _formatReviewsCount(metrics.reviewsCount, l10n),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _searchController,
          onSubmitted: (_) => _submitSearch(context),
          decoration: InputDecoration(
            hintText: l10n.homeSearchHint,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _submitSearch(context),
            ),
          ),
        ),
        if (_recentRequest != null) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.homeRecentRequestTitle,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor(_recentRequest!.status)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _statusLabel(_recentRequest!.status, l10n),
                        style: TextStyle(
                          color: _statusColor(_recentRequest!.status),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _recentRequest!.service,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_recentRequest!.urgency} • ${_recentRequest!.location}',
                  style: const TextStyle(color: AppColors.muted),
                ),
                if (_recentRequest!.acceptedProfessionalName != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.homeAcceptedOfferTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _recentRequest!.acceptedProfessionalName!,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        if (_recentRequest!.acceptedOfferPrice != null)
                          Text(
                            l10n.homeAcceptedPrice(
                              _recentRequest!.acceptedOfferPrice!,
                            ),
                            style: const TextStyle(color: AppColors.muted),
                          ),
                        if (_recentRequest!.acceptedOfferEta != null)
                          Text(
                            l10n.homeConfirmedEta(
                              _recentRequest!.acceptedOfferEta!,
                            ),
                            style: const TextStyle(color: AppColors.muted),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.push('/my-requests'),
                        child: Text(l10n.homeTrackRequest),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => context.push('/request'),
                        style: FilledButton.styleFrom(
                            backgroundColor: AppColors.navy),
                        child: Text(l10n.homeNewRequest),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 22),
        Text(l10n.homePopularServices,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        _buildCategories(context, l10n, categories),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.navy, Color(0xFF1B5B8F)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.homeNeedHelpTitle,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(l10n.homeNeedHelpDescription,
                  style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.push('/presentation'),
                icon: const Icon(Icons.play_circle_outline),
                label: Text(l10n.homeSeePresentation),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => context.push('/request'),
                style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
                icon: const Icon(Icons.assignment_turned_in_outlined),
                label: Text(l10n.homeNewRequest),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
