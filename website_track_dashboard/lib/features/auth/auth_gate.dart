import 'package:flutter/material.dart';
import '../../data/api/api_client.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/dashboard_scaffold.dart';
import '../shell/dashboard_shell.dart';
import 'login_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final ApiClient _api = ApiClient();
  User? _user;
  Object? _error;
  bool _loading = true;
  bool _rateLimited = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final user = await _api.currentUser();
      if (mounted) {
        setState(() {
          _user = user;
          _loading = false;
          _rateLimited = false;
        });
      }
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (error.statusCode == 429) {
          _user = null;
          _rateLimited = true;
          _error = null;
        } else {
          _error = error;
        }
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error;
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: LoadingState());
    }

    if (_error != null) {
      return Scaffold(
        body: ErrorState(
          message: 'Unable to reach the Website View API.',
          onRetry: () => setState(() {
            _loading = true;
            _error = null;
            _load();
          }),
        ),
      );
    }

    if (_user == null) {
      return LoginPage(rateLimited: _rateLimited);
    }

    return DashboardShell(
      api: _api,
      user: _user!,
      onLoggedOut: () => setState(() => _user = null),
    );
  }
}
