import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/spaces.dart';

class NavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isImage
                ? Image.asset(
                    iconPath,
                    width: 25.0,
                    height: 25.0,
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  )
                : SvgPicture.asset(
                    iconPath,
                    width: 25.0,
                    height: 25.0,
                    colorFilter: ColorFilter.mode(
                      isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      BlendMode.srcIn,
                    ),
                  ),
            const SpaceHeight(4.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get isImage {
    return iconPath.contains('.png') ||
        iconPath.contains('.jpg') ||
        iconPath.contains('.jpeg') ||
        iconPath == Assets.images.logo.path;
  }
}
