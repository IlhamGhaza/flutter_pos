import 'package:flutter/material.dart';
import 'package:flutter_pos/core/components/spaces.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/colors.dart';

class MenuButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;
  final bool isImage;
  final double size;

  const MenuButton({
    super.key,
    required this.iconPath,
    required this.label,
    this.isActive = false,
    required this.onPressed,
    this.isImage = false,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: context.deviceWidth,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : theme.cardTheme.color,
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0,4),
              blurRadius: 20,
              blurStyle: BlurStyle.outer,
              spreadRadius: 0,
              color: AppColors.black.withValues(alpha: 0.1),
            ),
          ],
           border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.4)
                : Colors.white,
            width: isDark ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            const SpaceHeight(8.0),
            isImage
                ? Image.asset(iconPath,
                    width: size,
                    height: size,
                    fit: BoxFit.contain,
                    color: isActive ? AppColors.white : AppColors.primary)
                : SvgPicture.asset(
                    iconPath,
                    colorFilter: ColorFilter.mode(
                      isActive ? AppColors.white : AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
            const SpaceHeight(8.0),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive ? Colors.white : Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
