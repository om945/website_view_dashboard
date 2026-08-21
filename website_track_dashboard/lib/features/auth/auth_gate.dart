import 'package:flutter/material.dart';
import '../../data/api/api_client.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/dashboard_scaffold.dart';
import '../shell/dashboard_shell.dart';
import 'login_page.dart';

enum _AuthState { loading, authenticated, unauthenticated, networkError, serverError }

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final ApiClient _api = ApiClient();
  User? _user;
  _AuthState _state = _AuthState.loading;
  String _errorMessage = '';
  bool _rateLimited = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() {
      _state = _AuthState.loading;
      _errorMessage = '';
    });
    try {
      final user = await _api.currentUser();
      if (!mounted) return;
      setState(() {
        _user = user;
        _rateLimited = false;
        _state = user != null ? _AuthState.authenticated : _AuthState.unauthenticated;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        if (e.statusCode == 0) {
          _state = _AuthState.networkError;
          _errorMessage = 'Unable to reach the API.';
        } else if (e.statusCode == 429) {
          _rateLimited = true;
          _state = _AuthState.unauthenticated;
        } else if (e.statusCode >= 500) {
          _state = _AuthState.serverError;
          _errorMessage = 'The server returned an error (${e.statusCode}). Please try again.';
        } else {
          // 401 is handled by currentUser() returning null, so any other
          // ApiException here is unexpected — treat as server error.
          _state = _AuthState.serverError;
          _errorMessage = e.message;
        }
      });
    } catch (e) {
      // Non-ApiException: network failure, timeout, CORS error, etc.
      if (!mounted) return;
      setState(() {
        _state = _AuthState.networkError;
        _errorMessage = 'Unable to reach the Website View API. Check your connection and try again.';
      });
    }
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case _AuthState.loading:
        return const Scaffold(body: LoadingState());

      case _AuthState.networkError:
        return Scaffold(
          body: ErrorState(
            message: _errorMessage,
            onRetry: _load,
          ),
        );

      case _AuthState.serverError:
        return Scaffold(
          body: ErrorState(
            message: _errorMessage,
            onRetry: _load,
          ),
        );

      case _AuthState.unauthenticated:
        return LoginPage(rateLimited: _rateLimited);

      case _AuthState.authenticated:
        return DashboardShell(
          api: _api,
          user: _user!,
          onLoggedOut: () => setState(() {
            _user = null;
            _state = _AuthState.unauthenticated;
          }),
        );
    }
  }
}
