import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/app_preferences_service.dart';
import '../../../core/theme/app_colors.dart';

class SecureBackOfficeRoute extends StatelessWidget {
  const SecureBackOfficeRoute({
    super.key,
    required this.child,
    required this.targetRoute,
    this.title = 'Accès sécurisé',
  });

  final Widget child;
  final String targetRoute;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AppPreferencesService.isBackOfficeUnlocked(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return child;
        }

        return BackOfficeAccessPage(
          targetRoute: targetRoute,
          title: title,
        );
      },
    );
  }
}

class BackOfficeAccessPage extends StatefulWidget {
  const BackOfficeAccessPage({
    super.key,
    required this.targetRoute,
    this.title = 'Accès sécurisé',
  });

  final String targetRoute;
  final String title;

  @override
  State<BackOfficeAccessPage> createState() => _BackOfficeAccessPageState();
}

class _BackOfficeAccessPageState extends State<BackOfficeAccessPage> {
  final TextEditingController _codeController = TextEditingController();
  bool _isSubmitting = false;
  String _hint = 'Chargement du code d’accès...';

  @override
  void initState() {
    super.initState();
    _loadHint();
  }

  Future<void> _loadHint() async {
    final hint = await AppPreferencesService.getBackOfficeAccessHint();
    if (!mounted) {
      return;
    }

    setState(() {
      _hint = hint;
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isSubmitting = true;
    });

    final isValid = await AppPreferencesService.verifyBackOfficeAccessCode(
      _codeController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    if (!isValid) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Code invalide. Vérifiez le code BO et réessayez.'),
        ),
      );
      return;
    }

    await AppPreferencesService.unlockBackOffice();
    if (!mounted) {
      return;
    }

    context.go(widget.targetRoute);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.navy,
                    Color(0xFF164B77),
                    Color(0xFFBB8547)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Le back-office permet de piloter les demandes, vos offres et le professionnel actif. L’accès est limité à une session sécurisée de 30 minutes.',
                    style: TextStyle(color: Colors.white70, height: 1.45),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      _SecurityChip(
                        icon: Icons.lock_clock_outlined,
                        label: 'Session 30 min',
                      ),
                      _SecurityChip(
                        icon: Icons.verified_user_outlined,
                        label: 'Accès privé',
                      ),
                      _SecurityChip(
                        icon: Icons.phonelink_lock_outlined,
                        label: 'Code local',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.navy.withValues(alpha: 0.06),
                    blurRadius: 26,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Déverrouiller le BO',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _hint,
                    style: const TextStyle(color: AppColors.muted, height: 1.4),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Code BO',
                      hintText: 'Saisir 4 chiffres',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _isSubmitting ? null : _submit(),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isSubmitting ? null : _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.lock_open_outlined),
                      label: Text(
                        _isSubmitting
                            ? 'Vérification...'
                            : 'Accéder au back-office',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/profile'),
                      icon: const Icon(Icons.arrow_back_outlined),
                      label: const Text('Retour au profil'),
                    ),
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

class _SecurityChip extends StatelessWidget {
  const _SecurityChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
