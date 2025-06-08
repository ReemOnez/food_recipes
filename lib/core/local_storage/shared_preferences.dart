import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipes/helpers/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

extension SharedData on SharedPreferences {
  String get getLang => getString(AppConstants.languageKEY) ?? 'ar';

  Future<bool> saveLang(String lang) async => setString(AppConstants.languageKEY, lang);

  /// Token
  String? get getToken => getString(AppConstants.tokenKEY);

  Future<bool> saveToken(String token) async => setString(AppConstants.tokenKEY, token);

  Future<bool> clearToken() async => remove(AppConstants.tokenKEY);

  /// UserID
  String? get getUserID => getString('userID');

  Future<bool> saveUserID(String userID) async => setString('userID', userID);

  Future<bool> clearUserID() async => remove("userID");

  /// User notification permission
  bool get isNotificationPermissionTaken => getBool('notificationPermissionTaken') ?? false;

  Future<bool> saveNotificationPermission(bool value) async => setBool('notificationPermissionTaken', value);

  /// User denied permission before
  bool get isPermissionDenied => getBool('permissionDenied') ?? false;

  Future<bool> savePermissionDeniedBefore(bool value) async => setBool('permissionDenied', value);

  Future<bool> clearPermissionDeniedBefore() async => remove("permissionDenied");
}
