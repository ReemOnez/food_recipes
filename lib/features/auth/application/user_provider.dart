import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipes/features/auth/application/auth_provider.dart';
import 'package:recipes/features/auth/data/auth_state.dart';
import 'package:recipes/features/auth/data/user_model.dart';

final userProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return switch (authState.status) {
    AuthStatus.authenticated => authState.user,
    AuthStatus.socialSuccess => authState.user,
    // For all other states (LoggedOut, Loading, Error, etc.), there's no user
    _ => null,
  };
});
