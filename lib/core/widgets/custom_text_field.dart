import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText; // Optional label text above the field
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon; // For things like password visibility toggle
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool autocorrect;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autoValidateMode;
  final String? initialValue; // If not using a controller initially (less common with controllers)
  final int? maxLength;
  final int maxLines;
  final EdgeInsetsGeometry contentPadding;
  final InputDecoration? decoration; // Allow full decoration override
  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.autocorrect = true,
    this.focusNode,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.initialValue,
    this.maxLength,
    this.maxLines = 1,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    this.decoration,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Default decoration, can be overridden by the 'decoration' parameter
    final effectiveDecoration =
        decoration ??
        InputDecoration(
          // labelText: labelText, // Floating label, can be enabled if preferred
          // labelStyle: TextStyle(color: theme.hintColor),
          hintText: hintText,
          hintStyle: TextStyle(color: theme.hintColor.withOpacity(0.7)),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: theme.colorScheme.primary) : null,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: theme.colorScheme.error, width: 2.0),
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          // Subtle background
          contentPadding: contentPadding,
          counterText: "", // Hides the default counter if maxLength is set
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null && labelText!.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
            child: Text(
              labelText!,
              style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.8), fontWeight: FontWeight.w500),
            ),
          ),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          autovalidateMode: autoValidateMode,
          validator: validator,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          initialValue: initialValue,
          maxLength: maxLength,
          maxLines: obscureText ? 1 : maxLines,
          // Passwords should be single line
          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
          cursorColor: theme.colorScheme.primary,
          decoration: effectiveDecoration,
          autocorrect: autocorrect,
          textInputAction: textInputAction,
        ),
      ],
    );
  }
}
