import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipes/features/ads/presentation/ads_screen.dart';
import 'package:recipes/features/auth/presentation/auth_screen_wrapper.dart';
import 'package:recipes/helpers/routes.dart';
import 'package:recipes/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/local_storage/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/localization/application/locale_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences sharedPreference;

  await Future.wait([ScreenUtil.ensureScreenSize(), SharedPreferences.getInstance().then((instance) => sharedPreference = instance)]);

  runApp(ProviderScope(overrides: [sharedPreferencesProvider.overrideWithValue(sharedPreference)], child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Cairo',
          textTheme: TextTheme(
            displayLarge: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
            bodyMedium: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.normal),
          ),
        ),
        // navigatorKey: navigatorKey,
        // navigatorObservers: [AppRouteObserver(ref: ref)],
        // scaffoldMessengerKey: scaffoldMessengerKey,
        // For the title shown in the OS task switcher (most idiomatic way)
        onGenerateTitle: (ctx) {
          // 'ctx' here IS a descendant context of MaterialApp's Localizations widget
          return AppLocalizations.of(ctx)!.appTitle;
        },
        routes: AppNamedRoutes.namedRoutes,
        locale: ref.watch(localeProvider),
        initialRoute: AdsListScreen.routeName,
        // AuthScreenWrapper.routeName,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
            child: child!,
          );
        },
        // Define the localizations delegates.
        localizationsDelegates: const [
          AppLocalizations.delegate, // Your app-specific generated delegate
          GlobalMaterialLocalizations.delegate, // For Material widget translations
          GlobalWidgetsLocalizations.delegate, // For text direction, etc.
          GlobalCupertinoLocalizations.delegate, // For Cupertino specific translations
        ],
        // List all supported locales that your app offers.
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
