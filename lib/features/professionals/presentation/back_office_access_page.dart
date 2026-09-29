import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/app_preferences_service.dart';
import '../../../core/theme/app_colors.dart';

class SecureBackOfficeRoute extends StatefulWidget {
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
  State<SecureBackOfficeRoute> createState() => _SecureBackOfficeRouteState();
}

class _SecureBackOfficeRouteState extends State<SecureBackOfficeRoute> {
  late Future<bool> _unlockFuture;

  @override
  void initState() {
    super.initState();
    _unlockFuture = AppPreferencesService.isBackOfficeUnlocked();
  }

  void _refreshAccess() {
    setState(() {
      _unlockFuture = AppPreferencesService.isBackOfficeUnlocked();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _unlockFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.data == true) {
          return widget.child;
        }

        return BackOfficeAccessPage(
          targetRoute: widget.targetRoute,
          title: widget.title,
          onUnlocked: _refreshAccess,
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
    required this.onUnlocked,
  });

  final String targetRoute;
  final String title;
  final VoidCallback onUnlocked;

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

    widget.onUnlocked();
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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.navy,
                        Color(0xFF164B77),
                        Color(0xFFBB8547),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.admin_panel_settings_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Le back-office permet de piloter les demandes, vos offres et le professionnel actif. L’accès est limité à une session sécurisée de 30 minutes.',
                        style: TextStyle(
                          color: Colors.white70,
                          height: 1.35,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: const [
                          _SecurityChip(
                            icon: Icons.lock_clock_outlined,
                            label: 'Session 30 min',
                          ),
                          _SecurityChip(
                            icon: Icons.verified_user_outlined,
                            label: 'Accès privé',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => context.go('/admin-requests'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white38),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              visualDensity: VisualDensity.compact,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.receipt_long_outlined, size: 16),
                            label: const Text('Demandes clients'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => context.go('/admin-professionals'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white38),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              visualDensity: VisualDensity.compact,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.badge_outlined, size: 16),
                            label: const Text('Professionnels'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.navy.withValues(alpha: 0.05),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Déverrouiller le BO',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _hint,
                        style: const TextStyle(
                          color: AppColors.muted,
                          height: 1.35,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Code BO',
                          hintText: 'Saisir 6 chiffres',
                          prefixIcon: Icon(Icons.lock_outline, size: 20),
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _isSubmitting ? null : _submit(),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isSubmitting ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.navy,
                            minimumSize: const Size.fromHeight(44),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          icon: _isSubmitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.lock_open_outlined, size: 18),
                          label: Text(
                            _isSubmitting
                                ? 'Vérification...'
                                : 'Accéder au back-office',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => context.go('/profile'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(44),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          icon: const Icon(Icons.arrow_back_outlined, size: 18),
                          label: const Text('Retour au profil'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
