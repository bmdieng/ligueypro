import 'package:flutter/material.dart';

import '../../../core/services/app_permission_service.dart';
import '../../../core/services/app_preferences_service.dart';
import '../../../core/theme/app_colors.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  bool _notificationsEnabled = false;
  bool _locationEnabled = false;
  bool _autoPlayPresentation = true;
  bool _loadingPermissions = true;
  bool _backOfficeUnlocked = false;
  String? _customBackOfficeCode;
  String _backOfficeHint = 'Chargement de la sécurité BO...';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final notificationsEnabled =
        await AppPermissionService.isNotificationEnabled();
    final locationEnabled = await AppPermissionService.isLocationEnabled();
    final autoPlayPresentation =
        await AppPreferencesService.getAutoPlayPresentation();
    final customBackOfficeCode =
        await AppPreferencesService.getCustomBackOfficeAccessCode();
    final backOfficeHint =
        await AppPreferencesService.getBackOfficeAccessHint();
    final backOfficeUnlocked =
        await AppPreferencesService.isBackOfficeUnlocked();

    if (!mounted) return;

    setState(() {
      _notificationsEnabled = notificationsEnabled;
      _locationEnabled = locationEnabled;
      _autoPlayPresentation = autoPlayPresentation;
      _customBackOfficeCode = customBackOfficeCode;
      _backOfficeHint = backOfficeHint;
      _backOfficeUnlocked = backOfficeUnlocked;
      _loadingPermissions = false;
    });
  }

  Future<void> _handleNotificationToggle(bool value) async {
    if (value) {
      final granted =
          await AppPermissionService.requestNotificationPermission();
      if (!mounted) return;
      setState(() => _notificationsEnabled = granted);
      if (!granted) {
        _showSettingsHint(
            'Les notifications sont refusées. Autorisez-les dans les réglages système.');
      }
      return;
    }

    await AppPermissionService.openSystemSettings();
    if (!mounted) return;
    _showSettingsHint(
        'Désactivez les notifications dans les réglages système si nécessaire.');
    await _loadSettings();
  }

  Future<void> _handleLocationToggle(bool value) async {
    if (value) {
      final granted = await AppPermissionService.requestLocationPermission();
      if (!mounted) return;
      setState(() => _locationEnabled = granted);
      if (!granted) {
        _showSettingsHint(
            'La localisation est refusée. Autorisez-la dans les réglages système.');
      }
      return;
    }

    await AppPermissionService.openSystemSettings();
    if (!mounted) return;
    _showSettingsHint(
        'Désactivez la localisation dans les réglages système si nécessaire.');
    await _loadSettings();
  }

  Future<void> _handleAutoPlayToggle(bool value) async {
    setState(() => _autoPlayPresentation = value);
    await AppPreferencesService.setAutoPlayPresentation(value);
  }

  Future<void> _showBackOfficeCodeDialog() async {
    final controller = TextEditingController(text: _customBackOfficeCode ?? '');
    var isSaving = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: const Text('Code du back-office'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Définissez un code à 4 chiffres pour protéger l’accès au BO.',
                    style: TextStyle(color: AppColors.muted, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Nouveau code',
                      hintText: '4 chiffres',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed:
                      isSaving ? null : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Annuler'),
                ),
                FilledButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final code = controller.text.trim();
                          if (code.length != 4 || int.tryParse(code) == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Le code BO doit contenir exactement 4 chiffres.',
                                ),
                              ),
                            );
                            return;
                          }

                          setLocalState(() => isSaving = true);
                          await AppPreferencesService
                              .setCustomBackOfficeAccessCode(code);
                          if (!mounted || !dialogContext.mounted) return;
                          Navigator.of(dialogContext).pop();
                          await _loadSettings();
                          _showSettingsHint(
                            'Code BO personnalisé enregistré. La session a été reverrouillée.',
                          );
                        },
                  child: const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _resetBackOfficeCode() async {
    await AppPreferencesService.clearCustomBackOfficeAccessCode();
    if (!mounted) return;
    await _loadSettings();
    _showSettingsHint(
      'Code BO réinitialisé. Le code par défaut est réappliqué et la session est verrouillée.',
    );
  }

  Future<void> _lockBackOfficeNow() async {
    await AppPreferencesService.lockBackOffice();
    if (!mounted) return;
    await _loadSettings();
    _showSettingsHint('Back-office verrouillé immédiatement.');
  }

  void _showSettingsHint(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres de l’application')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Préférences',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Gérez les réglages principaux de LigueyPro.',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 20),
            if (_loadingPermissions)
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: LinearProgressIndicator(),
              ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _notificationsEnabled,
                    onChanged:
                        _loadingPermissions ? null : _handleNotificationToggle,
                    title: const Text('Notifications'),
                    subtitle: const Text(
                        'Recevoir les alertes sur les nouvelles demandes.'),
                    secondary: const Icon(Icons.notifications_active_outlined),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _locationEnabled,
                    onChanged:
                        _loadingPermissions ? null : _handleLocationToggle,
                    title: const Text('Localisation'),
                    subtitle: const Text(
                        'Utiliser votre position pour faciliter les demandes.'),
                    secondary: const Icon(Icons.location_on_outlined),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _autoPlayPresentation,
                    onChanged: _handleAutoPlayToggle,
                    title: const Text('Lecture automatique des vidéos'),
                    subtitle: const Text(
                        'Lancer automatiquement la vidéo de présentation.'),
                    secondary: const Icon(Icons.play_circle_outline),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings_outlined),
                    title: const Text('Sécurité du back-office'),
                    subtitle: Text(_backOfficeHint),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: (_backOfficeUnlocked
                                ? AppColors.success
                                : AppColors.navy)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _backOfficeUnlocked ? 'Ouvert' : 'Verrouillé',
                        style: TextStyle(
                          color: _backOfficeUnlocked
                              ? AppColors.success
                              : AppColors.navy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.pin_outlined),
                    title: const Text('Modifier le code BO'),
                    subtitle: Text(
                      _customBackOfficeCode == null
                          ? 'Utilise le code par défaut lié au professionnel courant'
                          : 'Code personnalisé actif',
                    ),
                    onTap: _showBackOfficeCodeDialog,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_reset_outlined),
                    title: const Text('Réinitialiser le code BO'),
                    subtitle: const Text(
                      'Revenir au code par défaut ou au code démo',
                    ),
                    onTap: _customBackOfficeCode == null
                        ? null
                        : _resetBackOfficeCode,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('Verrouiller le back-office'),
                    subtitle: const Text(
                      'Couper immédiatement la session BO en cours',
                    ),
                    onTap: _backOfficeUnlocked ? _lockBackOfficeNow : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.language_outlined),
                    title: Text('Langue'),
                    subtitle: Text('Français'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Version'),
                    subtitle: Text('LigueyPro 2.0.0'),
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
