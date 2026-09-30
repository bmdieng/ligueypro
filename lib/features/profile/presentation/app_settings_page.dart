import 'package:flutter/material.dart';

import '../../../core/localization/app_locale_controller.dart';
import '../../../core/services/app_permission_service.dart';
import '../../../core/services/app_preferences_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  bool _notificationsEnabled = false;
  bool _locationEnabled = false;
  bool _autoPlayPresentation = true;
  bool _loadingPermissions = false;
  bool _backOfficeUnlocked = false;
  String? _customBackOfficeCode;
  String _backOfficeHint = 'Chargement de la sécurité BO...';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  String _buildBackOfficeHint(String code, AppLocalizations l10n) {
    if (code.isEmpty) {
      return l10n.settingsBackOfficeHintUnavailable;
    }

    return l10n.settingsBackOfficeHintActive(code.substring(0, 3));
  }

  Future<void> _loadSettings() async {
    final l10n = AppLocalizations.of(context);
    final notificationsEnabled =
        await AppPermissionService.isNotificationEnabled();
    final locationEnabled = await AppPermissionService.isLocationEnabled();
    final autoPlayPresentation =
        await AppPreferencesService.getAutoPlayPresentation();
    final customBackOfficeCode =
        await AppPreferencesService.getCustomBackOfficeAccessCode();
    final backOfficeCode =
        await AppPreferencesService.getBackOfficeAccessCode();
    final backOfficeUnlocked =
        await AppPreferencesService.isBackOfficeUnlocked();

    if (!mounted) return;

    setState(() {
      _notificationsEnabled = notificationsEnabled;
      _locationEnabled = locationEnabled;
      _autoPlayPresentation = autoPlayPresentation;
      _customBackOfficeCode = customBackOfficeCode;
      _backOfficeHint = _buildBackOfficeHint(backOfficeCode, l10n);
      _backOfficeUnlocked = backOfficeUnlocked;
      _loadingPermissions = false;
    });
  }

  Future<void> _handleNotificationToggle(bool value) async {
    final l10n = AppLocalizations.of(context);

    if (value) {
      final granted =
          await AppPermissionService.requestNotificationPermission();
      if (!mounted) return;
      setState(() => _notificationsEnabled = granted);
      if (!granted) {
        _showSettingsHint(l10n.settingsNotificationsDenied);
      }
      return;
    }

    await AppPermissionService.openSystemSettings();
    if (!mounted) return;
    _showSettingsHint(l10n.settingsNotificationsDisableInSystem);
    await _loadSettings();
  }

  Future<void> _handleLocationToggle(bool value) async {
    final l10n = AppLocalizations.of(context);

    if (value) {
      final granted = await AppPermissionService.requestLocationPermission();
      if (!mounted) return;
      setState(() => _locationEnabled = granted);
      if (!granted) {
        _showSettingsHint(l10n.settingsLocationDenied);
      }
      return;
    }

    await AppPermissionService.openSystemSettings();
    if (!mounted) return;
    _showSettingsHint(l10n.settingsLocationDisableInSystem);
    await _loadSettings();
  }

  Future<void> _handleAutoPlayToggle(bool value) async {
    setState(() => _autoPlayPresentation = value);
    await AppPreferencesService.setAutoPlayPresentation(value);
  }

  Future<void> _handleLanguageSelection() async {
    final localeController = AppLocaleScope.of(context);
    final locale = await showModalBottomSheet<Locale>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final l10n = AppLocalizations.of(context);

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLocaleController.supportedLocales.map((locale) {
              final isSelected =
                  locale.languageCode == localeController.locale.languageCode;
              return ListTile(
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                ),
                title: Text(AppLocaleController.nativeLabel(locale)),
                subtitle: Text(
                  locale.languageCode == 'fr'
                      ? l10n.settingsLanguageFrenchInterface
                      : l10n.settingsLanguageEnglishInterface,
                ),
                onTap: () => Navigator.of(context).pop(locale),
              );
            }).toList(),
          ),
        );
      },
    );

    if (locale == null || !mounted) {
      return;
    }

    await localeController.setLocale(locale);
    if (!mounted) {
      return;
    }

    await _loadSettings();
    if (!mounted) {
      return;
    }

    final l10n = AppLocalizations.of(context);
    _showSettingsHint(l10n.settingsLanguageUpdated);
  }

  Future<void> _showBackOfficeCodeDialog() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: _customBackOfficeCode ?? '');
    var isSaving = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: Text(
                l10n.settingsBackOfficeDialogTitle,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsBackOfficeDialogDescription,
                    style: const TextStyle(color: AppColors.muted, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.settingsBackOfficeNewCode,
                      hintText: l10n.settingsSixDigits,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed:
                      isSaving ? null : () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.commonCancel),
                ),
                FilledButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final code = controller.text.trim();
                          if (code.length != 6 || int.tryParse(code) == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  l10n.settingsBackOfficeCodeInvalid,
                                ),
                              ),
                            );
                            return;
                          }

                          setLocalState(() => isSaving = true);
                          try {
                            await AppPreferencesService
                                .setCustomBackOfficeAccessCode(code);
                            if (!mounted || !dialogContext.mounted) return;
                            Navigator.of(dialogContext).pop();
                            await _loadSettings();
                            _showSettingsHint(
                              l10n.settingsBackOfficeCodeSaved,
                            );
                          } catch (error) {
                            setLocalState(() => isSaving = false);
                            if (!context.mounted) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );
                          }
                        },
                  child: Text(l10n.commonSave),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _lockBackOfficeNow() async {
    final l10n = AppLocalizations.of(context);

    await AppPreferencesService.lockBackOffice();
    if (!mounted) return;
    await _loadSettings();
    _showSettingsHint(l10n.settingsBackOfficeLockedNow);
  }

  void _showSettingsHint(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeController = AppLocaleScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.settingsPreferences,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.settingsSubtitle,
              style: const TextStyle(color: AppColors.muted),
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
                    title: Text(l10n.commonNotifications),
                    subtitle: Text(l10n.settingsNotificationsSubtitle),
                    secondary: const Icon(Icons.notifications_active_outlined),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _locationEnabled,
                    onChanged:
                        _loadingPermissions ? null : _handleLocationToggle,
                    title: Text(l10n.commonLocation),
                    subtitle: Text(l10n.settingsLocationSubtitle),
                    secondary: const Icon(Icons.location_on_outlined),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _autoPlayPresentation,
                    onChanged: _handleAutoPlayToggle,
                    title: Text(l10n.settingsVideoAutoplay),
                    subtitle: Text(l10n.settingsVideoAutoplaySubtitle),
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
                    leading: const Icon(Icons.language_outlined),
                    title: Text(l10n.commonLanguage),
                    subtitle: Text(
                      AppLocaleController.nativeLabel(localeController.locale),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _handleLanguageSelection,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(l10n.commonVersion),
                    subtitle: const Text('LigueyPro 2.0.0'),
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
