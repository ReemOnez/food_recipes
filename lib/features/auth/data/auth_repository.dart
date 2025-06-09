import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipes/core/local_storage/shared_preferences.dart';
import 'package:recipes/core/network/api_client.dart';
import 'package:recipes/core/network/api_result.dart';
import 'package:recipes/core/network/network_exceptions.dart';
import 'package:recipes/core/network/urls.dart';
import 'package:recipes/features/auth/data/user_model.dart';
import 'package:recipes/helpers/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthRepository {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      // add additional scopes if needed, e.g. 'profile'
    ],
    // Correctly initialize with serverClientId
    serverClientId: '378602164412-vrc4jaanhegm051vldbvb5kiitq6v41r.apps.googleusercontent.com',
  );

  AuthRepository({required this.apiClient, required this.prefs});

  /// Performs email/password login. On success, caches user data in SharedPreferences.
  Future<UserModel> login({required String email, required String password}) async {
    try {
      final ApiResult<UserModel> result = await apiClient.post<UserModel>(
        Urls.loginUrl,
        data: {'username': email, 'password': password, "expiresInMins": 10},
        decoder: (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );

      if (result.isSuccess && result.data != null) {
        final user = result.data!;
        await _cacheUser(user);
        return user;
      } else {
        throw Exception(result.errorMessage);
      }
    } catch (e) {
      final err = NetworkException.from(e);
      throw Exception(err.message);
    }
  }

  /// Clears cached user and token from SharedPreferences.
  Future<void> logout(String provider) async {
    if (provider == AppConstants.googleProvider) {
      await _googleSignIn.signOut();
      if (kDebugMode) {
        print("Successfully signed out from Google.");
      }
    }
    await prefs.remove(AppConstants.userId);
    await prefs.remove(AppConstants.userEmail);
    await prefs.remove(AppConstants.userName);
    await prefs.remove(AppConstants.token);

    /// If your backend supports a logout endpoint, you could also call:
    // try {
    //   await apiClient.post(Urls.logout);
    // } catch (_) { /* ignore */ }
  }

  /// Sends a verification SMS or code to the given email/phone.
  /// The `flow` parameter indicates whether this is a login or registration flow.
  Future<void> sendVerificationSms({
    required String dialCode,
    required String phoneNumber,
    required String authenticationFlowType,
    required String deviceIdentifier,
  }) async {
    try {
      await apiClient.post<void>(
        '/auth/send_sms',
        data: {
          'dialCode': dialCode,
          'phoneNumber': phoneNumber,
          'authenticationFlowType': authenticationFlowType,
          'deviceIdentifier': deviceIdentifier,
        },
        decoder: (_) {},
      );
    } catch (e) {
      final err = NetworkException.from(e);
      throw Exception(err.message);
    }
  }

  /// Resends a verification code to the given email/phone.
  Future<void> resendVerificationCode(String emailOrPhone) async {
    try {
      await apiClient.post<void>('/auth/resend_code', data: {'emailOrPhone': emailOrPhone}, decoder: (_) => null);
    } catch (e) {
      final err = NetworkException.from(e);
      throw Exception(err.message);
    }
  }

  /// Performs Google sign-in. On success, caches user data in SharedPreferences.
  //   /// ------------------------------
  //   /// NEW: Google Sign-In Flow
  //   /// ------------------------------
  //   ///
  //   /// 1. Initiate Google Sign-In on the client (this pops up the Google account chooser).
  //   /// 2. Once we get a GoogleSignInAccount, call `authentication` to get an `idToken`.
  //   /// 3. Send that `idToken` to your backend via POST /auth/google_login.
  //   /// 4. Backend verifies the token, returns user info + JWT.
  //   /// 5. Cache the returned user info + token in SharedPreferences.

  Future<UserModel> loginWithGoogle() async {
    try {
      /// 1. Sign out the current user (if any) to clear the previous selection
      await _googleSignIn.signOut();

      /// 2. Now, signIn() will show the account chooser dialog
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user aborted/cancelled the sign-in flow
        throw Exception('Google Sign-In aborted after forcing chooser.');
      }

      /// 3. Obtain the auth details (ID token) from the Google user
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken != null) {
        if (kDebugMode) {
          print('Successfully signed in with new/chosen account. ID Token: $idToken');
        }

        await Future.delayed(const Duration(seconds: 3));
        final user = UserModel(
          id: googleUser.id,
          email: googleUser.email,
          name: googleUser.displayName ?? 'aliiiiii',
          image: googleUser.photoUrl ?? 'aliiiiii',
          token: googleAuth.accessToken ?? 'aliiiiii',
        );

        await _cacheUser(user);
        return user;

        /// 4. Send the idToken to your backend
        // final ApiResult<UserModel> result = await apiClient.post<UserModel>(
        //   '/auth/google_login',
        //   data: {'idToken': idToken},
        //   decoder: (json) => UserModel.fromJson(json as Map<String, dynamic>),
        // );
        // if (result.isSuccess && result.data != null) {
        //   final user = result.data!;
        //   await _cacheUser(user);
        //   return user;
        // } else {
        //   throw Exception(result.errorMessage);
        // }
      } else {
        throw Exception('Failed to get ID Token after forcing chooser.');
      }
    } catch (e) {
      // e could be a GoogleSignInException, DioError, or our own Exception
      if (kDebugMode) {
        print('Error during Google Sign-In with forced chooser: $e');
      }
      throw Exception(NetworkException.from(e).message);
    }
  }

  /// Performs Facebook sign-in. On success, caches user data in SharedPreferences.
  Future<UserModel> loginWithFacebook() async {
    try {
      final ApiResult<UserModel> result = await apiClient.post<UserModel>(
        '/auth/facebook_login',
        data: {}, // Include any necessary tokens/credentials here
        decoder: (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );

      if (result.isSuccess && result.data != null) {
        final user = result.data!;
        await _cacheUser(user);
        return user;
      } else {
        throw Exception(result.errorMessage);
      }
    } catch (e) {
      final err = NetworkException.from(e);
      throw Exception(err.message);
    }
  }

  /// Performs Apple sign-in. On success, caches user data in SharedPreferences.
  Future<UserModel> loginWithApple() async {
    try {
      final ApiResult<UserModel> result = await apiClient.post<UserModel>(
        '/auth/apple_login',
        data: {}, // Include any necessary tokens/credentials here
        decoder: (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );

      if (result.isSuccess && result.data != null) {
        final user = result.data!;
        await _cacheUser(user);
        return user;
      } else {
        throw Exception(result.errorMessage);
      }
    } catch (e) {
      final err = NetworkException.from(e);
      throw Exception(err.message);
    }
  }

  /// Helper to cache user fields in SharedPreferences.
  Future<void> _cacheUser(UserModel user) async {
    await prefs.setString(AppConstants.userId, user.id);
    await prefs.setString(AppConstants.userEmail, user.email);
    await prefs.setString(AppConstants.userName, user.name);
    await prefs.setString(AppConstants.token, user.token);
  }

  Future<UserModel?> getCachedUser() async {
    final userId = prefs.getString(AppConstants.userId);
    final userName = prefs.getString(AppConstants.userName);
    final userEmail = prefs.getString(AppConstants.userEmail);
    final token = prefs.getString(AppConstants.token);

    if (userId != null && userName != null && userEmail != null && token != null) {
      return UserModel(id: userId, name: userName, email: userEmail, token: token, image: '');
    }
    return null;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(apiClient: ref.watch(apiClientProvider), prefs: ref.watch(sharedPreferencesProvider));
});
