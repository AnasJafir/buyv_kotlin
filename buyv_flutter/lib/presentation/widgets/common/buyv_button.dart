import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Reusable branded button — unified style, fixes UI-002 (spinner) and UI-001 (button borders).
class BuyVButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? color;
  final IconData? icon;
  final double? width;
  final double height;

  const BuyVButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.color,
    this.icon,
    this.width,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? AppColors.primary;

    if (isOutlined) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: btnColor, width: 1.5),
            foregroundColor: btnColor,
          ),
          child: _child(btnColor),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: btnColor),
        child: _child(Colors.white),
      ),
    );
  }

  Widget _child(Color spinnerColor) {
    if (isLoading) {
      return SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          color: spinnerColor,
          strokeWidth: 2.5,
        ),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }
    return Text(label);
  }
}
