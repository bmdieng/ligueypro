import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

class PresentationLandingPage extends StatelessWidget {
  const PresentationLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 860;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _TopBar(compact: compact),
            const SizedBox(height: 20),
            compact
                ? Column(
                    children: [
                      _HeroCard(compact: compact),
                      const SizedBox(height: 16),
                      const _AccessPanel(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(flex: 3, child: _HeroCard(compact: false)),
                      SizedBox(width: 16),
                      Expanded(flex: 2, child: _AccessPanel()),
                    ],
                  ),
            const SizedBox(height: 18),
            _SectionShell(
              title: 'Pourquoi LigueyPro',
              subtitle:
                  'Une place de marché locale pensée pour accélérer la rencontre entre clients et professionnels abonnés.',
              child: compact
                  ? const Column(
                      children: [
                        _FeatureCard(
                          icon: Icons.flash_on_outlined,
                          title: 'Demande express',
                          body:
                              'Le client publie son besoin en quelques secondes avec urgence, zone et téléphone.',
                        ),
                        SizedBox(height: 12),
                        _FeatureCard(
                          icon: Icons.local_offer_outlined,
                          title: 'Offres comparables',
                          body:
                              'Les pros abonnés répondent avec prix, délai et message personnalisé.',
                        ),
                        SizedBox(height: 12),
                        _FeatureCard(
                          icon: Icons.admin_panel_settings_outlined,
                          title: 'BO sécurisé',
                          body:
                              'Le back-office permet de piloter les demandes, les offres et la performance commerciale.',
                        ),
                      ],
                    )
                  : const Row(
                      children: [
                        Expanded(
                          child: _FeatureCard(
                            icon: Icons.flash_on_outlined,
                            title: 'Demande express',
                            body:
                                'Le client publie son besoin en quelques secondes avec urgence, zone et téléphone.',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _FeatureCard(
                            icon: Icons.local_offer_outlined,
                            title: 'Offres comparables',
                            body:
                                'Les pros abonnés répondent avec prix, délai et message personnalisé.',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _FeatureCard(
                            icon: Icons.admin_panel_settings_outlined,
                            title: 'BO sécurisé',
                            body:
                                'Le back-office permet de piloter les demandes, les offres et la performance commerciale.',
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 18),
            _SectionShell(
              title: 'Indicateurs clés',
              subtitle:
                  'Un positionnement lisible pour la vitrine web, avec une promesse claire pour les clients et pour les professionnels.',
              child: compact
                  ? const Column(
                      children: [
                        _MetricTile(label: 'Services couverts', value: '11+'),
                        SizedBox(height: 10),
                        _MetricTile(label: 'Parcours client', value: 'Simple'),
                        SizedBox(height: 10),
                        _MetricTile(label: 'Monétisation', value: 'Abonnement'),
                        SizedBox(height: 10),
                        _MetricTile(label: 'Accès BO', value: 'Sécurisé'),
                      ],
                    )
                  : const Row(
                      children: [
                        Expanded(
                          child: _MetricTile(
                            label: 'Services couverts',
                            value: '11+',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _MetricTile(
                            label: 'Parcours client',
                            value: 'Simple',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _MetricTile(
                            label: 'Monétisation',
                            value: 'Abonnement',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _MetricTile(
                            label: 'Accès BO',
                            value: 'Sécurisé',
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.navy, Color(0xFF194E79)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: compact
                  ? const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Passez à l’application',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Consultez les services, publiez une demande ou ouvrez votre back-office professionnel sécurisé.',
                          style: TextStyle(color: Colors.white70, height: 1.4),
                        ),
                        SizedBox(height: 16),
                        _BottomCtas(),
                      ],
                    )
                  : const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Passez à l’application',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Consultez les services, publiez une demande ou ouvrez votre back-office professionnel sécurisé.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 18),
                        Expanded(child: _BottomCtas()),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _BrandBlock(),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    OutlinedButton(
                      onPressed: () => context.go('/presentation'),
                      child: const Text('Présentation'),
                    ),
                    FilledButton(
                      onPressed: () => context.go('/back-office'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.navy,
                      ),
                      child: const Text('Back-office'),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                const Expanded(child: _BrandBlock()),
                OutlinedButton(
                  onPressed: () => context.go('/presentation'),
                  child: const Text('Présentation'),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: () => context.go('/back-office'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                  ),
                  child: const Text('Back-office'),
                ),
              ],
            ),
    );
  }
}

class _BrandBlock extends StatelessWidget {
  const _BrandBlock();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.navy],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.handyman_outlined, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LigueyPro',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 4),
              Text(
                'Marketplace sénégalaise de services et back-office professionnel',
                style: TextStyle(color: AppColors.muted, height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, Color(0xFF154972), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Client + Professionnel + BO',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            compact
                ? 'Le bon pro, plus vite.'
                : 'Publiez une demande, comparez les offres et pilotez vos opérations depuis un back-office sécurisé.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'LigueyPro connecte les besoins du quotidien aux professionnels abonnés, avec une logique simple : recevoir des demandes qualifiées, répondre avec une offre claire et suivre la conversion.',
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
          const SizedBox(height: 22),
          compact ? const _HeroHighlightsColumn() : const _HeroHighlightsRow(),
        ],
      ),
    );
  }
}

class _HeroHighlightsRow extends StatelessWidget {
  const _HeroHighlightsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _HeroHighlight(
            value: '11+',
            label: 'services couverts',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _HeroHighlight(
            value: '30 min',
            label: 'session BO sécurisée',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _HeroHighlight(
            value: '100%',
            label: 'modèle abonnement pro',
          ),
        ),
      ],
    );
  }
}

class _HeroHighlightsColumn extends StatelessWidget {
  const _HeroHighlightsColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _HeroHighlight(value: '11+', label: 'services couverts'),
        SizedBox(height: 10),
        _HeroHighlight(value: '30 min', label: 'session BO sécurisée'),
        SizedBox(height: 10),
        _HeroHighlight(value: '100%', label: 'modèle abonnement pro'),
      ],
    );
  }
}

class _HeroHighlight extends StatelessWidget {
  const _HeroHighlight({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _AccessPanel extends StatelessWidget {
  const _AccessPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Entrées rapides',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choisissez votre parcours selon votre rôle ou votre objectif du moment.',
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 18),
          _AccessTile(
            icon: Icons.storefront_outlined,
            title: 'Parcourir l’application',
            subtitle: 'Découvrir les services et publier une demande.',
            accent: AppColors.navy,
            onTap: () => context.go('/app'),
          ),
          const SizedBox(height: 12),
          _AccessTile(
            icon: Icons.admin_panel_settings_outlined,
            title: 'Ouvrir le back-office',
            subtitle: 'Accès protégé aux leads, offres et statistiques.',
            accent: AppColors.primary,
            onTap: () => context.go('/back-office'),
          ),
          const SizedBox(height: 12),
          _AccessTile(
            icon: Icons.play_circle_outline,
            title: 'Voir la présentation',
            subtitle: 'Comprendre le fonctionnement de LigueyPro.',
            accent: AppColors.success,
            onTap: () => context.go('/presentation'),
          ),
        ],
      ),
    );
  }
}

class _AccessTile extends StatelessWidget {
  const _AccessTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withValues(alpha: 0.10)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.muted,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_outlined, color: accent),
          ],
        ),
      ),
    );
  }
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.navy.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.navy),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(color: AppColors.muted, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _BottomCtas extends StatelessWidget {
  const _BottomCtas();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => context.go('/app'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.navy,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            icon: const Icon(Icons.storefront_outlined),
            label: const Text('Entrer dans l’application'),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.go('/back-office'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white38),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            icon: const Icon(Icons.admin_panel_settings_outlined),
            label: const Text('Accéder au BO sécurisé'),
          ),
        ),
      ],
    );
  }
}
