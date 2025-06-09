import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipes/features/auth/data/auth_repository.dart';
import 'package:recipes/features/auth/data/auth_state.dart';
import 'package:recipes/helpers/app_constants.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  final AuthRepository repository;

  AuthNotifier({required this.ref, required this.repository}) : super(AuthState.initial()) {
    _checkCurrentUser();
  }

  /// 2.1 On startup, check if there is already a cached user.
  Future<void> _checkCurrentUser() async {
    state = AuthState.loading();
    try {
      final cachedUser = await repository.getCachedUser();
      if (cachedUser != null) {
        // Already authenticated
        state = AuthState.authenticated(cachedUser);
      } else {
        // No user stored → not logged in
        state = AuthState.loggedOut();
      }
    } catch (e) {
      // If reading prefs fails, treat as networkError or loggedOut
      state = AuthState.networkError();
    }
  }

  /// 2.2 Normal email/password login
  Future<void> login({required String email, required String password}) async {
    state = AuthState.loading();
    try {
      final user = await repository.login(email: email, password: password);
      state = AuthState.authenticated(user);
    } catch (e) {
      final errorMessage = e.toString();

      // Examine errorMessage or exception type to pick a more specific status:
      if (errorMessage.contains('token expired')) {
        state = AuthState.tokenExpired();
      } else if (errorMessage.contains('not verified')) {
        state = AuthState.accountNotVerified(email);
      } else if (errorMessage.contains('already exists')) {
        state = AuthState.userAlreadyExists();
      } else if (errorMessage.contains('invalid credentials')) {
        state = AuthState.invalidCredentials();
      } else if (errorMessage.contains('network')) {
        state = AuthState.networkError();
      } else {
        // Fallback to generic error
        state = AuthState.error(errorMessage);
      }
    }
  }

  /// 2.3 Logout: clear cache in repository + update state
  Future<void> logout() async {
    state = AuthState.loading();
    try {
      /// find a way to know from which provider i'm logging out, currently empty
      await repository.logout('');
      state = AuthState.loggedOut();
    } catch (e) {
      if (kDebugMode) {
        print("Error during app logout process: $e");
      }
      state = AuthState.error(e.toString());
    }
  }

  /// 2.4 Resend verification code
  Future<void> resendCode(String email) async {
    state = AuthState.loading();
    try {
      await repository.resendVerificationCode(email);
      state = AuthState.codeResent(email);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  // ---------------------------
  // 2.5 Social logins: Google, Facebook, Apple
  // ---------------------------

  Future<void> loginWithGoogle() async {
    state = AuthState.socialLoading(AppConstants.googleProvider);

    try {
      final userModel = await repository.loginWithGoogle();
      state = AuthState.socialSuccess(AppConstants.googleProvider, userModel);
    } catch (e) {
      state = AuthState.socialError(AppConstants.googleProvider, e.toString());
    }
  }

  Future<void> loginWithFacebook() async {
    state = AuthState.socialLoading(AppConstants.faceBookProvider);

    try {
      final user = await repository.loginWithFacebook();
      state = AuthState.socialSuccess(AppConstants.faceBookProvider, user);
    } catch (e) {
      state = AuthState.socialError(AppConstants.faceBookProvider, e.toString());
    }
  }

  Future<void> loginWithApple() async {
    state = AuthState.socialLoading(AppConstants.appleProvider);

    try {
      final user = await repository.loginWithApple();
      state = AuthState.socialSuccess(AppConstants.appleProvider, user);
    } catch (e) {
      state = AuthState.socialError(AppConstants.appleProvider, e.toString());
    }
  }
}

/// 3) Expose the AuthNotifier via StateNotifierProvider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref: ref, repository: ref.watch(authRepositoryProvider));
});
