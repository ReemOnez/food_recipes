import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipes/helpers/app_colors.dart';

class RetryWidget extends StatelessWidget {
  final Function retryFunction;
  final double height, width;

  const RetryWidget({super.key, required this.retryFunction, required this.height, this.width = 150});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => retryFunction(),
      child: SizedBox(
        height: height,
        width: width.w,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'Retry',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18.sp, color: AppColors.darkColor),
          ),
        ),
      ),
    );
  }
}
