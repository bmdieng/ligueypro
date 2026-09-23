import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/service_category_card.dart';

class _HomeCategory {
  const _HomeCategory({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  static const List<_HomeCategory> _fallbackCategories = [
    _HomeCategory(icon: Icons.plumbing, label: 'Plombier'),
    _HomeCategory(icon: Icons.bolt, label: 'Électricien'),
    _HomeCategory(icon: Icons.cleaning_services, label: 'Ménage'),
    _HomeCategory(icon: Icons.ac_unit, label: 'Climatisation'),
    _HomeCategory(icon: Icons.grass, label: 'Jardinage'),
    _HomeCategory(icon: Icons.directions_car, label: 'Chauffeur'),
    _HomeCategory(icon: Icons.build, label: 'Mécanicien'),
    _HomeCategory(icon: Icons.motorcycle, label: 'Livreur'),
    _HomeCategory(icon: Icons.store, label: 'Vendeur(se)'),
    _HomeCategory(icon: Icons.computer, label: 'Informatique'),
    _HomeCategory(icon: Icons.more_horiz, label: 'Autres'),
  ];

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
      default:
        return Icons.more_horiz;
    }
  }

  static List<_HomeCategory> _categoriesFromSnapshot(Object? snapshotValue) {
    final categories = <_HomeCategory>[];
    void collectFrom(dynamic value) {
      if (value is Map) {
        final label = value['label']?.toString();
        final iconKey = value['icon']?.toString() ?? 'more_horiz';

        if (label != null && label.trim().isNotEmpty) {
          categories.add(_HomeCategory(icon: _iconFromKey(iconKey), label: label));
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
      debugPrint('Firebase categories parsed: ${categories.length} items from $snapshotValue');
    }

    return categories.isNotEmpty ? categories : _fallbackCategories;
  }

  Widget _buildCategories(BuildContext context, List<_HomeCategory> categories) {
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
                  onTap: () => context.push('/services/${Uri.encodeComponent(category.label)}'),
                ),
              )
              .toList(),
        );
      },
    );
  }

  void _submitSearch(BuildContext context) {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      context.push('/services/Recherche');
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Bonjour 👋', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('De quel service avez-vous besoin ?',
              style: TextStyle(color: AppColors.muted)),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              onSubmitted: (_) => _submitSearch(context),
              decoration: InputDecoration(
                hintText: 'Rechercher un service...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _submitSearch(context),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text('Services populaires',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            if (!FirebaseBootstrap.isReady)
              _buildCategories(context, _fallbackCategories)
            else
              StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance.ref('home/categories').onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _buildCategories(context, _fallbackCategories);
                  }

                  final categories = _categoriesFromSnapshot(snapshot.data?.snapshot.value);
                  return _buildCategories(context, categories);
                },
              ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.navy, Color(0xFF1B5B8F)],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Besoin d’aide ?', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                  SizedBox(height: 8),
                  Text('Décrivez votre problème. LigueyPro AI vous aide à trouver le bon professionnel.',
                    style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Demandes'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
        onDestinationSelected: (index) {
          if (index == 3) context.push('/profile');
          if (index == 1) context.push('/my-requests');
        },
      ),
    );
  }
}
