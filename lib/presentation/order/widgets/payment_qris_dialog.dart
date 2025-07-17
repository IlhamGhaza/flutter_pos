import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:flutter_pos/core/extensions/int_ext.dart';
import 'package:flutter_pos/core/utils/snackbar_utils.dart';
import 'package:flutter_pos/presentation/order/bloc/qris/qris_bloc.dart';
import 'package:flutter_pos/presentation/order/widgets/payment_success_dialog.dart';
import 'package:intl/intl.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../../data/dataoutputs/cwb_print.dart';
import '../../../data/datasources/order_local_datasource.dart';
import '../../../data/models/request/order_request_model.dart';
import '../../../l10n/app_localizations.dart';
import '../bloc/order/order_bloc.dart';

class PaymentQrisDialog extends StatefulWidget {
  final int price;
  final String? customerName;
  final String? customerPhone;
  const PaymentQrisDialog({
    super.key,
    required this.price,
    this.customerName,
    this.customerPhone,
  });

  @override
  State<PaymentQrisDialog> createState() => _PaymentQrisDialogState();
}

class _PaymentQrisDialogState extends State<PaymentQrisDialog> {
  String orderId = '';
  Timer? timer;

  WidgetsToImageController controller = WidgetsToImageController();

  @override
  void initState() {
    orderId = DateTime.now().millisecondsSinceEpoch.toString();
    context.read<QrisBloc>().add(QrisEvent.generateQRCode(
          orderId,
          widget.price,
        ));
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: AppColors.primary,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              AppLocalizations.of(context)!.paymentQR,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
          const SpaceHeight(6.0),
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              return state.maybeWhen(orElse: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }, success: (products,
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
                return Container(
                  width: context.deviceWidth,
                  padding: const EdgeInsets.all(14.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: AppColors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocListener<QrisBloc, QrisState>(
                        listener: (context, state) {
                          state.maybeWhen(orElse: () {
                            return;
                          }, qrisResponse: (data) {
                            const onSec = Duration(seconds: 5);
                            timer = Timer.periodic(onSec, (timer) {
                              context
                                  .read<QrisBloc>()
                                  .add(QrisEvent.checkPaymentStatus(
                                    orderId,
                                  ));
                            });
                          }, success: (message) {
                            timer?.cancel();

                            // Convert products to OrderItemModel
                            final orderItems = products
                                .map((orderItem) => OrderItemModel(
                                      productId: orderItem.product.id,
                                      quantity: orderItem.quantity,
                                      price: orderItem.product.price.toDouble(),
                                    ))
                                .toList();

                            // Create order request
                            final orderRequest = OrderRequestModel(
                              transactionTime: DateFormat('yyyy-MM-ddTHH:mm:ss')
                                  .format(DateTime.now()),
                              kasirId: idKasir,
                              customerId: 1, // Default customer ID
                              subTotal: subTotal.toDouble(),
                              totalPrice: totalPrice.toDouble(),
                              totalItem: totalQuantity,
                              paymentMethod: paymentMethod,
                              paymentAmount: nominalBayar.toDouble(),
                              changeAmount:
                                  (nominalBayar - totalPrice).toDouble(),
                              orderType: 'in-person',
                              orderItems: orderItems,
                            );

                            // Save to local database
                            OrderLocalDatasource.instance.saveOfflineOrder(
                              orderRequest,
                              kasirName: namaKasir,
                              customerName: widget.customerName ?? 'Customer',
                            );

                            context.pop();
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const PaymentSuccessDialog(),
                            );
                          });
                        },
                        child: BlocBuilder<QrisBloc, QrisState>(
                          builder: (context, state) {
                            return state.maybeWhen(
                              orElse: () {
                                return const SizedBox();
                              },
                              qrisResponse: (data) {
                                return WidgetsToImage(
                                  controller: controller,
                                  child: Container(
                                    width: 256.0,
                                    height: 256.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Image.network(
                                        data.actions!.first.url!,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .qrCodeCannotBeLoaded,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.red,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              loading: () {
                                return Container(
                                  width: 256.0,
                                  height: 256.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              error: (message) {
                                return Container(
                                  width: 256.0,
                                  height: 256.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 48,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${AppLocalizations.of(context)!.error}: $message',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            context.read<QrisBloc>().add(
                                                  QrisEvent.generateQRCode(
                                                    orderId,
                                                    widget.price,
                                                  ),
                                                );
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .tryAgain,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SpaceHeight(16.0),
                      Text(
                        AppLocalizations.of(context)!.scanQrisToMakePayment,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SpaceHeight(16),
                      Text(
                        '${AppLocalizations.of(context)!.total}: ${totalPrice.currencyFormatRp}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SpaceHeight(16),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            final bytes = await controller.capture();
                            if (bytes != null) {
                              final listInt = await CwbPrint.instance
                                  .printQRIS(totalPrice, bytes);
                              CwbPrint.instance.printReceipt(listInt);
                            }
                          } catch (e) { 
                            SnackbarUtils(
                              text: AppLocalizations.of(context)!
                                  .errorPrinting,
                              backgroundColor: Colors.red,
                            ).showErrorSnackBar(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.printQris,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SpaceHeight(16),
                      if (widget.customerName != null ||
                          widget.customerPhone != null) ...[
                        _buildReceiptRow(AppLocalizations.of(context)!.customer,
                            widget.customerName ?? '-'),
                        if (widget.customerPhone != null)
                          _buildReceiptRow(
                              AppLocalizations.of(context)!.customerPhone,
                              widget.customerPhone!),
                        const SpaceHeight(8.0),
                      ],
                      _buildReceiptRow(
                          AppLocalizations.of(context)!.date,
                          DateFormat('dd/MM/yyyy HH:mm')
                              .format(DateTime.now())),
                      const SpaceHeight(8.0),
                      _buildReceiptRow(
                          AppLocalizations.of(context)!.paymentMethod, 'QRIS'),
                      const SpaceHeight(8.0),
                    ],
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
