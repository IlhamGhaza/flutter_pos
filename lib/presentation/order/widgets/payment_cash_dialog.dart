import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:flutter_pos/core/extensions/int_ext.dart';
import 'package:flutter_pos/core/extensions/string_ext.dart';
import 'package:flutter_pos/presentation/order/bloc/order/order_bloc.dart';
import 'package:flutter_pos/presentation/home/bloc/checkout/checkout_bloc.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';

class PaymentCashDialog extends StatefulWidget {
  final int price;
  final String? customerName;
  final String? customerPhone;
  final int customerId;
  const PaymentCashDialog({
    super.key,
    required this.price,
    this.customerName,
    this.customerPhone,
    required this.customerId,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isLarge ? 16 : 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isLarge ? 18 : 14,
                color: isLarge ? AppColors.primary : Colors.black,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build money shortcut button
  Widget _buildMoneyButton(int amount) {
    return InkWell(
      onTap: () {
        priceController!.text = amount.currencyFormatRp;
        priceController!.selection = TextSelection.fromPosition(
            TextPosition(offset: priceController!.text.length));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          amount.currencyFormatRp,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
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

          // Shortcut money buttons
          const Text(
            'Quick Amount:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SpaceHeight(8.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              _buildMoneyButton(10000),
              _buildMoneyButton(20000),
              _buildMoneyButton(50000),
              _buildMoneyButton(100000),
              _buildMoneyButton(200000),
              _buildMoneyButton(500000),
            ],
          ),
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
                  debugPrint('[PaymentCashDialog] OrderState: $state');
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
                        constraints:
                            const BoxConstraints(maxWidth: 400, maxHeight: 600),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
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
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
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
                                      if (widget.customerName != null ||
                                          widget.customerPhone != null) ...[
                                        _buildReceiptRow('Pelanggan',
                                            widget.customerName ?? '-'),
                                        if (widget.customerPhone != null)
                                          _buildReceiptRow(
                                              'No. HP', widget.customerPhone!),
                                        const SpaceHeight(8.0),
                                        const Divider(),
                                        const SpaceHeight(8.0),
                                      ],
                                      _buildReceiptRow(
                                          'Tanggal',
                                          DateFormat('dd/MM/yyyy HH:mm')
                                              .format(DateTime.now())),
                                      const SpaceHeight(8.0),
                                      const Divider(),
                                      const SpaceHeight(8.0),
                                      _buildReceiptRow('Subtotal',
                                          subTotal.currencyFormatRp),
                                      if (appliedDiscounts.isNotEmpty) ...[
                                        for (var discountResponse
                                            in appliedDiscounts)
                                          if (discountResponse.data.isNotEmpty)
                                            _buildReceiptRow(
                                                'Discount ${discountResponse.data[0].value}%',
                                                '-${(subTotal * discountResponse.data[0].value / 100).round().currencyFormatRp}'),
                                      ],
                                      if (tax != null && tax > 0)
                                        _buildReceiptRow('Tax $taxRate%',
                                            tax.currencyFormatRp),
                                      if (serviceCharge != null &&
                                          serviceCharge > 0)
                                        _buildReceiptRow(
                                            'Service Charge $serviceChargeRate%',
                                            serviceCharge.currencyFormatRp),
                                      const Divider(height: 16),
                                      _buildReceiptRow(
                                          'Total', totalPrice.currencyFormatRp,
                                          isBold: true),
                                      _buildReceiptRow('Paid',
                                          nominalBayar.currencyFormatRp),
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
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
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
                                      context
                                          .read<CheckoutBloc>()
                                          .add(const CheckoutEvent.started());
                                      context
                                          .read<OrderBloc>()
                                          .add(const OrderEvent.started());
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

                    final paymentAmount =
                        priceController!.text.toIntegerFromText;

                    if (paymentAmount < totalPrice) {
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

                    // Update payment amount in the state
                    context
                        .read<OrderBloc>()
                        .add(OrderEvent.addNominalBayar(paymentAmount));

                    // Process the order with all required parameters
                    context.read<OrderBloc>().add(OrderEvent.processOrder(
                          customerId: widget.customerId,
                          customerName:
                              widget.customerName ?? 'Walk-in Customer',
                          paymentMethod: 'cash',
                          paymentAmount: paymentAmount.toDouble(),
                          orderType:
                              'in-person', // or take_away based on your needs
                          customerOrderNotes: '', // Add if you have order notes
                          taxId: tax,
                          taxRate: taxRate,
                          serviceChargeId: serviceCharge,
                          serviceChargeRate: serviceChargeRate,
                          discountId: appliedDiscount?.data.firstOrNull?.id,
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
