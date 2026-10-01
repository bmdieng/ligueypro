import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppColors.muted,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _buildGroup(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
              children: [
                const CircleAvatar(
                    radius: 42, child: Icon(Icons.person, size: 42)),
                const SizedBox(height: 10),
                Text(
                  l10n.profileAccountTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.profileAccountSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          _buildSectionTitle(l10n.profileSectionRequests),
          _buildGroup([
            ListTile(
              leading: const Icon(Icons.add_task_outlined),
              title: Text(l10n.profileNewRequest,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/request'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: Text(l10n.profileMyRequests,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/my-requests'),
            ),
          ]),
          _buildSectionTitle(l10n.profileSectionProNetwork),
          _buildGroup([
            // const ListTile(
            //   leading: Icon(Icons.favorite_border),
            //   title: Text(
            //     'Professionnels favoris',
            //     maxLines: 1,
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ),
            // const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.person_add_alt_1_outlined),
              title: Text(l10n.profileAddProfessional,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/add-professional'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.group_outlined),
              title: Text(l10n.profileAllProfessionals,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/all-professionals'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.workspace_premium_outlined),
              title: const Text('Mon compte pro',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: const Text('Crédits, boost et statut du profil'),
              onTap: () => context.push('/pro-account'),
            ),
            // const Divider(height: 1),
            // ListTile(
            //   leading: const Icon(Icons.admin_panel_settings_outlined),
            //   title: const Text('Back-office',
            //       maxLines: 1, overflow: TextOverflow.ellipsis),
            //   subtitle:
            //       const Text('Accès sécurisé aux demandes et au pilotage'),
            //   onTap: () => context.push('/back-office'),
            // ),
            // const Divider(height: 1),
            // ListTile(
            //   leading: const Icon(Icons.inventory_2_outlined),
            //   title: const Text('Mes offres envoyées',
            //       maxLines: 1, overflow: TextOverflow.ellipsis),
            //   subtitle: const Text('Suivre les offres déjà transmises'),
            //   onTap: () => context.push('/pro-sent-offers'),
            // ),
          ]),
          _buildSectionTitle(l10n.profileSectionApplication),
          _buildGroup([
            ListTile(
              leading: const Icon(Icons.play_circle_outline),
              title: Text(l10n.profilePresentation,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/presentation'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.notifications_none),
              title: Text(l10n.commonNotifications,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/notifications'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l10n.profileSettingsShort,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/settings'),
            ),
          ]),
          _buildSectionTitle(l10n.profileSectionSupport),
          _buildGroup([
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(l10n.profileHelpSupport,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/help-support'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(l10n.profileTerms,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/cgu'),
            ),
            // const Divider(height: 1),
            // const ListTile(
            //     leading: Icon(Icons.logout),
            //     title: Text('Se déconnecter',
            //         maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
