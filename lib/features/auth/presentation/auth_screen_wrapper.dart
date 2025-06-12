import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipes/features/auth/application/auth_provider.dart';
import 'package:recipes/features/auth/data/auth_state.dart';
import 'package:recipes/features/auth/presentation/auth_screen.dart';
import 'package:recipes/features/bottom_Navigation_bar/presentation/bottom_navigation_bar_screen.dart';
import 'package:recipes/features/food_recipes/presentation/food_recipes_screen.dart';

class AuthScreenWrapper extends ConsumerWidget {
  static const String routeName = 'AuthScreenWrapper';
  const AuthScreenWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    switch (authState.status) {
      case AuthStatus.initial:
      case AuthStatus.loading:
      case AuthStatus.socialLoading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));

      case AuthStatus.authenticated:
      case AuthStatus.socialSuccess:
        final user = authState.user!;
        return BottomNavigationScreen();

      case AuthStatus.loggedOut:
        return const AuthScreen();

      case AuthStatus.tokenExpired:
        return const Scaffold(body: Center(child: Text('Session expired. Please log in again.')));

      case AuthStatus.accountNotVerified:
        return Scaffold(body: Center(child: Text('Account not verified. Check code sent to ${authState.email}.')));

      case AuthStatus.userAlreadyExists:
        return const Scaffold(body: Center(child: Text('User already exists.')));

      case AuthStatus.invalidCredentials:
        return const AuthScreen(); // The LoginPage itself shows the error

      case AuthStatus.networkError:
        return const Scaffold(body: Center(child: Text('Network error.')));

      case AuthStatus.codeResent:
        return Scaffold(body: Center(child: Text('Verification code resent to ${authState.email}.')));

      case AuthStatus.socialError:
        return Scaffold(
          body: Center(child: Text('Google Sign-In failed:\n${authState.message}', textAlign: TextAlign.center)),
        );
    }
  }
}
