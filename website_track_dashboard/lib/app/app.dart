import 'package:flutter/material.dart';
import '../features/auth/auth_gate.dart';
import 'theme/app_theme.dart';

class WebsiteViewDashboardApp extends StatelessWidget {
  const WebsiteViewDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Website View API — Dashboard',
      theme: AppTheme.darkTheme,
      home: const AuthGate(),
    );
  }
}
