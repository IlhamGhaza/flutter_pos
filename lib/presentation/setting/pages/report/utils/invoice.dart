import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_pos/core/extensions/int_ext.dart';
import 'package:flutter_pos/core/extensions/string_ext.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../../data/models/response/product_sales_report.dart';
import '../../../../../data/models/response/summary_response_model.dart';
import 'helper_pdf_service.dart';

class Invoice {
  static late Font ttf;
  static Future<File> generate(
      List<Map<String, dynamic>> productSales, Map<String, dynamic> summary) async {
    final pdf = Document();
    // var data = await rootBundle.load("assets/fonts/noto-sans.ttf");
    // ttf = Font.ttf(data);
    final ByteData dataImage = await rootBundle.load('assets/images/logo.png');
    final Uint8List bytes = dataImage.buffer.asUint8List();

    // Membuat objek Image dari gambar
    final image = pw.MemoryImage(bytes);

    pdf.addPage(
      MultiPage(
        pageTheme: PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          theme: ThemeData.withFont(
            base: Font.helvetica(),
          ),
          buildBackground: (context) => pw.Container(
            color: PdfColors.white,
          ),
        ),
        build: (context) => [
          buildHeader(image),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Text('Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: PdfColors.black,
              )),
          SizedBox(height: 0.15 * PdfPageFormat.cm),
          buildSummary(summary),
          SizedBox(height: 4 * PdfPageFormat.cm),
          Text('Product Sales',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: PdfColors.black,
              )),
          SizedBox(height: 0.25 * PdfPageFormat.cm),
          buildInvoice(productSales),
          Divider(color: PdfColors.grey),
          SizedBox(height: 0.25 * PdfPageFormat.cm),
        ],
        footer: (context) => buildFooter(),
      ),
    );

    return HelperPdfService.saveDocument(
        name:
            'FIC 11 Jilid 2 |  Report | ${DateTime.now().millisecondsSinceEpoch}.pdf',
        pdf: pdf);
  }

  static Widget buildHeader(
    MemoryImage image,
  ) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1 * PdfPageFormat.cm),
            Text('FIC 11 Jilid 2 | Report',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: PdfColors.black,
                )),
            SizedBox(height: 0.2 * PdfPageFormat.cm),
            Text(
              'Created At: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
              style: TextStyle(color: PdfColors.grey800),
            ),
          ],
        ),
        Image(
          image,
          width: 80.0,
          height: 80.0,
          fit: BoxFit.fill,
        ),
      ]);

  static Widget buildSummary(Map<String, dynamic> summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total Revenue: Rp ${summary['totalOmzet']}', style: TextStyle(color: PdfColors.black)),
        Text('Total Transactions: ${summary['totalTransaksi']}', style: TextStyle(color: PdfColors.black)),
        Text('Top Product: ${summary['topProduct']}', style: TextStyle(color: PdfColors.black)),
        Text('Busiest Day: ${summary['topDay']}', style: TextStyle(color: PdfColors.black)),
        if (summary['topHour'] != null) Text('Busiest Hour: ${summary['topHour']}:00', style: TextStyle(color: PdfColors.black)),
      ],
    );
  }

  static Widget buildInvoice(List<Map<String, dynamic>> productSales) {
    return Table.fromTextArray(
      headers: ['ID', 'Product', 'Price', 'Quantity', 'Total'],
      data: productSales.map((e) => [
        e['productId'].toString(),
        e['productName'],
        e['productPrice'].toString(),
        e['totalQuantity'].toString(),
        e['totalPrice'].toString(),
      ]).toList(),
      headerStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const BoxDecoration(
        color: PdfColors.blue,
      ),
      cellStyle: TextStyle(color: PdfColors.black),
      cellAlignment: Alignment.centerLeft,
      border: TableBorder.all(color: PdfColors.grey300, width: 0.5),
      oddRowDecoration: const BoxDecoration(color: PdfColors.grey100),
    );
  }

  static Widget buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(color: PdfColors.grey),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Address',
              value: 'Jalan Palagan No. 12, Sleman, DI Yogyakarta, 12345'),
          SizedBox(height: 1 * PdfPageFormat.mm),
        ],
      );

  static Row buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold, color: PdfColors.black);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value, style: TextStyle(color: PdfColors.black)),
      ],
    );
  }

  static Container buildTextPrice({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold, color: PdfColors.black);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : TextStyle(color: PdfColors.black)),
        ],
      ),
    );
  }
}
