import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/network/firebase_bootstrap.dart';
import 'core/services/request_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseReady = await FirebaseBootstrap.initialize();
  debugPrint('Firebase ready: $firebaseReady');
  await RequestNotificationService.initialize();
  runApp(const AppBootstrapper());
}

class AppBootstrapper extends StatefulWidget {
  const AppBootstrapper({super.key});

  @override
  State<AppBootstrapper> createState() => _AppBootstrapperState();
}

class _AppBootstrapperState extends State<AppBootstrapper> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    unawaited(
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() => _showSplash = false);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const ProviderScope(
        child: _LaunchSplash(),
      );
    }

    return const ProviderScope(child: LigueyProApp());
  }
}

class _LaunchSplash extends StatelessWidget {
  const _LaunchSplash();

  static const Color navy = Color(0xFF031E3C);
  static const Color navyLight = Color(0xFF0B3157);
  static const Color gold = Color(0xFFAC6D1D);
  static const Color goldLight = Color(0xFFBB8547);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: navy,
      ),
      home: Scaffold(
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
                      // =====================================================
                      // LOGO : STATIQUE
                      // =====================================================
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

                      // =====================================================
                      // LIGNE DÉCORATIVE : STATIQUE
                      // =====================================================
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

                      const Text(
                        'VOS SERVICES,',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.4,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'PLUS PROCHES · PLUS SIMPLES',
                        style: TextStyle(
                          color: Color(0xFFD8B57A),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.4,
                        ),
                      ),

                      const SizedBox(height: 38),

                      // =====================================================
                      // SEULE ANIMATION : BARRE DE CHARGEMENT
                      // =====================================================
                      const _GoldProgressBar(),
                    ],
                  ),
                ),

                // =====================================================
                // MENTION DE COPYRIGHT : STATIQUE, EN BAS DE L'ÉCRAN
                // =====================================================
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 24,
                  child: Center(
                    child: Text(
                      '© 2026 LigueyPro 2.0. Tous droits réservés.',
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