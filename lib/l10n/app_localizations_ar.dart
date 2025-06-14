// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get appTitle => 'تطبيق وصفات';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String welcomeMessage(String userName) {
    return 'مرحباً $userName!';
  }

  @override
  String get emailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get language => 'اللغة';

  @override
  String get hello => 'مرحبا';

  @override
  String get authScreen => 'تسجيل الدخول';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get selectLanguage => 'اختر لغتك';

  @override
  String get changeLanguageButtonText => 'تغيير اللغة';
}
