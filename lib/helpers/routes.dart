import 'package:recipes/features/auth/presentation/auth_screen.dart';
import 'package:recipes/features/auth/presentation/auth_screen_wrapper.dart';
import 'package:recipes/features/auth/presentation/login_screen.dart';
import 'package:recipes/features/bottom_Navigation_bar/presentation/bottom_navigation_bar_screen.dart';
import 'package:recipes/features/explore/presentation/explore_screen.dart';
import 'package:recipes/features/food_recipes/presentation/food_recipes_screen.dart';
import 'package:recipes/features/settings/presentation/settings_screen.dart';

class AppNamedRoutes {
  static final namedRoutes = {
    'AuthScreen': (context) => const AuthScreen(),
    'FoodRecipesScreen': (context) => const FoodRecipesScreen(),
    'AuthScreenWrapper': (context) => const AuthScreenWrapper(),
    'ExploreScreen': (context) => const ExploreScreen(),
    'SettingsScreen': (context) => const SettingsScreen(),
    'BottomNavigationScreen': (context) => const BottomNavigationScreen(),
    'LoginScreen': (context) => const LoginScreen(),
  };
}
