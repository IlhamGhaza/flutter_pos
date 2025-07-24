import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/components/buttons.dart';
import 'package:flutter_pos/core/components/spaces.dart';
import 'package:flutter_pos/core/constants/colors.dart';
import 'package:flutter_pos/core/extensions/int_ext.dart';
import 'package:flutter_pos/core/extensions/string_ext.dart';
import 'package:flutter_pos/data/models/response/summary_response_model.dart';
import 'package:flutter_pos/presentation/setting/bloc/report/product_sales/product_sales_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/report/summary/summary_bloc.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import 'package:intl/intl.dart';

import '../../../../data/models/response/product_sales_report.dart';
import 'utils/helper_pdf_service.dart';
import 'utils/invoice.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../data/datasources/order_local_datasource.dart';
import '../../../../data/models/order_item_model.dart';
import '../../../../data/models/response/product_response_model.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String)
      return int.tryParse(value) ?? double.tryParse(value)?.toInt() ?? 0;
    return 0;
  }

  DateTime selectedStartDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime selectedEndDate = DateTime.now();

  List<Map<String, dynamic>> offlineOrders = [];
  bool isLoadingOffline = true;

  @override
  void initState() {
    super.initState();
    _loadOfflineOrders();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
      });
      _loadOfflineOrders();
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: selectedStartDate,
      lastDate: DateTime(2100, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
        if (selectedEndDate.isBefore(selectedStartDate)) {
          selectedStartDate = selectedEndDate;
        }
      });
      _loadOfflineOrders();
    }
  }

  Future<void> _loadOfflineOrders() async {
    setState(() => isLoadingOffline = true);
    final data = await OrderLocalDatasource.instance
        .getAllOfflineOrdersWithProductJoin();
    // Filter by selected date range
    final filtered = data.where((order) {
      final orderMap = order['order'] as Map<String, dynamic>;
      final dateStr =
          (orderMap['transaction_time'] as String?)?.split('T').first;
      if (dateStr == null) return false;
      final date = DateTime.tryParse(dateStr);
      if (date == null) return false;
      return !date.isBefore(selectedStartDate) &&
          !date.isAfter(selectedEndDate);
    }).toList();
    setState(() {
      offlineOrders = filtered;
      isLoadingOffline = false;
    });
  }

  // --- Aggregation helpers for summary, product sales, and charts ---
  Map<String, dynamic> getOfflineSummary() {
    int totalOmzet = 0;
    int totalTransaksi = offlineOrders.length;
    final Map<String, int> productSales = {};
    final Map<String, int> dayCount = {};
    final Map<int, int> hourCount = {};
    for (final order in offlineOrders) {
      final orderMap = order['order'] as Map<String, dynamic>;
      totalOmzet += _toInt(orderMap['total_price']);
      final date =
          (orderMap['transaction_time'] as String?)?.split('T').first ?? '';
      dayCount[date] = (dayCount[date] ?? 0) + 1;
      final time = orderMap['transaction_time'] as String?;
      if (time != null && time.length >= 13) {
        final hour = int.tryParse(time.substring(11, 13)) ?? 0;
        hourCount[hour] = (hourCount[hour] ?? 0) + 1;
      }
      final items = (order['items'] as List).cast<Map<String, dynamic>>();
      for (final item in items) {
        final name = item['name'] as String? ??
            item['product_name'] as String? ??
            'Unknown';
        final qty = _toInt(item['quantity']);
        productSales[name] = (productSales[name] ?? 0) + qty;
      }
    }
    final topProduct = productSales.entries.isNotEmpty
        ? productSales.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : '-';
    final topDay = dayCount.entries.isNotEmpty
        ? dayCount.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : '-';
    final topHour = hourCount.entries.isNotEmpty
        ? hourCount.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : null;
    return {
      'totalOmzet': totalOmzet,
      'totalTransaksi': totalTransaksi,
      'topProduct': topProduct,
      'topDay': topDay,
      'topHour': topHour,
    };
  }

  List<Map<String, dynamic>> getOfflineTopProductsBar({int top = 5}) {
    final Map<String, int> productSales = {};
    for (final order in offlineOrders) {
      final items = (order['items'] as List).cast<Map<String, dynamic>>();
      for (final item in items) {
        final name = item['name'] as String? ??
            item['product_name'] as String? ??
            'Unknown';
        final qty = _toInt(item['quantity']);
        productSales[name] = (productSales[name] ?? 0) + qty;
      }
    }
    final sorted = productSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted
        .take(top)
        .map((e) => {'name': e.key, 'qty': e.value})
        .toList();
  }

  List<Map<String, dynamic>> getOfflineOmzetTrend() {
    final Map<String, int> omzetPerDay = {};
    for (final order in offlineOrders) {
      final orderMap = order['order'] as Map<String, dynamic>;
      final date =
          (orderMap['transaction_time'] as String?)?.split('T').first ?? '';
      final omzet = _toInt(orderMap['total_price']);
      omzetPerDay[date] = (omzetPerDay[date] ?? 0) + omzet;
    }
    return omzetPerDay.entries
        .map((e) => {'date': e.key, 'omzet': e.value})
        .toList()
      ..sort((a, b) =>
          (a['date'] as String? ?? '').compareTo(b['date'] as String? ?? ''));
  }

  List<Map<String, dynamic>> getOfflineTransactionsByHour() {
    final Map<int, int> hourCount = {};
    for (final order in offlineOrders) {
      final orderMap = order['order'] as Map<String, dynamic>;
      final time = orderMap['transaction_time'] as String?;
      if (time != null && time.length >= 13) {
        final hour = int.tryParse(time.substring(11, 13)) ?? 0;
        hourCount[hour] = (hourCount[hour] ?? 0) + 1;
      }
    }
    return List.generate(24, (h) => {'hour': h, 'count': hourCount[h] ?? 0});
  }

  List<Map<String, dynamic>> getOfflineProductSalesTable() {
    final Map<int, Map<String, dynamic>> productMap = {};
    for (final order in offlineOrders) {
      final items = (order['items'] as List).cast<Map<String, dynamic>>();
      for (final item in items) {
        final int productId = _toInt(item['product_id']);
        final String productName =
            item['product_name']?.toString() ?? 'Unknown';
        final int productPrice = _toInt(item['price']);
        final int qty = _toInt(item['quantity']);
        final int totalPrice = _toInt(item['total_price']);
        if (!productMap.containsKey(productId)) {
          productMap[productId] = {
            'productId': productId,
            'productName': productName,
            'productPrice': productPrice,
            'totalQuantity': qty,
            'totalPrice': totalPrice,
          };
        } else {
          productMap[productId]!['totalQuantity'] += qty;
          productMap[productId]!['totalPrice'] += totalPrice;
        }
      }
    }
    return productMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Report"),
          centerTitle: true,
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'PDF') {
                  final summary = getOfflineSummary();
                  final productSales = getOfflineProductSalesTable();
                  final pdfFile = await Invoice.generate(productSales, summary);
                  HelperPdfService.openFile(pdfFile);
                }
              },
              itemBuilder: (BuildContext context) {
                return {'PDF'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              icon: const Icon(Icons.more_vert, color: AppColors.primary),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('dd MMM yyyy').format(selectedStartDate),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12.0,
                          ),
                        ),
                        IconButton(
                            onPressed: () => _selectStartDate(context),
                            icon: const Icon(Icons.calendar_month,
                                color: AppColors.primary)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat('dd MMM yyyy').format(selectedEndDate),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12.0,
                          ),
                        ),
                        IconButton(
                            onPressed: () => _selectEndDate(context),
                            icon: const Icon(Icons.calendar_month,
                                color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
                const SpaceHeight(16.0),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Summary Report',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SpaceHeight(16.0),
                        buildPrice('Total Revenue',
                            getOfflineSummary()['totalOmzet'].toString()),
                        const SpaceHeight(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sold Items",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            Text(
                                "${getOfflineSummary()['totalTransaksi']} items",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                          ],
                        ),
                      ],
                    )),
                const SpaceHeight(16),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Product Sales',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SpaceHeight(16.0),
                      tableProductSales(getOfflineProductSalesTable()),
                    ],
                  ),
                ),
                const SpaceHeight(16.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Offline Sales Insights',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                const SpaceHeight(8.0),
                if (isLoadingOffline)
                  const Center(child: CircularProgressIndicator())
                else if (offlineOrders.isEmpty)
                  const Text('No offline order data.')
                else ...[
                  Card(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.07),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: _summaryItem(
                              'Omzet',
                              'Rp ${getOfflineSummary()['totalOmzet']}',
                              Icons.attach_money,
                              Colors.green,
                            ),
                          ),
                          Expanded(
                            child: _summaryItem(
                              'Transaksi',
                              getOfflineSummary()['totalTransaksi'].toString(),
                              Icons.receipt_long,
                              Colors.blue,
                            ),
                          ),
                          Expanded(
                            child: _summaryItem(
                              'Terlaris',
                              getOfflineSummary()['topProduct'],
                              Icons.star,
                              Colors.orange,
                            ),
                          ),
                          Expanded(
                            child: _summaryItem(
                              'Paling Ramai',
                              getOfflineSummary()['topDay'] +
                                  (getOfflineSummary()['topHour'] != null
                                      ? '\n${getOfflineSummary()['topHour']}:00'
                                      : ''),
                              Icons.access_time,
                              Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SpaceHeight(16.0),
                  Container(
                    height: 220,
                    padding: const EdgeInsets.all(8),
                    child: SfCartesianChart(
                      title:
                          ChartTitle(text: 'Top 5 Produk Terlaris (Offline)'),
                      primaryXAxis: CategoryAxis(),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries<Map<String, dynamic>, String>>[
                        BarSeries<Map<String, dynamic>, String>(
                          dataSource: getOfflineTopProductsBar(),
                          xValueMapper: (data, _) => data['name'] as String,
                          yValueMapper: (data, _) => data['qty'] as int,
                          color: Theme.of(context).colorScheme.primary,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                  const SpaceHeight(16.0),
                  Container(
                    height: 220,
                    padding: const EdgeInsets.all(8),
                    child: SfCartesianChart(
                      title: ChartTitle(text: 'Tren Omzet Offline per Hari'),
                      primaryXAxis: CategoryAxis(),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries<Map<String, dynamic>, String>>[
                        LineSeries<Map<String, dynamic>, String>(
                          dataSource: getOfflineOmzetTrend(),
                          xValueMapper: (data, _) => data['date'] as String,
                          yValueMapper: (data, _) => data['omzet'] as int,
                          name: 'Omzet',
                          markerSettings: const MarkerSettings(isVisible: true),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                  const SpaceHeight(16.0),
                  Container(
                    height: 220,
                    padding: const EdgeInsets.all(8),
                    child: SfCartesianChart(
                      title: ChartTitle(
                          text: 'Distribusi Transaksi per Jam (Offline)'),
                      primaryXAxis: CategoryAxis(
                        labelRotation: 90,
                        title: AxisTitle(text: 'Jam'),
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries<Map<String, dynamic>, String>>[
                        ColumnSeries<Map<String, dynamic>, String>(
                          dataSource: getOfflineTransactionsByHour(),
                          xValueMapper: (data, _) =>
                              data['hour'].toString().padLeft(2, '0'),
                          yValueMapper: (data, _) => data['count'] as int,
                          color: Theme.of(context).colorScheme.primary,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: false),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ));
  }

  Widget buildPrice(String title, String value) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: onSurface,
              ),
        ),
        Text(_toInt(value).currencyFormatRp,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: onSurface)),
      ],
    );
  }

  List<Widget> _getTitleHeaderWidget() {
    return [
      _getTitleItemWidget('No', 58),
      _getTitleItemWidget('ID', 58),
      _getTitleItemWidget('Product', 140),
      _getTitleItemWidget('Price', 140),
      _getTitleItemWidget('Quantity', 58),
      _getTitleItemWidget('Total', 140),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: 56,
      color: isDark
          ? Theme.of(context).colorScheme.primary.withOpacity(0.18)
          : Theme.of(context).colorScheme.primary,
      alignment: Alignment.centerLeft,
      child: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  } 

  Widget tableProductSales(List<Map<String, dynamic>> data) {
    const double itemHeight = 55.0;
    final double tableHeight = itemHeight * data.length;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: tableHeight + itemHeight,
        child: HorizontalDataTable(
          leftHandSideColumnWidth: 58,
          rightHandSideColumnWidth: 536,
          isFixedHeader: true,
          headerWidgets: _getTitleHeaderWidget(),
          leftSideItemBuilder: (context, index) {
            return Container(
              width: 58,
              height: 52,
              alignment: Alignment.centerLeft,
              child: Center(child: Text((index + 1).toString())),
            );
          },
          rightSideItemBuilder: (context, index) {
            final productSales = data[index];
            return Row(
              children: <Widget>[
                Container(
                  width: 58,
                  height: 52,
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Center(
                      child: Text(
                    productSales['productId'].toString(),
                  )),
                ),
                Container(
                  width: 140,
                  height: 52,
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Center(
                      child: Text(
                    productSales['productName'],
                  )),
                ),
                Container(
                  width: 140,
                  height: 52,
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Center(
                      child: Text(
                    _toInt(productSales['productPrice']).currencyFormatRp,
                  )),
                ),
                Container(
                  width: 58,
                  height: 52,
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Center(
                    child: Text(
                      productSales['totalQuantity'].toString(),
                    ),
                  ),
                ),
                Container(
                  width: 140,
                  height: 52,
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Center(
                    child: Text(
                      _toInt(productSales['totalPrice']).currencyFormatRp,
                    ),
                  ),
                ),
              ],
            );
          },
          itemCount: data.length,
          rowSeparatorWidget: const Divider(
            color: AppColors.black,
            height: 1.0,
            thickness: 0.0,
          ),
          leftHandSideColBackgroundColor: Theme.of(context).cardColor,
          rightHandSideColBackgroundColor: Theme.of(context).cardColor,
          itemExtent: 55,
        ),
      ),
    );
  }

  Widget _summaryItem(String title, String value, IconData icon, Color color) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: onSurface,
                )),
        const SizedBox(height: 2),
        Text(value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: onSurface,
                )),
      ],
    );
  }
}
