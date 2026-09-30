import 'package:flutter/material.dart';

import '../core/localization/app_locale_controller.dart';
import '../core/theme/app_theme.dart';
import '../l10n/generated/app_localizations.dart';
import 'router.dart';

class LigueyProApp extends StatelessWidget {
  const LigueyProApp({required this.localeController, super.key});

  final AppLocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: localeController,
      builder: (context, child) {
        return MaterialApp.router(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          locale: localeController.locale,
          supportedLocales: AppLocaleController.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: AppTheme.light,
          routerConfig: appRouter,
        );
      },
    );
  }
}
