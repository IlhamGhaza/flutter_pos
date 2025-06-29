import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:flutter_pos/core/extensions/int_ext.dart';
import 'package:flutter_pos/presentation/order/bloc/qris/qris_bloc.dart';
import 'package:flutter_pos/presentation/order/widgets/payment_success_dialog.dart';
import 'package:intl/intl.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../../data/dataoutputs/cwb_print.dart';
import '../../../data/datasources/product_local_datasource.dart';
import '../bloc/order/order_bloc.dart';
import '../bloc/qris/models/order_model.dart';

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
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: AppColors.primary,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Pembayaran QRIS',
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
                            final orderModel = OrderModel(
                                paymentMethod: paymentMethod,
                                nominalBayar: nominalBayar,
                                orders: products,
                                totalQuantity: totalQuantity,
                                totalPrice: totalPrice,
                                idKasir: idKasir,
                                namaKasir: namaKasir,
                                transactionTime:
                                    DateFormat('yyyy-MM-ddTHH:mm:ss')
                                        .format(DateTime.now()),
                                isSync: false,
                                customerName: widget.customerName,
                                customerPhone: widget.customerPhone);
                            ProductLocalDatasource.instance
                                .saveOrder(orderModel);
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
                            );
                          },
                        ),
                      ),
                      const SpaceHeight(5.0),
                      const Text(
                        'Scan QRIS untuk melakukan pembayaran',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SpaceHeight(16),
                      Text(
                        'Price: ${totalPrice.currencyFormatRp}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SpaceHeight(16),
                      ElevatedButton(
                        onPressed: () async {
                          final bytes = await controller.capture();
                          final listInt = await CwbPrint.instance
                              .printQRIS(totalPrice, bytes!);
                          CwbPrint.instance.printReceipt(listInt);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Print QRIS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final state = context.read<QrisBloc>().state;
                          final qrisState = state.maybeWhen(
                            orElse: () {},
                            qrisResponse: (data) {
                              return data;
                            },
                          );
                          final url = qrisState?.actions?.first.url;
                          if (url != null) {
                            await launchUrl(Uri.parse(url),
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Bayar via Midtrans',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (widget.customerName != null || widget.customerPhone != null)
                        ...[
                          _buildReceiptRow('Pelanggan', widget.customerName ?? '-'),
                          if (widget.customerPhone != null)
                            _buildReceiptRow('No. HP', widget.customerPhone!),
                          const SpaceHeight(8.0),
                        ],
                      _buildReceiptRow('Tanggal',
                          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())),
                      const SpaceHeight(8.0),
                      _buildReceiptRow('Metode Pembayaran', 'QRIS'),
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
