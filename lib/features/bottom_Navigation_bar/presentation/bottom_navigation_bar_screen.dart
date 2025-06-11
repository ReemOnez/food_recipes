import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipes/core/widgets/app_divider.dart';
import 'package:recipes/features/bottom_Navigation_bar/application/bottom_navigation_bar_notifier.dart';

class BottomNavigationScreen extends ConsumerStatefulWidget {
  static const String routeName = 'BottomNavigationScreen';

  const BottomNavigationScreen({super.key});

  @override
  ConsumerState<BottomNavigationScreen> createState() =>
      _BottomNavigationScreenState();
}

class _BottomNavigationScreenState
    extends ConsumerState<BottomNavigationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).colorScheme.onPrimary,
              statusBarIconBrightness: Brightness.dark,
              // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            elevation: 0,
            toolbarHeight: 20,
          ),
          bottomNavigationBar: const BottomNavigationBarBuilder(),
          body: ref.watch(bottomNavigationProvider).getCurrentWidget,
        ),
      ),
    );
  }
}

class BottomNavigationBarBuilder extends ConsumerWidget {
  const BottomNavigationBarBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppDivider(height: 1.h),
        NavigationBar(
          indicatorColor: Colors.transparent,
          selectedIndex: ref.watch(bottomNavigationProvider).currentTabIndex,
          onDestinationSelected: (index) {
            ref.watch(bottomNavigationProvider.notifier).setCurrentTab(index);
          },
          elevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.background,
          destinations: [
            NavigationDestination(
              label: 'Recipes',
              selectedIcon: Padding(
                padding: EdgeInsetsDirectional.only(
                  top: 5.h,
                  end: 8,
                  start: 8,
                  bottom: 4.h,
                ),
                // child: SvgPicture.asset(
                //   key: const Key('ClientHomeActiveKey'),
                //   Assets.clientHomeSelected,
                //   width: 24.w,
                //   height: 24.h,
                // ),
              ),
              // icon: Padding(
              //   padding: EdgeInsetsDirectional.only(
              //     top: 5.h,
              //     end: 8,
              //     start: 8,
              //     bottom: 4.h,
              //   ),
              //   child: SvgPicture.asset(
              //     key: const Key('ClientHomeInActiveKey'),
              //     Assets.clientHomeNotSelected,
              //     width: 24.w,
              //     height: 24.h,
              //   ),
              // ),
              tooltip: '',
              icon: Icon(Icons.home_filled),
            ),
            NavigationDestination(
              label: 'Explore',
              selectedIcon: Padding(
                padding: EdgeInsetsDirectional.only(
                  top: 5.h,
                  end: 8,
                  start: 8,
                  bottom: 4.h,
                ),
                // child: SvgPicture.asset(
                //   key: const Key('ClientMySessionsActiveKey'),
                //   Assets.clientSessionsSelected,
                //   width: 24.w,
                //   height: 24.h,
                // ),
              ),
              // icon: Padding(
              //   padding: EdgeInsetsDirectional.only(
              //     top: 5.h,
              //     end: 8,
              //     start: 8,
              //     bottom: 4.h,
              //   ),
              //   child: SvgPicture.asset(
              //     key: const Key('ClientMySessionsInActiveKey'),
              //     Assets.clientSessionsNotSelected,
              //     width: 24.w,
              //     height: 24.h,
              //   ),
              // ),
              icon: Icon(Icons.explore),
              tooltip: '',
            ),
            NavigationDestination(
              label: 'Settings',
              selectedIcon: Padding(
                padding: EdgeInsetsDirectional.only(
                  top: 5.h,
                  end: 8,
                  start: 8,
                  bottom: 4.h,
                ),
                // child: SvgPicture.asset(
                //   key: const Key('ClientMyAccountActiveKey'),
                //   Assets.clientAccountSelected,
                //   width: 24.w,
                //   height: 24.h,
                // ),
              ),
              // icon: Padding(
              //   padding: EdgeInsetsDirectional.only(
              //     top: 5.h,
              //     end: 8,
              //     start: 8,
              //     bottom: 4.h,
              //   ),
              //   child: SvgPicture.asset(
              //     key: const Key('ClientMyAccountInActiveKey'),
              //     Assets.clientAccountNotSelected,
              //     width: 24.w,
              //     height: 24.h,
              //   ),
              // ),
              icon: Icon(Icons.settings),
              tooltip: '',
            ),
          ],
        ),
      ],
    );
  }
}
