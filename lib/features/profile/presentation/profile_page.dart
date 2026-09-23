import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
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
            child: const Column(
              children: [
                CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
                SizedBox(height: 10),
                Text(
                  'Mon compte',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Gérez vos demandes, vos préférences et votre espace pro.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          _buildSectionTitle('DEMANDES'),
          _buildGroup([
            ListTile(
              leading: const Icon(Icons.add_task_outlined),
              title: const Text('Nouvelle demande',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/request'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: const Text('Mes demandes',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/my-requests'),
            ),
          ]),
          _buildSectionTitle('RÉSEAU PRO'),
          _buildGroup([
            const ListTile(
              leading: Icon(Icons.favorite_border),
              title: Text(
                'Professionnels favoris',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.person_add_alt_1_outlined),
              title: const Text('Ajouter un professionnel',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/add-professional'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.group_outlined),
              title: const Text('Tous les professionnels',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/all-professionals'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.workspace_premium_outlined),
              title: const Text('Abonnement Pro',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle:
                  const Text('Recevoir les demandes et émettre des offres'),
              onTap: () => context.push('/pro-subscription'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: const Text('Back-office',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle:
                  const Text('Accès sécurisé aux demandes et au pilotage'),
              onTap: () => context.push('/back-office'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text('Mes offres envoyées',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: const Text('Suivre les offres déjà transmises'),
              onTap: () => context.push('/pro-sent-offers'),
            ),
          ]),
          _buildSectionTitle('APPLICATION'),
          _buildGroup([
            ListTile(
              leading: const Icon(Icons.play_circle_outline),
              title: const Text('Présentation de l’application',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/presentation'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.notifications_none),
              title: const Text('Notifications',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/settings'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Paramètres',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/settings'),
            ),
          ]),
          _buildSectionTitle('SUPPORT'),
          _buildGroup([
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Aide et support',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/help-support'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('CGU',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => context.push('/cgu'),
            ),
            const Divider(height: 1),
            const ListTile(
                leading: Icon(Icons.logout),
                title: Text('Se déconnecter',
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
