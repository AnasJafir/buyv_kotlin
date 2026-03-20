import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Reusable branded text field — unifies input styling across all screens.
class BuyVTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final bool readOnly;
  final VoidCallback? onTap;

  const BuyVTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
    this.textInputAction,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.textSecondary) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
