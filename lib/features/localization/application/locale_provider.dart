import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipes/core/local_storage/shared_preferences.dart';
import 'package:recipes/helpers/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences? _prefs;

  LocaleNotifier(this._prefs) : super(_loadInitialLocale(_prefs));

  static Locale _loadInitialLocale(SharedPreferences? prefs) {
    if (prefs == null) {
      return const Locale('ar'); // Default to English if prefs not ready
    }
    final String? localeCode = prefs.getString(AppConstants.languageKEY);
    if (localeCode != null && localeCode.isNotEmpty) {
      return Locale(localeCode);
    }
    return const Locale('ar'); // Default to English if no preference saved
  }

  Future<void> setLocale(Locale newLocale) async {
    if (state == newLocale) return; // No change

    state = newLocale;
    if (_prefs != null) {
      await _prefs.setString(AppConstants.languageKEY, newLocale.languageCode);
    } else {
      // Handle case where prefs might not be ready on first call, though unlikely
      // after initial load. Could also queue this action.
      print("SharedPreferences not ready when trying to set locale.");
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  // Pass SharedPreferences instance once available, or null initially
  return LocaleNotifier(ref.watch(sharedPreferencesProvider));
});
