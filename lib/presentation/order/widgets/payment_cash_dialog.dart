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
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

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
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isLarge ? 14 : 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isLarge ? 16 : 11,
                color: isLarge
                    ? AppColors.primary
                    : Theme.of(context).textTheme.bodySmall!.color,
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
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      scrollable: true,
      title: Stack(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.highlight_off),
            color: AppColors.primary,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                AppLocalizations.of(context)!.paymentCash,
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
          Text(
            AppLocalizations.of(context)!.quickAmount,
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
          _buildReceiptRow(AppLocalizations.of(context)!.paymentMethod,
              AppLocalizations.of(context)!.cash),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 20.0),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.95,
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.paymentSuccess,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
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
                                      Text(
                                        AppLocalizations.of(context)!.receipt,
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
                                        _buildReceiptRow(
                                            AppLocalizations.of(context)!
                                                .customerName,
                                            widget.customerName ?? '-'),
                                        if (widget.customerPhone != null)
                                          _buildReceiptRow(
                                              AppLocalizations.of(context)!
                                                  .customerPhone,
                                              widget.customerPhone!),
                                        const SpaceHeight(8.0),
                                        const Divider(),
                                        const SpaceHeight(8.0),
                                      ],
                                      _buildReceiptRow(
                                          AppLocalizations.of(context)!.date,
                                          DateFormat('dd/MM/yyyy HH:mm')
                                              .format(DateTime.now())),
                                      const SpaceHeight(8.0),
                                      const Divider(),
                                      const SpaceHeight(8.0),
                                      _buildReceiptRow(
                                          AppLocalizations.of(context)!
                                              .subtotal,
                                          subTotal.currencyFormatRp),
                                      if (appliedDiscounts.isNotEmpty) ...[
                                        for (var discountResponse
                                            in appliedDiscounts)
                                          if (discountResponse.data.isNotEmpty)
                                            _buildReceiptRow(
                                                AppLocalizations.of(context)!
                                                    .discount,
                                                '-${(subTotal * discountResponse.data[0].value / 100).round().currencyFormatRp}'),
                                      ],
                                      if (tax != null && tax > 0)
                                        _buildReceiptRow(
                                            AppLocalizations.of(context)!.tax,
                                            tax.currencyFormatRp),
                                      if (serviceCharge != null &&
                                          serviceCharge > 0)
                                        _buildReceiptRow(
                                            AppLocalizations.of(context)!
                                                .serviceCharge,
                                            serviceCharge.currencyFormatRp),
                                      const Divider(height: 16),
                                      _buildReceiptRow(
                                          AppLocalizations.of(context)!.total,
                                          totalPrice.currencyFormatRp,
                                          isBold: true),
                                      _buildReceiptRow(
                                          AppLocalizations.of(context)!.paid,
                                          nominalBayar.currencyFormatRp),
                                      const Divider(height: 16),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .change,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                (nominalBayar - totalPrice)
                                                    .currencyFormatRp,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: AppColors.primary,
                                                ),
                                                textAlign: TextAlign.end,
                                                softWrap: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                AppLocalizations.of(context)!
                                                    .printingReceipt)),
                                      );
                                    },
                                    icon: const Icon(Icons.print, size: 20),
                                    label: Text(
                                      AppLocalizations.of(context)!.print,
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
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
                                          vertical: 10),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.close,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
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
                      title: Text(AppLocalizations.of(context)!.error),
                      content: Text(message),
                      actions: [
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(AppLocalizations.of(context)!.ok),
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
                              title: Text(AppLocalizations.of(context)!.error),
                              content: Text(AppLocalizations.of(context)!
                                  .pleaseInputThePrice),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(AppLocalizations.of(context)!.ok),
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
                              title: Text(AppLocalizations.of(context)!.error),
                              content: Text(AppLocalizations.of(context)!
                                  .nominalIsLessThanTheTotalPrice),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(AppLocalizations.of(context)!.ok),
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
                  label: AppLocalizations.of(context)!.pay,
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
