import 'package:flutter/material.dart';

/// Adapter to the host app's single RouterDelegate.
class AppNavigation {
  static dynamic _delegate(BuildContext context) => Router.of(context).routerDelegate;

  static void toHome(BuildContext context) {
    try { _delegate(context).goToHome(); } catch (_) {}
  }

  static void toDocs(BuildContext context, [String slug = 'docs']) {
    try { _delegate(context).goToDocs(slug); } catch (_) {}
  }

  static void toLogin(BuildContext context) {
    try { _delegate(context).goToLogin(); } catch (_) {}
  }

  static void toLegal(BuildContext context, String path) {
    try { _delegate(context).goToLegal(path); } catch (_) {}
  }
}
