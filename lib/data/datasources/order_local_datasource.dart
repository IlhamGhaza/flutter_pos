import 'package:sqflite/sqflite.dart';
import 'package:flutter_pos/data/models/request/order_request_model.dart';
import 'package:flutter_pos/core/constants/db_config.dart';
import 'dart:developer';
import '../../core/utils/db_initializer.dart';

class OrderLocalDatasource {
  OrderLocalDatasource._init();
  static final OrderLocalDatasource instance = OrderLocalDatasource._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initDB(kDatabaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = dbPath + filePath;

      final db = await openDatabase(
        path,
        version: kDatabaseVersion,
        onCreate: (db, version) async {
          await createAllTables(db, version);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          await createAllTables(db, newVersion);
        },
      );
      return db;
    } catch (e) {
      log('Error initializing database: $e',
          name: 'OrderLocalDatasource',
          error: e,
          stackTrace: StackTrace.current);
      rethrow;
    }
  }

  Future<void> _createDB(Database db, int version) async {
    // Tidak perlu lagi, sudah digantikan oleh createAllTables
  }

  Future<int> saveOfflineOrder(
    OrderRequestModel order, {
    required String kasirName,
    required String customerName,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final orderNumber = 'OFFLINE-${DateTime.now().millisecondsSinceEpoch}';

    return await db.transaction((txn) async {
      final orderId = await txn.insert('offline_orders', {
        'order_number': orderNumber,
        'transaction_time': order.transactionTime,
        'kasir_id': order.kasirId,
        'kasir_name': kasirName,
        'customer_id': order.customerId,
        'customer_name': customerName,
        'customer_order_notes': order.customerOrderNotes,
        'sub_total': order.subTotal,
        'total_price': order.totalPrice,
        'total_item': order.totalItem,
        'tax_id': order.taxId,
        // 'tax_rate': order.taxRate,
        'service_charge_id': order.serviceChargeId,
        // 'service_charge_rate': order.serviceChargeRate,
        'discount_id': order.discountId,
        'discount_amount': 0,
        'payment_method': order.paymentMethod,
        'payment_amount': order.paymentAmount,
        'change_amount': order.changeAmount,
        'order_type': order.orderType,
        'status': 'pending',
        'is_sync': 0,
        'created_at': now,
        'updated_at': now,
      });

      for (var item in order.orderItems) {
        await txn.insert('offline_order_items', {
          'order_id': orderId,
          'product_id': item.productId,
          'product_name': 'Product ${item.productId}',
          'quantity': item.quantity,
          'price': item.price,
          'total_price': item.price * item.quantity,
          'is_synced': 0,
          'created_at': now,
        });
      }

      return orderId;
    });
  }

  Future<List<Map<String, dynamic>>> getUnsyncedOrders() async {
    final db = await database;

    final orders = await db.query(
      'offline_orders',
      where: 'is_sync = ?',
      whereArgs: [0],
      orderBy: 'created_at ASC',
    );

    final List<Map<String, dynamic>> result = [];

    for (final order in orders) {
      final items = await db.query(
        'offline_order_items',
        where: 'order_id = ? AND is_synced = ?',
        whereArgs: [order['id'], 0],
      );

      if (items.isNotEmpty) {
        result.add({
          'order': order,
          'items': items,
        });
      }
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getOrderHistory() async {
    final db = await database;

    try {
      final orders = await db.query(
        'offline_orders',
        orderBy: 'created_at DESC',
      );

      final List<Map<String, dynamic>> result = [];

      for (final order in orders) {
        final items = await db.query(
          'offline_order_items',
          where: 'order_id = ?',
          whereArgs: [order['id']],
        );

        result.add({
          'order': order,
          'items': items,
        });
      }

      return result;
    } catch (e) {
      log('Error getting order history: $e',
          name: 'OrderLocalDatasource',
          error: e,
          stackTrace: StackTrace.current);
      return [];
    }
  }

  Future<void> updateSyncStatus(int orderId, bool isSynced) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      await txn.update(
        'offline_orders',
        {
          'is_sync': isSynced ? 1 : 0,
          'updated_at': now,
          if (isSynced) 'mobile_synced_at': now,
        },
        where: 'id = ?',
        whereArgs: [orderId],
      );

      if (isSynced) {
        await txn.update(
          'offline_order_items',
          {
            'is_synced': 1,
            'updated_at': now,
          },
          where: 'order_id = ?',
          whereArgs: [orderId],
        );
      }
    });
  }

  Future<int> deleteSyncedOrders() async {
    final db = await database;

    final ordersToDelete = await db.query(
      'offline_orders',
      columns: ['id'],
      where: 'is_sync = ?',
      whereArgs: [1],
    );

    if (ordersToDelete.isEmpty) return 0;

    final orderIds = ordersToDelete.map((e) => e['id'] as int).toList();

    return await db.transaction((txn) async {
      await txn.delete(
        'offline_order_items',
        where: 'order_id IN (${List.filled(orderIds.length, '?').join(',')})',
        whereArgs: orderIds,
      );

      return await txn.delete(
        'offline_orders',
        where: 'id IN (${List.filled(orderIds.length, '?').join(',')})',
        whereArgs: orderIds,
      );
    });
  }

  Future<bool> hasUnsyncedOrders() async {
    final db = await database;

    final orderCount = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM offline_orders WHERE is_sync = 0',
    ));

    if ((orderCount ?? 0) > 0) return true;

    final itemCount = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM offline_order_items WHERE is_synced = 0',
    ));

    return (itemCount ?? 0) > 0;
  }

  Future<Map<String, dynamic>?> getOrderById(int orderId) async {
    final db = await database;

    final orders = await db.query(
      'offline_orders',
      where: 'id = ?',
      whereArgs: [orderId],
      limit: 1,
    );

    if (orders.isEmpty) return null;

    final items = await db.query(
      'offline_order_items',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );

    return {
      'order': orders.first,
      'items': items,
    };
  }

  /// Get all offline orders with their items
  Future<List<Map<String, dynamic>>> getAllOfflineOrders() async {
    final db = await database;

    // Get all orders
    final orders = await db.query(
      'offline_orders',
      orderBy: 'created_at DESC',
    );

    final List<Map<String, dynamic>> result = [];

    for (final order in orders) {
      // Get order items
      final items = await db.query(
        'offline_order_items',
        where: 'order_id = ?',
        whereArgs: [order['id']],
      );
      result.add({
        'order': order,
        'items': items,
      });
    }

    return result;
  }

  /// Get all offline orders with their items and product details (JOIN)
  Future<List<Map<String, dynamic>>>
      getAllOfflineOrdersWithProductJoin() async {
    final db = await database;

    // Get all orders
    final orders = await db.query(
      'offline_orders',
      orderBy: 'created_at DESC',
    );

    final List<Map<String, dynamic>> result = [];

    for (final order in orders) {
      // Join order items with products
      final items = await db.rawQuery('''
        SELECT oi.*, p.* FROM offline_order_items oi
        LEFT JOIN products p ON oi.product_id = p.product_id
        WHERE oi.order_id = ?
      ''', [order['id']]);
      result.add({
        'order': order,
        'items': items,
      });
    }

    return result;
  }
}
