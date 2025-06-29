import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:flutter_pos/core/extensions/int_ext.dart';
import 'package:flutter_pos/core/extensions/string_ext.dart';
import 'package:flutter_pos/presentation/order/bloc/order/order_bloc.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';

class PaymentCashDialog extends StatefulWidget {
  final int price;
  final String? customerName;
  final String? customerPhone;
  const PaymentCashDialog({
    super.key, 
    required this.price,
    this.customerName,
    this.customerPhone,
  });

  @override
  State<PaymentCashDialog> createState() => _PaymentCashDialogState();
}

class _PaymentCashDialogState extends State<PaymentCashDialog> {
  TextEditingController? priceController;

  // Helper method to build receipt row
  Widget _buildReceiptRow(String label, String value,
      {bool isBold = false, bool isLarge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isLarge ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isLarge ? 18 : 14,
              color: isLarge ? AppColors.primary : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    priceController =
        TextEditingController(text: widget.price.currencyFormatRp);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Stack(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.highlight_off),
            color: AppColors.primary,
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Text(
                'Payment - Cash',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceHeight(16.0),
          CustomTextField(
            controller: priceController!,
            label: '',
            showLabel: false,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final int priceValue = value.toIntegerFromText;
              priceController!.text = priceValue.currencyFormatRp;
              priceController!.selection = TextSelection.fromPosition(
                  TextPosition(offset: priceController!.text.length));
            },
          ),
          const SpaceHeight(16.0),
          _buildReceiptRow('Metode Pembayaran', 'Tunai'),
          const SpaceHeight(8.0),
          const Divider(),
          const SpaceHeight(8.0),
          BlocConsumer<OrderBloc, OrderState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                initial: () {},
                loading: () {},
                success: (products,
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
                  // Close the payment dialog first
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }

                  // Show success dialog with receipt preview
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Dialog(
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header
                            const Text(
                              'PAYMENT SUCCESSFUL',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Receipt Content
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Receipt header
                                  const Text(
                                    'RECEIPT',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    DateFormat('dd/MM/yyyy HH:mm')
                                        .format(DateTime.now()),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const Divider(height: 24),

                                  // Customer information
                                  if (widget.customerName != null || widget.customerPhone != null) ...[
                                    _buildReceiptRow('Pelanggan', widget.customerName ?? '-'),
                                    if (widget.customerPhone != null)
                                      _buildReceiptRow('No. HP', widget.customerPhone!),
                                    const SpaceHeight(8.0),
                                    const Divider(),
                                    const SpaceHeight(8.0),
                                  ],
                                  _buildReceiptRow('Tanggal',
                                      DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())),
                                  const SpaceHeight(8.0),
                                  const Divider(),
                                  const SpaceHeight(8.0),

                                  // Payment details
                                  _buildReceiptRow(
                                      'Total', totalPrice.currencyFormatRp),
                                  _buildReceiptRow(
                                      'Paid', nominalBayar.currencyFormatRp),
                                  const Divider(height: 16),
                                  _buildReceiptRow(
                                    'Change',
                                    (nominalBayar - totalPrice)
                                        .currencyFormatRp,
                                    isBold: true,
                                    isLarge: true,
                                  ),
                                ],
                              ),
                            ),

                            // Buttons
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      // TODO: Implement print functionality
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Printing receipt...')),
                                      );
                                    },
                                    icon: const Icon(Icons.print, size: 20),
                                    label: const Text('Print'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      side:
                                          BorderSide(color: AppColors.primary),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Only close the success dialog
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                    child: const Text('Close',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                error: (message) {
                  // Show error message
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content: Text(message),
                      actions: [
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                syncing: () {},
                discountApplied: (discountPercentage, totalAfterDiscount) {},
                syncStatusUpdated: (orderId, isSynced) {},
              );
            },
            builder: (context, state) {
              return state.maybeWhen(orElse: () {
                return const SizedBox();
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
                return Button.filled(
                  onPressed: () {
                    if (priceController!.text.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Please input the price'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          });
                      return;
                    }

                    if (priceController!.text.toIntegerFromText < totalPrice) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'The nominal is less than the total price'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          });
                      return;
                    }
                    context.read<OrderBloc>().add(OrderEvent.addNominalBayar(
                          priceController!.text.toIntegerFromText,
                        ));
                  },
                  label: 'Pay',
                );
              }, error: (message) {
                return const SizedBox();
              });
            },
          ),
        ],
      ),
    );
  }
}
