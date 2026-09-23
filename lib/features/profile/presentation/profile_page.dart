import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
          const SizedBox(height: 10),
          const Center(child: Text('Mon compte', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('Mes demandes', maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => context.push('/my-requests'),
          ),
          const ListTile(
            leading: Icon(Icons.favorite_border),
            title: Text(
              'Professionnels favoris',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const ListTile(leading: Icon(Icons.notifications_none), title: Text('Notifications', maxLines: 1, overflow: TextOverflow.ellipsis)),
          const ListTile(leading: Icon(Icons.settings_outlined), title: Text('Paramètres', maxLines: 1, overflow: TextOverflow.ellipsis)),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Aide et support', maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => context.push('/help-support'),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('CGU', maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => context.push('/cgu'),
          ),
          ListTile(
            leading: const Icon(Icons.person_add_alt_1_outlined),
            title: const Text('Ajouter un professionnel', maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => context.push('/add-professional'),
          ),
          ListTile(
            leading: const Icon(Icons.group_outlined),
            title: const Text('Tous les professionnels', maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => context.push('/all-professionals'),
          ),
          ListTile(
            leading: const Icon(Icons.play_circle_outline),
            title: const Text('Présentation de l’application', maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => context.push('/presentation'),
          ),
          const ListTile(leading: Icon(Icons.logout), title: Text('Se déconnecter', maxLines: 1, overflow: TextOverflow.ellipsis)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
