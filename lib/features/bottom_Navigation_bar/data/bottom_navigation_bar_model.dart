import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:recipes/features/explore/presentation/explore_screen.dart';
import 'package:recipes/features/food_recipes/presentation/food_recipes_screen.dart';
import 'package:recipes/features/settings/presentation/settings_screen.dart';

class BottomNavigationModel extends Equatable {
  final List<Widget> tabs;
  final int currentTabIndex;

  const BottomNavigationModel({
    required this.tabs,
    required this.currentTabIndex,
  });

  BottomNavigationModel copyWith({
    int? currentTabIndex,
  }) =>
      BottomNavigationModel(tabs: tabs, currentTabIndex: currentTabIndex ?? this.currentTabIndex);

  BottomNavigationModel.initState()
      : tabs = [
    const FoodRecipesScreen(),
    const ExploreScreen(),
    const SettingsScreen(),
  ],
        currentTabIndex = 0;

  Widget get getCurrentWidget => tabs[currentTabIndex];

  @override
  List<Object?> get props => [tabs, currentTabIndex];
}
