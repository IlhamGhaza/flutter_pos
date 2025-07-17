import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/constants/variables.dart';
import 'package:flutter_pos/core/extensions/int_ext.dart';
import 'package:flutter_pos/data/models/response/product_response_model.dart';
import 'package:flutter_pos/presentation/home/bloc/checkout/checkout_bloc.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';

class ProductCard extends StatelessWidget {
  final Product data;

  const ProductCard({
    super.key,
    required this.data,
  });

  // Check if the screen width is tablet size (600dp or wider)
  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            context.read<CheckoutBloc>().add(CheckoutEvent.addCheckout(data));
          },
          child: Container(
            padding: isTablet
                ? const EdgeInsets.all(20.0)
                : const EdgeInsets.all(16.0),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1,
                    color: isDark
                        ? Theme.of(context).dividerColor
                        : AppColors.card),
                borderRadius: BorderRadius.circular(20),
              ),
              color: isDark
                  ? Theme.of(context).colorScheme.surface
                  : AppColors.white,
              shadows: isTablet
                  ? [
                      BoxShadow(
                        color: isDark
                            ? Theme.of(context).shadowColor.withOpacity(0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: isTablet
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  alignment: Alignment.center,
                  padding: isTablet
                      ? const EdgeInsets.all(16.0)
                      : const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.08)
                        : AppColors.disabled.withValues(alpha: 0.2),
                    border: isTablet
                        ? Border.all(
                            color: isDark
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1)
                                : AppColors.primary.withValues(alpha: 0.1),
                            width: 1.5)
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    child: CachedNetworkImage(
                      height: isTablet ? 70 : 50,
                      fit: BoxFit.contain,
                      imageUrl: '${Variables.imageBaseUrl}${data.image}',
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/logo/logo.png',
                        height: isTablet ? 70 : 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SpaceHeight(16.0),

                // Product Name
                Text(
                  data.name,
                  textAlign: isTablet ? TextAlign.center : TextAlign.left,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: isDark
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.black,
                  ),
                  maxLines: isTablet ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SpaceHeight(isTablet ? 12.0 : 8.0),

                // Category
                Text(
                  data.categoryId.toString(),
                  textAlign: isTablet ? TextAlign.center : TextAlign.left,
                  style: TextStyle(
                    color: isDark
                        ? Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6)
                        : AppColors.grey,
                    fontSize: isTablet ? 13 : 12,
                    fontWeight: isTablet ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),

                const Spacer(),

                // Price and Add Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        data.price.toInt().currencyFormatRp,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: isTablet ? 15 : 14,
                          color: isDark
                              ? Theme.of(context).colorScheme.primary
                              : (isTablet ? AppColors.primary : Colors.black),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: AppColors.primary,
                        boxShadow: isTablet
                            ? [
                                BoxShadow(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Icon(
                        Icons.add,
                        size: isTablet ? 20 : 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => const SizedBox(),
              success: (products, qty, price, _) {
                if (qty == 0 || products.isEmpty) {
                  return const SizedBox();
                }

                try {
                  final productInCart = products.firstWhere(
                    (element) => element.product == data,
                  );

                  if (productInCart.quantity > 0) {
                    return Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Text(
                          productInCart.quantity.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  // Product not found in cart
                }

                // Default return for all other cases
                return const SizedBox();
              },
            );
          },
        ),
      ],
    );
  }
}
