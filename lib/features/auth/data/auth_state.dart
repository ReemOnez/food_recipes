import 'package:recipes/features/auth/data/user_model.dart';

/// All possible high‐level auth statuses.
enum AuthStatus {
  initial,
  loading,
  authenticated,
  loggedOut,
  tokenExpired,
  accountNotVerified,
  userAlreadyExists,
  invalidCredentials,
  networkError,
  codeResent,
  socialLoading,
  socialSuccess,
  socialError,
}

/// A single AuthState that carries:
///  • an AuthStatus, plus
///  • optional fields (user / message / email / provider) as needed.
class AuthState {
  final AuthStatus status;

  /// Populated when status == authenticated OR socialSuccess
  final UserModel? user;

  /// A human‐readable message (e.g. error text, info text)
  final String? message;

  /// Used for “account not verified” or “code resent” (knowing which email).
  final String? email;

  /// Which social provider (“Google”, “Facebook”, “Apple”) when status is socialLoading/socialError/socialSuccess.
  final String? provider;

  const AuthState._({
    required this.status,
    this.user,
    this.message,
    this.email,
    this.provider,
  });

  // ----------------------------------------------------------
  // 1) Factory constructors for each meaningful AuthStatus:
  // ----------------------------------------------------------

  /// 1.1 Initial state (no action taken yet)
  factory AuthState.initial() => const AuthState._(status: AuthStatus.initial);

  /// 1.2 Generic loading state (any network call in progress)
  factory AuthState.loading() => const AuthState._(status: AuthStatus.loading);

  /// 1.3 Fully authenticated (normal login or social success)
  factory AuthState.authenticated(UserModel user) => AuthState._(
    status: AuthStatus.authenticated,
    user: user,
  );

  /// 1.4 Explicitly logged out
  factory AuthState.loggedOut() => const AuthState._(status: AuthStatus.loggedOut);

  /// 1.5 Session/token expired → force re-login
  factory AuthState.tokenExpired() => const AuthState._(status: AuthStatus.tokenExpired);

  /// 1.6 Account exists but is not verified yet (e.g. user must enter code)
  factory AuthState.accountNotVerified(String email) => AuthState._(
    status: AuthStatus.accountNotVerified,
    email: email,
  );

  /// 1.7 Attempt to register but user already exists
  factory AuthState.userAlreadyExists() => const AuthState._(status: AuthStatus.userAlreadyExists);

  /// 1.8 Attempt to login with bad email/password
  factory AuthState.invalidCredentials() => const AuthState._(status: AuthStatus.invalidCredentials);

  /// 1.9 A generic network error (e.g. no internet)
  factory AuthState.networkError() => const AuthState._(status: AuthStatus.networkError);

  /// 1.10 Verification code has been resent
  factory AuthState.codeResent(String email) => AuthState._(
    status: AuthStatus.codeResent,
    email: email,
  );

  /// 1.11 Starting a social login (e.g. “Google”, “Facebook”, “Apple”)
  factory AuthState.socialLoading(String provider) => AuthState._(
    status: AuthStatus.socialLoading,
    provider: provider,
  );

  /// 1.12 Social login succeeded
  factory AuthState.socialSuccess(String provider, UserModel user) => AuthState._(
    status: AuthStatus.socialSuccess,
    provider: provider,
    user: user,
  );

  /// 1.13 Social login failed
  factory AuthState.socialError(String provider, String message) => AuthState._(
    status: AuthStatus.socialError,
    provider: provider,
    message: message,
  );

  /// 1.14 A catch‐all error with a message (if none of the above fits)
  factory AuthState.error(String message) => AuthState._(
    status: AuthStatus.initial,
    message: message,
  );
}