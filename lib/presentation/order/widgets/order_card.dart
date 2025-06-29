import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/extensions/int_ext.dart';
import 'package:flutter_pos/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_pos/data/models/order_item_model.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/variables.dart';

class OrderCard extends StatelessWidget {
  final OrderItem data;
  final VoidCallback onDeleteTap;
  final EdgeInsetsGeometry? padding;

  const OrderCard({
    super.key,
    required this.data,
    required this.onDeleteTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    final paddingValue = isSmallScreen ? 8.0 : 16.0;
    final imageSize = isSmallScreen ? 56.0 : 76.0;
    
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          margin: padding,
          padding: EdgeInsets.all(paddingValue),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1.5, color: Color(0xFFC7D0EB)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                  imageUrl: '${Variables.imageBaseUrl}${data.product.image}',
                  placeholder: (context, url) => const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.food_bank_outlined,
                    size: 32,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 12.0 : 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            data.product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          data.product.price.toInt().currencyFormatRp,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    StatefulBuilder(
                      builder: (context, setState) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.read<CheckoutBloc>().add(
                                      CheckoutEvent.removeCheckout(data.product));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(
                                    Icons.remove_circle,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 32.0,
                                child: Center(
                                  child: Text(
                                    data.quantity.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.read<CheckoutBloc>().add(
                                      CheckoutEvent.addCheckout(data.product));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(
                                    Icons.add_circle,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onDeleteTap,
            icon: const Icon(
              Icons.close,
              color: Colors.grey,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
