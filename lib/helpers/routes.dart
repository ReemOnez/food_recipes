import 'package:recipes/features/auth/presentation/auth_screen.dart';
import 'package:recipes/features/auth/presentation/auth_screen_wrapper.dart';
import 'package:recipes/features/food_recipes/presentation/food_recipes_screen.dart';

class AppNamedRoutes {
  static final namedRoutes = {
    'AuthScreen': (context) => const AuthScreen(),
    'FoodRecipesScreen': (context) => const FoodRecipesScreen(),
    'AuthScreenWrapper': (context) => const AuthScreenWrapper(),
  };
}
