import 'package:flutter/material.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';

import '../../presentation/home/pages/scanner_page.dart';
import '../constants/colors.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value)? onChanged;
  final VoidCallback? onTap;

  const SearchInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : AppColors.card,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        onTap: onTap,
        readOnly: onTap != null,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? theme.colorScheme.primary : AppColors.primary,
          ),
          suffixIcon: InkWell(
            onTap: () {
              context.push(const ScannerPage());
            },
            child: Icon(
              Icons.qr_code_2,
              color: isDark ? theme.colorScheme.primary : AppColors.primary,
            ),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide:
                BorderSide(color: isDark ? theme.dividerColor : AppColors.card),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide:
                BorderSide(color: isDark ? theme.dividerColor : AppColors.card),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: isDark ? theme.colorScheme.primary : AppColors.primary),
          ),
        ),
      ),
    );
  }
}
