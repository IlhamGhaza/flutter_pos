import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../data/datasources/order_local_datasource.dart';
import '../../data/datasources/product_local_datasource.dart';
import '../constants/db_config.dart';

Future<void> initializeDatabase({bool forceRecreate = false}) async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  if (forceRecreate) {
    await deleteLocalDatabase();
  }
  await OrderLocalDatasource.instance.database;
  await ProductLocalDatasource.instance.database;
  // Ensure tables exist by running a simple check
  await _ensureTablesExist();
}

Future<void> _ensureTablesExist({bool hasRecreated = false}) async {
  final db = await ProductLocalDatasource.instance.database;
  final tablesToCheck = [
    'products',
    'categories',
    'offline_orders',
    'offline_order_items',
    'discounts',
    'taxes',
    'service_charges',
    'customers',
    'draft_orders',
    'draft_order_items'
    //
  ];
  for (final table in tablesToCheck) {
    try {
      await db.rawQuery('SELECT 1 FROM $table LIMIT 1');
    } catch (e) {
      if (!hasRecreated) {
        await deleteLocalDatabase();
        await OrderLocalDatasource.instance.database;
        await ProductLocalDatasource.instance.database;
        await _ensureTablesExist(hasRecreated: true);
        return;
      } else {
        rethrow;
      }
    }
  }
}

Future<void> deleteLocalDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = dbPath + kDatabaseName;
  await deleteDatabase(path);
}

Future<void> createAllTables(Database db, int version) async {
  // Product tables
  await db.execute('''
    CREATE TABLE IF NOT EXISTS products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER,
      name TEXT,
      description TEXT,
      price INTEGER,
      stock INTEGER,
      category_id INTEGER,
      sku TEXT,
      unit_of_measure TEXT,
      expired_date TEXT,
      image TEXT,
      is_best_seller INTEGER,
      is_ready INTEGER,
      is_sync INTEGER DEFAULT 0,
      created_at TEXT,
      updated_at TEXT,
      deleted_at TEXT
    )
  ''');
  // Ensure offline sync columns exist for discounts
  try { await db.execute('ALTER TABLE discounts ADD COLUMN is_synced INTEGER DEFAULT 1'); } catch (_) {}
  try { await db.execute('ALTER TABLE discounts ADD COLUMN request_json TEXT'); } catch (_) {}
  await db.execute('''
    CREATE TABLE IF NOT EXISTS categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      category_id INTEGER NULLABLE,
      name TEXT
    )
  ''');
  // Ensure offline sync columns exist for categories
  try { await db.execute('ALTER TABLE categories ADD COLUMN deleted_at TEXT'); } catch (_) {}
  try { await db.execute('ALTER TABLE categories ADD COLUMN is_synced INTEGER DEFAULT 0'); } catch (_) {}
  try { await db.execute('ALTER TABLE categories ADD COLUMN request_json TEXT'); } catch (_) {}
  await db.execute('''
    CREATE TABLE IF NOT EXISTS discounts (
      id INTEGER PRIMARY KEY,
      name TEXT,
      description TEXT,
      type TEXT,
      value REAL,
      status TEXT,
      min_quantity REAL,
      max_quantity REAL,
      min_amount REAL,
      buy_quantity INTEGER,
      get_quantity INTEGER,
      quantity_tiers TEXT,
      apply_to TEXT,
      applicable_items TEXT,
      customer_type TEXT,
      valid_days TEXT,
      start_date TEXT,
      expired_date TEXT,
      start_time TEXT,
      end_time TEXT,
      combinable INTEGER,
      usage_limit INTEGER,
      usage_count INTEGER,
      created_at TEXT,
      updated_at TEXT,
      deleted_at TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS taxes (
      id INTEGER PRIMARY KEY,
      name TEXT,
      rate REAL,
      created_at TEXT,
      updated_at TEXT,
      deleted_at TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS service_charges (
      id INTEGER PRIMARY KEY,
      name TEXT,
      rate REAL,
      created_at TEXT,
      updated_at TEXT,
      deleted_at TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS customers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      phone_number TEXT,
      email TEXT,
      address TEXT,
      city TEXT,
      state TEXT,
      postal_code TEXT,
      customer_type TEXT,
      created_at TEXT,
      updated_at TEXT,
      deleted_at TEXT,
      is_synced INTEGER DEFAULT 0,
      request_json TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS draft_orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      total_item INTEGER,
      nominal INTEGER,
      transaction_time TEXT,
      table_number INTEGER,
      draft_name TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS draft_order_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      id_draft_order INTEGER,
      id_product INTEGER,
      quantity INTEGER,
      price INTEGER
    )
  ''');
  // Order tables
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
  await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_offline_orders_sync ON offline_orders(is_sync)');
  await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_offline_orders_customer ON offline_orders(customer_id)');
  await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_offline_order_items_order ON offline_order_items(order_id)');
  await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_offline_order_items_sync ON offline_order_items(is_synced)');
}
