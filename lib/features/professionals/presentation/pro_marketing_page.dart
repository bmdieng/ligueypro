import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/pro_subscription_service.dart';
import '../../../core/theme/app_colors.dart';

class ProMarketingPage extends StatelessWidget {
  const ProMarketingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 920;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _HeaderBar(compact: compact),
            const SizedBox(height: 18),
            compact
                ? const Column(
                    children: [
                      _ProHeroCard(),
                      SizedBox(height: 14),
                      _ProActionCard(),
                    ],
                  )
                : const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _ProHeroCard()),
                      SizedBox(width: 14),
                      Expanded(flex: 2, child: _ProActionCard()),
                    ],
                  ),
            const SizedBox(height: 18),
            _SectionCard(
              title: 'Pourquoi s’abonner',
              subtitle:
                  'Le modèle LigueyPro remplace le paiement client dans l’application par une logique simple d’abonnement professionnel.',
              child: compact
                  ? const Column(
                      children: [
                        _ValueCard(
                          icon: Icons.campaign_outlined,
                          title: 'Recevoir des demandes ciblées',
                          description:
                              'Accédez aux demandes liées à votre métier et à votre zone d’intervention.',
                        ),
                        SizedBox(height: 12),
                        _ValueCard(
                          icon: Icons.local_offer_outlined,
                          title: 'Envoyer des offres claires',
                          description:
                              'Répondez avec vos tarifs, délais et un message rassurant pour augmenter votre conversion.',
                        ),
                        SizedBox(height: 12),
                        _ValueCard(
                          icon: Icons.analytics_outlined,
                          title: 'Piloter votre performance',
                          description:
                              'Suivez vos offres, vos gains et vos indicateurs dans un back-office sécurisé.',
                        ),
                      ],
                    )
                  : const Row(
                      children: [
                        Expanded(
                          child: _ValueCard(
                            icon: Icons.campaign_outlined,
                            title: 'Recevoir des demandes ciblées',
                            description:
                                'Accédez aux demandes liées à votre métier et à votre zone d’intervention.',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _ValueCard(
                            icon: Icons.local_offer_outlined,
                            title: 'Envoyer des offres claires',
                            description:
                                'Répondez avec vos tarifs, délais et un message rassurant pour augmenter votre conversion.',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _ValueCard(
                            icon: Icons.analytics_outlined,
                            title: 'Piloter votre performance',
                            description:
                                'Suivez vos offres, vos gains et vos indicateurs dans un back-office sécurisé.',
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              title: 'Plans professionnels',
              subtitle:
                  'Choisissez un niveau d’engagement adapté à votre volume de demandes et à votre ambition commerciale.',
              child: compact
                  ? Column(
                      children: [
                        for (var i = 0;
                            i < ProSubscriptionService.plans.length;
                            i++)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  i == ProSubscriptionService.plans.length - 1
                                      ? 0
                                      : 12,
                            ),
                            child: _PlanCard(
                              plan: ProSubscriptionService.plans[i],
                              highlighted:
                                  ProSubscriptionService.plans[i].id == 'pro',
                            ),
                          ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0;
                            i < ProSubscriptionService.plans.length;
                            i++) ...[
                          Expanded(
                            child: _PlanCard(
                              plan: ProSubscriptionService.plans[i],
                              highlighted:
                                  ProSubscriptionService.plans[i].id == 'pro',
                            ),
                          ),
                          if (i != ProSubscriptionService.plans.length - 1)
                            const SizedBox(width: 12),
                        ],
                      ],
                    ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.navy,
                    Color(0xFF18486F),
                    AppColors.primary
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: compact
                  ? const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prêt à activer votre profil pro ?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Ajoutez votre profil, choisissez votre abonnement et accédez ensuite à votre back-office sécurisé pour traiter les demandes.',
                          style: TextStyle(color: Colors.white70, height: 1.4),
                        ),
                        SizedBox(height: 16),
                        _ProBottomActions(),
                      ],
                    )
                  : const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Prêt à activer votre profil pro ?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Ajoutez votre profil, choisissez votre abonnement et accédez ensuite à votre back-office sécurisé pour traiter les demandes.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 18),
                        Expanded(child: _ProBottomActions()),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({required this.compact});

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
                const _BrandTag(),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    OutlinedButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Accueil'),
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
                const Expanded(child: _BrandTag()),
                OutlinedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Accueil'),
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

class _BrandTag extends StatelessWidget {
  const _BrandTag();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LigueyPro pour les professionnels',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 4),
        Text(
          'Leads, offres, abonnement et back-office sécurisé',
          style: TextStyle(color: AppColors.muted),
        ),
      ],
    );
  }
}

class _ProHeroCard extends StatelessWidget {
  const _ProHeroCard();

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
              'Abonnement pro + conversion',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Recevez plus d’opportunités qualifiées et répondez plus vite que vos concurrents.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'LigueyPro permet aux professionnels abonnés de capter des demandes réelles, d’émettre des offres structurées et de piloter leur activité avec des indicateurs simples.',
            style: TextStyle(color: Colors.white70, height: 1.45),
          ),
          const SizedBox(height: 22),
          const Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  value: '80',
                  label: 'leads mensuels sur le plan Pro',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _HeroMetric(
                  value: '4',
                  label: 'chiffres pour protéger le BO',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _HeroMetric(
                  value: '1',
                  label: 'workflow simple d’acquisition',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _ProActionCard extends StatelessWidget {
  const _ProActionCard();

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
            'Démarrer en 3 étapes',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'Créez votre profil, activez votre abonnement, puis traitez vos demandes depuis le BO.',
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 18),
          const _StepTile(
            step: '1',
            title: 'Ajouter votre profil',
            body: 'Renseignez votre service, votre zone et vos coordonnées.',
          ),
          const SizedBox(height: 12),
          const _StepTile(
            step: '2',
            title: 'Choisir un plan',
            body: 'Activez un abonnement adapté à votre volume de leads.',
          ),
          const SizedBox(height: 12),
          const _StepTile(
            step: '3',
            title: 'Piloter vos offres',
            body: 'Suivez vos réponses, vos attributions et votre conversion.',
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => context.go('/for-pros/apply'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navy,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              icon: const Icon(Icons.person_add_alt_1_outlined),
              label: const Text('Laisser mes coordonnées'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go('/pro-subscription'),
              icon: const Icon(Icons.workspace_premium_outlined),
              label: const Text('Voir les abonnements'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.step,
    required this.title,
    required this.body,
  });

  final String step;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            step,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: const TextStyle(color: AppColors.muted, height: 1.35),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
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

class _ValueCard extends StatelessWidget {
  const _ValueCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

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
            description,
            style: const TextStyle(color: AppColors.muted, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.highlighted});

  final ProSubscriptionPlan plan;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: highlighted
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.08),
          width: highlighted ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (highlighted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Le plus équilibré',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          if (highlighted) const SizedBox(height: 12),
          Text(
            plan.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            ProSubscriptionService.formatFcfa(plan.priceFcfa),
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${plan.leadsPerMonth} demandes par mois',
            style: const TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 14),
          ...plan.features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(feature)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.go('/pro-subscription'),
              style: FilledButton.styleFrom(
                backgroundColor:
                    highlighted ? AppColors.primary : AppColors.navy,
              ),
              child: Text('Choisir ${plan.name}'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProBottomActions extends StatelessWidget {
  const _ProBottomActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => context.go('/for-pros/apply'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.navy,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            icon: const Icon(Icons.person_add_alt_1_outlined),
            label: const Text('Laisser mes coordonnées'),
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
