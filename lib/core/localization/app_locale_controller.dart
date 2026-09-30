import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../services/app_preferences_service.dart';

class AppLocaleController extends ChangeNotifier {
  AppLocaleController(Locale initialLocale)
      : _locale = _normalize(initialLocale);

  static const Locale french = Locale('fr');
  static const Locale english = Locale('en');
  static final List<Locale> supportedLocales =
      AppLocalizations.supportedLocales;

  Locale _locale;

  Locale get locale => _locale;

  static Locale _normalize(Locale locale) {
    return supportedLocales.firstWhere(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
      orElse: () => french,
    );
  }

  static Locale fromLanguageCode(String? languageCode) {
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => french,
    );
  }

  static String nativeLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
      default:
        return 'Français';
    }
  }

  Future<void> setLocale(Locale locale) async {
    final normalizedLocale = _normalize(locale);
    if (_locale == normalizedLocale) {
      return;
    }

    _locale = normalizedLocale;
    notifyListeners();
    await AppPreferencesService.setAppLanguageCode(
        normalizedLocale.languageCode);
  }
}

class AppLocaleScope extends InheritedNotifier<AppLocaleController> {
  const AppLocaleScope({
    required AppLocaleController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static AppLocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    assert(scope != null, 'AppLocaleScope is missing in the widget tree.');
    return scope!.notifier!;
  }
}
