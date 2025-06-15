import 'package:recipes/features/auth/data/auth_state.dart';

sealed class AuthHelpers {
  static String getErrorMessage(AuthState authState, String currentEmailForUnverified) {
    // Check for the generic error message first if status is initial but message exists
    // (as per your AuthState.error factory)
    if (authState.status == AuthStatus.initial && authState.message != null) {
      return authState.message!;
    }

    switch (authState.status) {
      case AuthStatus.socialError:
        return "Error with ${authState.provider ?? 'social login'}: ${authState.message ?? 'An unknown social login error occurred.'}";
      case AuthStatus.invalidCredentials:
        return "Invalid email or password.";
      case AuthStatus.accountNotVerified:
        final emailForMessage = (authState.email?.isNotEmpty ?? false) ? authState.email! : currentEmailForUnverified;
        return "Account not verified. Check code sent to $emailForMessage.";
      case AuthStatus.userAlreadyExists:
        return "An account with this email already exists.";
      case AuthStatus.tokenExpired:
        return "Your session has expired. Please log in again.";
      case AuthStatus.networkError:
        return "Network error. Please check your connection.";
      // Add other specific AuthStatus error types if they have user-facing messages
      // case AuthStatus.someOtherErrorStatus:
      //   return authState.message ?? "A specific error occurred.";
      default:
        // If there's a message field populated for any other error state, show it.
        if (authState.message != null && authState.message!.isNotEmpty) {
          return authState.message!;
        }
        return "An unexpected error occurred."; // Default fallback
    }
  }
}
