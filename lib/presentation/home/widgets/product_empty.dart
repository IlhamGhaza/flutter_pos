import 'package:flutter/material.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../../l10n/app_localizations.dart';


class ProductEmpty extends StatelessWidget {
  const ProductEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.orders.svg(width: 114.0),
          const SpaceHeight(4.0),
           Text(
           AppLocalizations.of(context)!.productEmpty,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
