import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipes/core/widgets/app_divider.dart';
import 'package:recipes/core/widgets/custom_text_field.dart';
import 'package:recipes/core/widgets/retry_widget.dart';
import 'package:recipes/features/ads/application/ads_provider.dart';
import 'package:recipes/helpers/app_colors.dart';
import 'package:recipes/helpers/app_constants.dart';
import 'package:recipes/helpers/assets.dart';
import 'package:recipes/helpers/extensions.dart';

class AdsListScreen extends StatefulHookConsumerWidget {
  static const String routeName = 'AdsListScreen';

  const AdsListScreen({super.key});

  @override
  ConsumerState<AdsListScreen> createState() => _AdsListScreenState();
}

class _AdsListScreenState extends ConsumerState<AdsListScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final textFocusNode = useFocusNode();

    return GestureDetector(
      onTap: () {
        textFocusNode.unfocus();
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.darkColor,
              actions: [
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(end: 5.w),
                    child: SvgPicture.asset(Assets.profileIcon, width: 20.w, height: 22.h, fit: BoxFit.scaleDown),
                  ),

                  /// todo: open profile screen
                  // onTap: () => Navigator.of(context).pop(),
                ),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 21.w, end: 12.w),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SvgPicture.asset(Assets.notificationBillIcon, width: 20.w, height: 23.h, fit: BoxFit.scaleDown),

                        /// todo: check if the user has unread notifications
                        if (true)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              width: 12.w,
                              height: 12.h,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.redColor),
                              alignment: Alignment.center,
                              child: Text(
                                '3',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w400),
                                strutStyle: StrutStyle(forceStrutHeight: true, fontSize: 10.sp),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  /// todo: open notifications inbox
                  // onTap: () => Navigator.of(context).pop(),
                ),
              ],
              leading: Builder(
                builder: (BuildContext context) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 12.w, end: 20.w),
                        child: GestureDetector(
                          child: SvgPicture.asset(Assets.drawerIcon, width: 19.w, height: 22.h),

                          /// todo: open drawer action
                          // onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(end: 5.w),
                        child: Image.asset(Assets.logoIcon, width: 60.w, height: 22.h, fit: BoxFit.contain),
                      ),
                    ],
                  );
                },
              ),
              leadingWidth: 200.h,
              //  bottom: const PreferredSize(preferredSize: Size.fromHeight(0), child: AlGooruAppDivider()),
            ),
            floatingActionButton: FloatingButtonsWidget(onTapFunction: () {}),
            body: BodySection(textFocusNode: textFocusNode),
          ),
        ),
      ),
    );
  }
}

class BodySection extends HookConsumerWidget {
  final FocusNode textFocusNode;

  const BodySection({super.key, required this.textFocusNode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final isSearchWidgetFocused = useState(false);
    final searchedValue = searchController.debouncedSearch;

    useEffect(() {
      textFocusNode.addListener(() {
        isSearchWidgetFocused.value = textFocusNode.hasFocus;
      });
      return;
    }, [textFocusNode]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
              child: CustomTextField(
                onTap: () {
                  if (searchController.selection == TextSelection.fromPosition(TextPosition(offset: searchController.text.length - 1))) {
                    searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
                  }
                },
                onChanged: (v) {},
                validator: (v) => null,
                prefixIcon: Icons.search,
                prefixIconColor: AppColors.searchIconGreyColor,
                suffixIcon: IconButton(
                  icon: SvgPicture.asset(Assets.micIcon, height: 24.h, width: 24.w),
                  onPressed: () {
                    /// todo: recording action
                  },
                ),
                hintText: 'كلمة أو رقم الإعلان للبحث',
                focusNode: textFocusNode,
                enabled: true,
                controller: searchController,
                contentPadding: EdgeInsets.zero,
                //  shouldShowLabel: false,
              ),
            ),
            SizedBox(height: 18.h),
            AppDivider(height: 1, color: AppColors.greyBorderColor),
          ],
        ),
        ref
            .watch(adsListProvider(searchedValue))
            .when(
              skipLoadingOnRefresh: false,
              data: (dataList) {
                return dataList.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text('!No ads found', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18.sp)),
                        ),
                      )
                    : Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            ref.invalidate(adsListProvider(''));
                          },
                          color: AppColors.darkYellowColor,
                          backgroundColor: AppColors.darkColor,
                          child: ListView.builder(
                            itemCount: dataList.length,
                            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            itemBuilder: (context, index) {
                              return AdItemBuilder(
                                icon: dataList[index].image ?? '',
                                title: dataList[index].title,
                                onTapFunction: () {
                                  /// todo: open details screen of the clickable ad
                                },
                                hasDivider: dataList.length - 1 != index,
                              );
                            },
                          ),
                        ),
                      );
              },
              error: (error, st) => Expanded(
                child: Center(
                  child: RetryWidget(
                    height: MediaQuery.of(context).size.height - 300.h,
                    retryFunction: () => ref.invalidate(adsListProvider(searchedValue)),
                  ),
                ),
              ),
              loading: () => Expanded(
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height - 300.h,
                  child: SpinKitFadingCircle(color: AppColors.darkYellowColor, size: 55.r),
                ),
              ),
            ),
      ],
    );
  }
}

class AdItemBuilder extends ConsumerWidget {
  final String title, icon;
  final bool hasDivider;
  final Function() onTapFunction;

  const AdItemBuilder({super.key, required this.title, required this.icon, required this.hasDivider, required this.onTapFunction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        onTapFunction();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.darkYellowColor),
                  child: Icon(Icons.access_alarm, size: 15.r),
                  // Image.asset(icon, width: 15.w, height: 15.h),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp, color: AppColors.greyColor),
                    strutStyle: StrutStyle(forceStrutHeight: true, fontSize: 16.sp),
                  ),
                ),
                SizedBox(width: 12.w),
                Transform.rotate(
                  angle: Localizations.localeOf(context).languageCode == AppConstants.arabicLanguage ? 0 : 3.14,
                  child: Image.asset(Assets.horizontalArrowIcon, width: 10.w, height: 16.h),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          if (hasDivider) AppDivider(height: 1, color: AppColors.greyBorderColor),
        ],
      ),
    );
  }
}

class FloatingButtonsWidget extends ConsumerWidget {
  final Function() onTapFunction;

  const FloatingButtonsWidget({super.key, required this.onTapFunction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        onTapFunction();
      },
      child: Container(
        width: 45.w,
        height: 45.h,
        decoration: ShapeDecoration(color: AppColors.addButtonColor, shape: OvalBorder()),
        alignment: Alignment.center,
        child: SvgPicture.asset(Assets.plusIcon, height: 28.h, width: 31.w),
      ),
    );
  }
}
