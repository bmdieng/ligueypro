import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/localization/app_locale_controller.dart';
import 'core/network/firebase_bootstrap.dart';
import 'core/services/app_preferences_service.dart';
import 'core/services/request_notification_service.dart';
import 'l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedLanguageCode = await AppPreferencesService.getAppLanguageCode();
  final localeController = AppLocaleController(
    AppLocaleController.fromLanguageCode(savedLanguageCode),
  );
  runApp(AppBootstrapper(localeController: localeController));
}

class AppBootstrapper extends StatefulWidget {
  const AppBootstrapper({required this.localeController, super.key});

  final AppLocaleController localeController;

  @override
  State<AppBootstrapper> createState() => _AppBootstrapperState();
}

class _AppBootstrapperState extends State<AppBootstrapper> {
  bool _showSplash = true;
  bool _bootstrapInProgress = false;

  @override
  void initState() {
    super.initState();
    unawaited(_bootstrapApp());
  }

  Future<void> _bootstrapApp() async {
    if (_bootstrapInProgress) {
      return;
    }

    _bootstrapInProgress = true;

    unawaited(
      _initializeServices()
          .timeout(const Duration(seconds: 10))
          .catchError((error, stackTrace) {
        debugPrint('Bootstrap services timed out or failed: $error');
        if (stackTrace is StackTrace) {
          debugPrintStack(stackTrace: stackTrace);
        }
      }),
    );

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) {
      return;
    }
    setState(() => _showSplash = false);
  }

  Future<void> _initializeServices() async {
    final firebaseReady = await FirebaseBootstrap.initialize();
    debugPrint('Firebase ready: $firebaseReady');

    if (firebaseReady) {
      await RequestNotificationService.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: AppLocaleScope(
        controller: widget.localeController,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _showSplash
              ? const _LaunchSplash(key: ValueKey('splash'))
              : LigueyProApp(
                  key: const ValueKey('app'),
                  localeController: widget.localeController,
                ),
        ),
      ),
    );
  }
}

class _LaunchSplash extends StatelessWidget {
  const _LaunchSplash({super.key});

  static const Color navy = Color(0xFF031E3C);
  static const Color navyLight = Color(0xFF0B3157);
  static const Color gold = Color(0xFFAC6D1D);
  static const Color goldLight = Color(0xFFBB8547);

  @override
  Widget build(BuildContext context) {
    final localeController = AppLocaleScope.of(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: localeController.locale,
      supportedLocales: AppLocaleController.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: navy,
      ),
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);

          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    navy,
                    Color(0xFF06264A),
                    navyLight,
                  ],
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 330,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: gold.withValues(alpha: 0.20),
                                  blurRadius: 45,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 18),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.22),
                                  blurRadius: 30,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.asset(
                                'assets/ligueyPro2.0_.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 42),
                          Container(
                            width: 90,
                            height: 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  gold,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            l10n.splashHeadline,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.4,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            l10n.splashTagline,
                            style: const TextStyle(
                              color: Color(0xFFD8B57A),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(height: 38),
                          const _GoldProgressBar(),
                          const SizedBox(height: 14),
                          Text(
                            'Démarrage sécurisé en cours…',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.72),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 24,
                      child: Center(
                        child: Text(
                          l10n.splashCopyright,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.45),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GoldProgressBar extends StatelessWidget {
  const _GoldProgressBar();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ),
      duration: const Duration(milliseconds: 1300),
      curve: Curves.easeInOutCubic,
      builder: (context, value, child) {
        return Container(
          width: 180,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF8B5415),
                      Color(0xFFAC6D1D),
                      Color(0xFFD4A65C),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFAC6D1D).withValues(alpha: 0.55),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
