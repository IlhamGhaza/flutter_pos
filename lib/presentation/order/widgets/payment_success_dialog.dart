import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:flutter_pos/core/extensions/date_time_ext.dart';
import 'package:flutter_pos/core/extensions/int_ext.dart';
import 'package:flutter_pos/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_pos/presentation/home/pages/dashboard_page.dart';
import 'package:flutter_pos/presentation/order/bloc/order/order_bloc.dart';
import 'package:flutter_pos/presentation/order/widgets/label_value_widget.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../data/dataoutputs/cwb_print.dart';
import '../../../l10n/app_localizations.dart';

class PaymentSuccessDialog extends StatelessWidget {
  const PaymentSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: Assets.icons.done.svg()),
          const SpaceHeight(20.0),
          Text(
            AppLocalizations.of(context)!.paymentSuccess,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
      content: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            success: (products,
                totalQuantity,
                totalPrice,
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
              context.read<CheckoutBloc>().add(const CheckoutEvent.started());

              // Use the correct variables that match the state
              final qty = totalQuantity;
              final total = totalPrice;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelValue(
                    label: AppLocalizations.of(context)!.paymentMethod,
                    value: paymentMethod == 'QRIS' ? 'QRIS' : paymentMethod,
                  ),
                  const Divider(height: 16.0),
                  LabelValue(
                    label: AppLocalizations.of(context)!.totalQuantity,
                    value: qty.toString(),
                  ),
                  const Divider(height: 16.0),
                  LabelValue(
                    label: AppLocalizations.of(context)!.totalBill,
                    value: total.currencyFormatRp,
                  ),
                  const Divider(height: 16.0),
                  LabelValue(
                    label: AppLocalizations.of(context)!.cashierName,
                    value: namaKasir,
                  ),
                  const Divider(height: 16.0),
                  LabelValue(
                    label: AppLocalizations.of(context)!.transactionDate,
                    value: DateTime.now().toFormattedTime(),
                  ),
                  const SpaceHeight(20.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Button.filled(
                          onPressed: () {
                            context.read<CheckoutBloc>().add(
                                  const CheckoutEvent.started(),
                                );

                            context
                                .read<OrderBloc>()
                                .add(const OrderEvent.started());
                            context.pushReplacement(const DashboardPage());
                          },
                          label: AppLocalizations.of(context)!.done,
                          fontSize: 12,
                        ),
                      ),
                      const SpaceWidth(12.0),
                      Flexible(
                        child: Button.outlined(
                          onPressed: () async {
                            final printValue = await CwbPrint.instance
                                .printOrderV2(
                                    products,
                                    qty,
                                    total,
                                    paymentMethod,
                                    nominalBayar,
                                    namaKasir,
                                    customerName);
                            await PrintBluetoothThermal.writeBytes(printValue);
                          },
                          label: AppLocalizations.of(context)!.print,
                          icon: Assets.icons.print.svg(),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
