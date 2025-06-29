import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:flutter_pos/core/extensions/int_ext.dart';
import 'package:flutter_pos/core/utils/snackbar_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart' as open_file;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_pos/presentation/order/bloc/qris/models/order_model.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/connectivity_utils.dart';
import '../../home/pages/dashboard_page.dart';
import '../bloc/history/history_bloc.dart';
import '../widgets/history_transaction_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}//

class _HistoryPageState extends State<HistoryPage> {
  bool isOnline = true;
  @override
  void initState() {
    _checkConnectivity();
    super.initState();
    context.read<HistoryBloc>().add(const HistoryEvent.fetch());
  }

  Future<void> _checkConnectivity() async {
    final connected = await ConnectivityUtils.isConnected();
    setState(() {
      isOnline = connected;
    });
  }

  Future<void> saveAsPdf() async {
    try {
      final state = context.read<HistoryBloc>().state;
      List<OrderModel> orders = [];
      
      state.maybeWhen(
        success: (data) => orders = data.cast<OrderModel>(),
        orElse: () {
          SnackbarUtils(
            text: 'No data to export',
            backgroundColor: Colors.orange,
          ).showErrorSnackBar(context);
          return;
        },
      );

      if (orders.isEmpty) {
        SnackbarUtils(
          text: 'No transaction data available',
          backgroundColor: Colors.orange,
        ).showErrorSnackBar(context);
        return;
      }

      // Show loading
      SnackbarUtils(
        text: 'Generating PDF...',
        backgroundColor: AppColors.primary,
      ).showSuccessSnackBar(context);

      // Generate PDF
      final pdf = pw.Document();
      final logo = await _getImageData('assets/logo/logo.png');
      
      // Add a page to the PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Transaction History',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Generated: ${DateTime.now().toString().split('.')[0]}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                pw.SizedBox(
                  height: 50,
                  width: 50,
                  child: pw.Image(logo),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            
            // Transaction List
            pw.Table.fromTextArray(
              headers: ['No', 'Order ID', 'Date', 'Items', 'Total'],
              data: List<List<dynamic>>.generate(
                orders.length,
                (index) {
                  final order = orders[index];
                  return [
                    '${index + 1}',
                    order.id?.toString() ?? 'N/A',
                    order.transactionTime,
                    order.totalQuantity.toString(),
                    'Rp ${order.totalPrice.currencyFormatRp}',
                  ];
                },
              ),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.center,
                2: pw.Alignment.center,
                3: pw.Alignment.center,
                4: pw.Alignment.centerRight,
              },
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey400),
                ),
              ),
              cellPadding: const pw.EdgeInsets.all(5),
            ),
            pw.SizedBox(height: 10),
            
            // Total Summary
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Total Transactions: ${orders.length} | Total Amount: Rp ${orders.fold(0, (int sum, order) => sum + order.totalPrice).currencyFormatRp}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              ),
            ),
          ],
        ),
      );

      // Save the PDF document
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/transaction_history_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      // Open the PDF
      await open_file.OpenFile.open(file.path);

      SnackbarUtils(
        text: 'PDF saved successfully',
        backgroundColor: Colors.green,
      ).showSuccessSnackBar(context);
    } catch (e) {
      SnackbarUtils(
        text: 'Failed to generate PDF: $e',
        backgroundColor: Colors.red,
      ).showErrorSnackBar(context);
    }
  }
  
  Future<pw.MemoryImage> _getImageData(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final imageData = byteData.buffer.asUint8List();
    return pw.MemoryImage(imageData);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    const paddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.push(const DashboardPage());
            },
          ),
          title: const Text('History',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          elevation: 0,
          centerTitle: true,
          actions: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 6 : 8,
                vertical: 2,
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isOnline ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isOnline ? Icons.wifi : Icons.wifi_off,
                    color: Colors.white,
                    size: isSmallScreen ? 12 : 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 10 : 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                saveAsPdf();
              },
              icon: const Icon(Icons.save_as_outlined),
            ),
          ],
        ),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            return state.maybeWhen(orElse: () {
              return const Center(
                child: Text('No data'),
              );
            }, loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }, success: (data) {
              if (data.isEmpty) {
                return const Center(
                  child: Text('No data'),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                itemCount: data.length,
                separatorBuilder: (context, index) => const SpaceHeight(8.0),
                itemBuilder: (context, index) => HistoryTransactionCard(
                  padding: paddingHorizontal,
                  data: data[index],
                ),
              );
            });
          },
        ));
  }
}
