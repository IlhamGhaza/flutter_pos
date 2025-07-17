import 'package:flutter/material.dart';

import '../constants/colors.dart';

enum ButtonStyle { filled, outlined }

class Button extends StatelessWidget {
  const Button.filled({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyle.filled,
    this.color,
    this.textColor,
    this.width = double.infinity,
    this.height = 50.0,
    this.borderRadius = 16.0,
    this.icon,
    this.disabled = false,
    this.fontSize = 16.0,
  });

  const Button.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyle.outlined,
    this.color,
    this.textColor,
    this.width = double.infinity,
    this.height = 50.0,
    this.borderRadius = 16.0,
    this.icon,
    this.disabled = false,
    this.fontSize = 16.0,
  });

  final Function() onPressed;
  final String label;
  final ButtonStyle style;
  final Color? color;
  final Color? textColor;
  final double width;
  final double height;
  final double borderRadius;
  final Widget? icon;
  final bool disabled;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFilled = style == ButtonStyle.filled;
    
    final backgroundColor = color ?? (isFilled ? AppColors.primary : Colors.transparent);
    final foregroundColor = textColor ?? (isFilled ? Colors.white : AppColors.primary);
    final borderColor = isFilled ? Colors.transparent : AppColors.primary;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: isFilled ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: borderColor,
              width: isFilled ? 0 : 1.5      ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,             color: foregroundColor,
              ),
            ),
          
          ],),
      ),
    );
  }
}
