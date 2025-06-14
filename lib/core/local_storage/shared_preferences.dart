import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipes/helpers/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Now a simple Provider, as it will be overridden with an actual instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  // This will only be called if not overridden, which is an error in your setup.
  // Or, if you want it to be usable without an override in some contexts (e.g., tests),
  // you could throw or provide a non-functional default.
  // But given your main(), overriding is expected.
  throw StateError('SharedPreferencesProvider was not overridden. Ensure SharedPreferences is provided in ProviderScope overrides.');
});

// Your extension remains the same
extension SharedData on SharedPreferences {
  String get getLang => getString(AppConstants.languageKEY) ?? 'ar'; // Default 'ar'

  Future<bool> saveLang(String lang) async => setString(AppConstants.languageKEY, lang);

  /// Token
  String? get getToken => getString(AppConstants.tokenKEY);

  Future<bool> saveToken(String token) async => setString(AppConstants.tokenKEY, token);

  Future<bool> clearToken() async => remove(AppConstants.tokenKEY);

  // ... rest of your extension methods
  String? get getUserID => getString('userID');

  Future<bool> saveUserID(String userID) async => setString('userID', userID);

  Future<bool> clearUserID() async => remove("userID");

  bool get isNotificationPermissionTaken => getBool('notificationPermissionTaken') ?? false;

  Future<bool> saveNotificationPermission(bool value) async => setBool('notificationPermissionTaken', value);

  bool get isPermissionDenied => getBool('permissionDenied') ?? false;

  Future<bool> savePermissionDeniedBefore(bool value) async => setBool('permissionDenied', value);

  Future<bool> clearPermissionDeniedBefore() async => remove("permissionDenied");
}
