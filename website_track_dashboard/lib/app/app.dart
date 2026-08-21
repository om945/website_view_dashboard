import 'package:flutter/material.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class WebsiteViewDashboardApp extends StatelessWidget {
  const WebsiteViewDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ViziAPI – Lightweight Website Analytics',
      theme: AppTheme.darkTheme,
      routerDelegate: DashboardRouterDelegate(),
      routeInformationParser: DashboardRouteInformationParser(),
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}
