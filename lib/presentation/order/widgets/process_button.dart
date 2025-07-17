import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/extensions/int_ext.dart';
import 'package:flutter_pos/presentation/order/bloc/order/order_bloc.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../../l10n/app_localizations.dart';

class ProcessButton extends StatelessWidget {
  final int price;
  final VoidCallback onPressed;

  const ProcessButton({
    super.key,
    required this.price,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          color: AppColors.primary,
        ),
        child: Row(
          children: [
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, orderState) {
                // Tambahkan log untuk debugging
                debugPrint(
                    '[ProcessButton] OrderState: $orderState');
                return orderState.maybeWhen(
                  orElse: () {
                    return const Text(
                      '0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                  success: (orderProducts,
                      orderTotalQuantity,
                      orderTotalPrice,
                      subTotal,
                      discountPercentage,
                      appliedDiscount,
                      appliedDiscounts,
                      paymentMethod,
                      nominalBayar,
                      idKasir,
                      namaKasir,
                      customerName,
                      tax,
                      taxRate,
                      serviceCharge,
                      serviceChargeRate) {
                    // Hanya tampilkan total harga akhir dari OrderBloc
                    debugPrint('[ProcessButton] Final Total: $orderTotalPrice');
                    return Text(
                      orderTotalPrice.currencyFormatRp,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                );
              },
            ),
            const Spacer(),
            Text(
              AppLocalizations.of(context)!.process,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SpaceWidth(5.0),
            const Icon(
              Icons.chevron_right,
              color: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
