import 'package:sqflite/sqflite.dart';
import 'package:flutter_pos/data/models/request/order_request_model.dart';
import 'package:flutter_pos/data/models/response/order_response_model.dart';

class OrderLocalDatasource {
  OrderLocalDatasource._init();
  static final OrderLocalDatasource instance = OrderLocalDatasource._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('orders.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS offline_orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_number TEXT,
        transaction_time TEXT NOT NULL,
        kasir_id INTEGER NOT NULL,
        kasir_name TEXT NOT NULL,
        customer_id INTEGER NOT NULL,
        customer_name TEXT NOT NULL,
        customer_order_notes TEXT,
        sub_total REAL NOT NULL,
        total_price REAL NOT NULL,
        total_item INTEGER NOT NULL,
        tax_id INTEGER,
        tax_rate REAL DEFAULT 0,
        tax_amount REAL DEFAULT 0,
        service_charge_id INTEGER,
        service_charge_rate REAL DEFAULT 0,
        service_charge REAL DEFAULT 0,
        discount_id INTEGER,
        discount_amount REAL DEFAULT 0,
        discount_type TEXT,
        discount_value REAL,
        payment_method TEXT NOT NULL,
        payment_amount REAL NOT NULL,
        change_amount REAL NOT NULL,
        order_type TEXT NOT NULL,
        status TEXT DEFAULT 'pending',
        is_sync INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        paid_at TEXT,
        midtrans_transaction_id TEXT,
        midtrans_order_id TEXT,
        payment_gateway_response TEXT,
        is_synced_from_mobile INTEGER DEFAULT 0,
        mobile_sync_validation_status TEXT,
        mobile_sync_notes TEXT,
        mobile_synced_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS offline_order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        product_name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        total_price REAL NOT NULL,
        is_synced INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        FOREIGN KEY (order_id) REFERENCES offline_orders (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better query performance
    await db.execute('CREATE INDEX IF NOT EXISTS idx_offline_orders_sync ON offline_orders(is_sync)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_offline_orders_customer ON offline_orders(customer_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_offline_order_items_order ON offline_order_items(order_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_offline_order_items_sync ON offline_order_items(is_synced)');
  }

  /// Save order to local database
  Future<int> saveOfflineOrder(OrderRequestModel order, {
    required String kasirName,
    required String customerName,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final orderNumber = 'OFFLINE-${DateTime.now().millisecondsSinceEpoch}';

    // Start a transaction
    return await db.transaction((txn) async {
      // Insert order
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
        'tax_rate': order.taxRate,
        'service_charge_id': order.serviceChargeId,
        'service_charge_rate': order.serviceChargeRate,
        'discount_id': order.discountId,
        'discount_amount': 0, // Will be calculated based on discount type
        'payment_method': order.paymentMethod,
        'payment_amount': order.paymentAmount,
        'change_amount': order.changeAmount,
        'order_type': order.orderType,
        'status': 'pending',
        'is_sync': 0,
        'created_at': now,
        'updated_at': now,
      });

      // Insert order items
      for (var item in order.orderItems) {
        await txn.insert('offline_order_items', {
          'order_id': orderId,
          'product_id': item.productId,
          'product_name': 'Product ${item.productId}', // Should be fetched from product table
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

  /// Get all unsynced orders with their items
  Future<List<Map<String, dynamic>>> getUnsyncedOrders() async {
    final db = await database;
    
    // Get all unsynced orders
    final orders = await db.query(
      'offline_orders',
      where: 'is_sync = ?',
      whereArgs: [0],
      orderBy: 'created_at ASC',
    );

    final List<Map<String, dynamic>> result = [];
    
    for (final order in orders) {
      // Get order items
      final items = await db.query(
        'offline_order_items',
        where: 'order_id = ? AND is_synced = ?',
        whereArgs: [order['id'], 0],
      );

      // Only include orders with unsynced items
      if (items.isNotEmpty) {
        result.add({
          'order': order,
          'items': items,
        });
      }
    }

    return result;
  }

  /// Update sync status for an order and its items
  Future<void> updateSyncStatus(int orderId, bool isSynced) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    await db.transaction((txn) async {
      // Update order sync status
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

      // Update order items sync status
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

  /// Delete orders that have been synced
  Future<int> deleteSyncedOrders() async {
    final db = await database;
    
    // First get the IDs of orders to be deleted
    final ordersToDelete = await db.query(
      'offline_orders',
      columns: ['id'],
      where: 'is_sync = ?',
      whereArgs: [1],
    );

    if (ordersToDelete.isEmpty) return 0;

    final orderIds = ordersToDelete.map((e) => e['id'] as int).toList();
    
    return await db.transaction((txn) async {
      // Delete order items first due to foreign key constraint
      await txn.delete(
        'offline_order_items',
        where: 'order_id IN (${List.filled(orderIds.length, '?').join(',')})',
        whereArgs: orderIds,
      );
      
      // Delete the orders
      return await txn.delete(
        'offline_orders',
        where: 'id IN (${List.filled(orderIds.length, '?').join(',')})',
        whereArgs: orderIds,
      );
    });
  }

  /// Check if there are any unsynced orders
  Future<bool> hasUnsyncedOrders() async {
    final db = await database;
    
    // First check if there are any unsynced orders
    final orderCount = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM offline_orders WHERE is_sync = 0',
    ));

    if ((orderCount ?? 0) > 0) return true;
    
    // Also check for unsynced order items
    final itemCount = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM offline_order_items WHERE is_synced = 0',
    ));

    return (itemCount ?? 0) > 0;
  }

  /// Get order by ID with its items
  Future<Map<String, dynamic>?> getOrderById(int orderId) async {
    final db = await database;
    
    // Get the order
    final orders = await db.query(
      'offline_orders',
      where: 'id = ?',
      whereArgs: [orderId],
      limit: 1,
    );

    if (orders.isEmpty) return null;

    // Get order items
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

  /// Update order status
  Future<int> updateOrderStatus(int orderId, String status) async {
    final db = await database;
    return await db.update(
      'offline_orders',
      {
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}
