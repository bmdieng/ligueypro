import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'router.dart';

class LigueyProApp extends StatelessWidget {
  const LigueyProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LigueyPro 2.0',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}