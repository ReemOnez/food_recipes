import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipes/features/auth/application/auth_provider.dart';
import 'package:recipes/features/auth/data/auth_state.dart';

class FoodRecipesScreen extends ConsumerWidget {
  static const String routeName = 'FoodRecipesScreen';

  const FoodRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Food Recipes Screen'),
          // --- Sign-out Button ---
          ElevatedButton.icon(
            icon: const Icon(Icons.login, color: Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Google’s color
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
            onPressed: ref.watch(authStateProvider).status == AuthStatus.loading
                ? null
                : () {
                    ref.read(authStateProvider.notifier).logout();
                  },
            label: ref.watch(authStateProvider).status == AuthStatus.loading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Sign out', style: TextStyle(color: Colors.white)),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
