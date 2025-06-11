import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipes/features/bottom_Navigation_bar/data/bottom_navigation_bar_model.dart';
import 'package:recipes/features/explore/presentation/explore_screen.dart';
import 'package:recipes/features/food_recipes/presentation/food_recipes_screen.dart';
import 'package:recipes/features/settings/presentation/settings_screen.dart';

class BottomNavigationNotifier extends Notifier<BottomNavigationModel> {
  @override
  build() {
    return BottomNavigationModel.initState();
  }

  void setCurrentTab(int index) {
    state = state.copyWith(currentTabIndex: index);

    final Map<int, String> tabsNames = {
      0: FoodRecipesScreen.routeName,
      1: ExploreScreen.routeName,
      2: SettingsScreen.routeName,
    };
  }
}

final bottomNavigationProvider =
    NotifierProvider<BottomNavigationNotifier, BottomNavigationModel>(() {
      return BottomNavigationNotifier();
    });
