import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipes/features/auth/presentation/auth_screen_wrapper.dart';
import 'package:recipes/features/bottom_Navigation_bar/presentation/bottom_navigation_bar_screen.dart';
import 'package:recipes/helpers/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/local_storage/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences sharedPreference;

  await Future.wait([
    ScreenUtil.ensureScreenSize(),
    SharedPreferences.getInstance().then(
      (instance) => sharedPreference = instance,
    ),
  ]);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreference),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    if (ref.watch(sharedPreferencesProvider).getUserID != null) {
      final String userID = ref.watch(sharedPreferencesProvider).getUserID!;
    }

    ScreenUtil.init(context, designSize: const Size(375, 812));

    // ref.listen(authProvider, (previous, authResult) {
    //   if (authResult.hasError) {
    //     AppSnackBar().showSnackBar(text: S().errorHappened, color: Colors.red);
    //   }
    // });

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: AppTheme(fontFamily: ref.watch(languageProvider) == 'ar' ? 'Plex' : 'Poppins').lightTheme,
        // navigatorKey: navigatorKey,
        // navigatorObservers: [AppRouteObserver(ref: ref)],
        // scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'Food Recipes',
        routes: AppNamedRoutes.namedRoutes,
        // locale: ref.watch(languageProvider) == 'en' ? const Locale('en') : const Locale('ar'),
        initialRoute: BottomNavigationScreen.routeName,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1)),
            child: child!,
          );
        },
        // localizationsDelegates: const [
        //   S.delegate,
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        //   // DefaultCupertinoLocalizations.delegate,
        // ],
        // supportedLocales: S.delegate.supportedLocales,
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
