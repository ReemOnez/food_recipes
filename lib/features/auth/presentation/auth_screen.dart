import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipes/features/auth/application/auth_provider.dart';
import 'package:recipes/features/auth/data/auth_state.dart';
import 'package:recipes/l10n/app_localizations.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.authScreen)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              ref.read(authStateProvider.notifier).login(email: 'reem', password: '123456');
            },
            child: Text('Login'),
          ),

          // --- Google Sign-In Button ---
          ElevatedButton.icon(
            icon: const Icon(Icons.login, color: Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Google’s color
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
            onPressed: ref.watch(authStateProvider).status == AuthStatus.socialLoading
                ? null
                : () {
                    ref.read(authStateProvider.notifier).loginWithGoogle();
                  },
            label: ref.watch(authStateProvider).status == AuthStatus.socialLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Sign in with Google', style: TextStyle(color: Colors.white)),
          ),

          const SizedBox(height: 12),
          // Display any Google‐specific errors
          if (ref.watch(authStateProvider).status == AuthStatus.socialError)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                // authState.provider == 'Google' and message set in socialError
                ref.watch(authStateProvider).message ?? 'Google Sign-In failed',
                style: const TextStyle(color: Colors.red),
              ),
            ),

          // Or display generic “account not verified” / “invalid credentials” errors:
          if (ref.watch(authStateProvider).status == AuthStatus.invalidCredentials)
            const Text('Invalid email or password.', style: TextStyle(color: Colors.red)),

          if (ref.watch(authStateProvider).status == AuthStatus.accountNotVerified)
            Text('Account not verified. Check code sent to ${ref.watch(authStateProvider).email}.', style: const TextStyle(color: Colors.orange)),
        ],
      ),
    );
  }
}
