import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  final double? thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;

  final double? height;

  const AppDivider({
    super.key,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness ?? 0.9,
      color: color ?? const Color(0xffE2E2E2),
      endIndent: endIndent,
      indent: indent,
      height: height,
    );
  }
}
