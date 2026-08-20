import 'package:flutter/material.dart';
import 'app/theme/app_theme.dart';
import 'features/auth/auth_gate.dart';

void main() {
  runApp(const WebsiteViewDashboardApp());
}

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
