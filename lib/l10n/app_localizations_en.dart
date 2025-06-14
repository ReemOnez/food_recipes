// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get appTitle => 'Recipe App';

  @override
  String get loginButton => 'Login';

  @override
  String welcomeMessage(String userName) {
    return 'Hello $userName!';
  }

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get language => 'Language';

  @override
  String get hello => 'Hello';

  @override
  String get authScreen => 'Authentication';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get selectLanguage => 'Select your language';

  @override
  String get changeLanguageButtonText => 'Change Language';
}
