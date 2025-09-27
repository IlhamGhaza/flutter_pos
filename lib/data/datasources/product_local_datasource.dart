import 'dart:developer';
import 'package:flutter_pos/data/models/response/product_response_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../presentation/home/models/draft_order_item.dart';
import '../../presentation/order/bloc/qris/models/draft_order_model.dart';
import '../models/response/category_response_model.dart';
import '../models/response/discount_response_model.dart';
import '../models/response/tax_response_model.dart';
import '../models/response/service_charge_response_model.dart';
import '../models/response/customer_response_model.dart';
import '../models/request/customer_request_model.dart';
import 'package:flutter_pos/core/constants/db_config.dart';
import 'dart:convert';
import '../../core/utils/db_initializer.dart';

class ProductLocalDatasource {
  ProductLocalDatasource._init();

  static final ProductLocalDatasource instance = ProductLocalDatasource._init();

  final String tableProducts = 'products';

  static Database? _database;

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;

    return await openDatabase(
      path,
      version: kDatabaseVersion, // Ambil dari config
      onCreate: (db, version) async {
        await createAllTables(db, version);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await createAllTables(db, newVersion);
      },
    );
  }

  // CATEGORY: offline-first helpers
  Future<void> saveCategoryWithSyncFlag(String name) async {
    final db = await database;
    await db.insert('categories', {
      'name': name,
      'is_synced': 0,
      'request_json': json.encode({'name': name}),
      'deleted_at': null,
    });
  }

  Future<List<Map<String, dynamic>>> getUnsyncedCategories() async {
    final db = await database;
    return await db.query('categories',
        where: 'is_synced = 0 AND request_json IS NOT NULL AND deleted_at IS NULL');
  }

  Future<List<Map<String, dynamic>>> getDeletedCategories() async {
    final db = await database;
    return await db.query('categories',
        where: 'is_synced = 0 AND deleted_at IS NOT NULL');
  }

  Future<void> updateCategorySyncStatus(int id, bool isSynced) async {
    final db = await database;
    await db.update('categories', {'is_synced': isSynced ? 1 : 0},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateCategoryServerId({
    required int localId,
    required int serverId,
  }) async {
    final db = await database;
    await db.update('categories', {
      'category_id': serverId,
      'is_synced': 1,
      'request_json': null,
    }, where: 'id = ?', whereArgs: [localId]);
  }

  Future<void> updateCategoryNameLocal({
    required int localId,
    required String newName,
  }) async {
    final db = await database;
    await db.update('categories', {
      'name': newName,
      'is_synced': 0,
      'request_json': json.encode({'name': newName}),
    }, where: 'id = ?', whereArgs: [localId]);
  }

  Future<void> softDeleteCategoryLocal(int id) async {
    final db = await database;
    await db.update('categories', {
      'deleted_at': DateTime.now().toIso8601String(),
      'is_synced': 0,
    }, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> removeCategoryLocal(int id) async {
    final db = await database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> softDeleteCategoryByAnyId(int anyId) async {
    final db = await database;
    await db.update(
      'categories',
      {
        'deleted_at': DateTime.now().toIso8601String(),
        'is_synced': 0,
      },
      where: 'id = ? OR category_id = ?',
      whereArgs: [anyId, anyId],
    );
  }

  Future<void> updateCategoryNameByAnyId({
    required int anyId,
    required String newName,
  }) async {
    final db = await database;
    await db.update(
      'categories',
      {
        'name': newName,
        'is_synced': 0,
        'request_json': json.encode({'name': newName}),
      },
      where: 'id = ? OR category_id = ?',
      whereArgs: [anyId, anyId],
    );
  }

  // Future<void> _createDB(Database db, int version) async {
  //   // Tidak perlu lagi, sudah digantikan oleh createAllTables
  // }

  // Customer methods
  Future<void> saveCustomer(CustomerResponseModel customer) async {
    final db = await database;
    await db.insert(
      'customers',
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> saveCustomers(List<CustomerResponseModel> customers) async {
    final db = await database;
    final batch = db.batch();
    for (final customer in customers) {
      batch.insert(
        'customers',
        customer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<CustomerResponseModel>> getAllCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'customers',
      where: 'deleted_at IS NULL',
    );
    return results.map((e) => CustomerResponseModel.fromMap(e)).toList();
  }

  Future<CustomerResponseModel?> getCustomerById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'customers',
      where: 'id = ? AND deleted_at IS NULL',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return CustomerResponseModel.fromMap(results.first);
    }
    return null;
  }

  Future<List<CustomerResponseModel>> searchCustomers(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'customers',
      where: '(name LIKE ? OR phone_number LIKE ?) AND deleted_at IS NULL',
      whereArgs: ['%$query%', '%$query%'],
    );
    return results.map((e) => CustomerResponseModel.fromMap(e)).toList();
  }

  // Insert all categories
  Future<void> insertAllCategories(List<Category> categories) async {
    final db = await instance.database;

    // Start a transaction to ensure atomicity
    await db.transaction((txn) async {
      try {
        // First, delete all existing categories
        await txn.delete('categories');

        // Then insert all new categories in a batch
        final batch = txn.batch();

        for (var category in categories) {
          batch.insert('categories', category.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }

        await batch.commit(noResult: true);
      } catch (e) {
        // If any error occurs, the transaction will be rolled back automatically
        rethrow;
      }
    });
  }

  // Insert all discounts from API responses
  Future<void> insertAllDiscount(List<DiscountResponseModel> responses) async {
    try {
      log('Starting to process ${responses.length} discount responses');
      if (responses.isEmpty) {
        log('No discount responses to process');
        return;
      }

      // Debug log the first response structure
      log('First response structure: ${responses.first.toMap().toString()}');

      final db = await database;
      final batch = db.batch();

      // Clear existing discounts
      await db.delete('discounts');

      int totalDiscounts = 0;

      // Process each response (should be just one response with all discounts in data array)
      for (final response in responses) {
        log('Processing response with ${response.data.length} discounts');
        if (response.data.isEmpty) {
          log('Warning: Response has no discount data');
          continue;
        }

        // Process all discounts in the data array of the response
        for (final discount in response.data) {
          log('Processing discount: ${discount.id} - ${discount.name}');

          batch.insert(
            'discounts',
            {
              'id': discount.id,
              'name': discount.name,
              'description': discount.description ?? '',
              'type': discount.type,
              'value': discount.value,
              'status': discount.status,
              'min_quantity': discount.minQuantity,
              'max_quantity': discount.maxQuantity,
              'min_amount': discount.minAmount,
              'buy_quantity': discount.buyQuantity,
              'get_quantity': discount.getQuantity,
              'quantity_tiers': discount.quantityTiers?.toString(),
              'apply_to': discount.applyTo,
              'applicable_items': discount.applicableItems?.join(','),
              'customer_type': discount.customerType,
              'valid_days': (discount.validDays ?? []).join(','),
              'start_date': discount.startDate.toIso8601String(),
              'expired_date': discount.expiredDate?.toIso8601String(),
              'start_time': discount.startTime,
              'end_time': discount.endTime,
              'combinable': discount.combinable ? 1 : 0,
              'usage_limit': discount.usageLimit,
              'usage_count': discount.usageCount ?? 0,
              'created_at': discount.createdAt.toIso8601String() ??
                  DateTime.now().toIso8601String(),
              'updated_at': discount.updatedAt.toIso8601String() ??
                  DateTime.now().toIso8601String(),
              'deleted_at': discount.deletedAt?.toIso8601String(),
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          totalDiscounts++;
          log('Queued discount for insertion: ${discount.id} - ${discount.name}');
        }
      }

      // Commit the batch
      log('Committing batch of $totalDiscounts discounts to database...');
      await batch.commit(noResult: true);
      log('Successfully saved $totalDiscounts discounts to local database');
    } catch (e, stackTrace) {
      log('Error saving discounts to local database',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> removeAllDiscount() async {
    final db = await instance.database;
    await db.delete('discounts');
  }

  //get all discounts
  Future<List<DiscountResponseModel>> getAllDiscount() async {
    final db = await instance.database;
    final result = await db.query('discounts');
    return result.map((e) => _discountFromMap(e)).toList();
  }

  // Offline-first discount helpers
  Future<int> saveDiscountWithSyncFlag(Map<String, dynamic> payload) async {
    final db = await database;
    // Use negative timestamp as temp local ID to avoid conflict with server IDs
    final tempId = -DateTime.now().millisecondsSinceEpoch;
    final map = {
      'id': tempId,
      'name': payload['name'] ?? '',
      'description': payload['description'] ?? '',
      'type': payload['type'] ?? 'percentage',
      'value': (payload['value'] as num?)?.toDouble() ?? 0.0,
      'status': payload['status'] ?? 'active',
      'min_quantity': (payload['min_quantity'] as num?)?.toDouble(),
      'max_quantity': (payload['max_quantity'] as num?)?.toDouble(),
      'min_amount': (payload['min_amount'] as num?)?.toDouble(),
      'buy_quantity': payload['buy_quantity'],
      'get_quantity': payload['get_quantity'],
      'quantity_tiers': payload['quantity_tiers']?.toString(),
      'apply_to': payload['apply_to'] ?? 'all',
      'applicable_items': (payload['applicable_items'] is List)
          ? (payload['applicable_items'] as List).join(',')
          : payload['applicable_items']?.toString(),
      'customer_type': payload['customer_type'] ?? 'all',
      'valid_days': (payload['valid_days'] is List)
          ? (payload['valid_days'] as List).join(',')
          : null,
      'start_date': payload['start_date'],
      'expired_date': payload['expired_date'],
      'start_time': payload['start_time'],
      'end_time': payload['end_time'],
      'combinable': (payload['combinable'] == true) ? 1 : 0,
      'usage_limit': payload['usage_limit'],
      'usage_count': 0,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'deleted_at': null,
      'is_synced': 0,
      'request_json': json.encode(payload),
    };
    await db.insert('discounts', map, conflictAlgorithm: ConflictAlgorithm.replace);
    return tempId;
  }

  Future<List<Map<String, dynamic>>> getUnsyncedDiscounts() async {
    final db = await database;
    return await db.query('discounts',
        where: 'is_synced = 0 AND request_json IS NOT NULL AND deleted_at IS NULL');
  }

  Future<void> updateDiscountWithSyncFlag({
    required int id,
    required Map<String, dynamic> payload,
  }) async {
    final db = await database;
    final map = {
      'name': payload['name'] ?? '',
      'description': payload['description'] ?? '',
      'type': payload['type'] ?? 'percentage',
      'value': (payload['value'] as num?)?.toDouble() ?? 0.0,
      'status': payload['status'] ?? 'active',
      'min_quantity': (payload['min_quantity'] as num?)?.toDouble(),
      'max_quantity': (payload['max_quantity'] as num?)?.toDouble(),
      'min_amount': (payload['min_amount'] as num?)?.toDouble(),
      'buy_quantity': payload['buy_quantity'],
      'get_quantity': payload['get_quantity'],
      'quantity_tiers': payload['quantity_tiers']?.toString(),
      'apply_to': payload['apply_to'] ?? 'all',
      'applicable_items': (payload['applicable_items'] is List)
          ? (payload['applicable_items'] as List).join(',')
          : payload['applicable_items']?.toString(),
      'customer_type': payload['customer_type'] ?? 'all',
      'valid_days': (payload['valid_days'] is List)
          ? (payload['valid_days'] as List).join(',')
          : null,
      'start_date': payload['start_date'],
      'expired_date': payload['expired_date'],
      'start_time': payload['start_time'],
      'end_time': payload['end_time'],
      'combinable': (payload['combinable'] == true) ? 1 : 0,
      'usage_limit': payload['usage_limit'],
      'updated_at': DateTime.now().toIso8601String(),
      'is_synced': 0,
      'request_json': json.encode(payload),
    };
    await db.update('discounts', map, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateDiscountServerId({
    required int localTempId,
    required int serverId,
  }) async {
    final db = await database;
    await db.update('discounts', {
      'id': serverId,
      'is_synced': 1,
      'request_json': null,
    }, where: 'id = ?', whereArgs: [localTempId]);
  }

  Future<void> softDeleteDiscountLocal(int id) async {
    final db = await database;
    await db.update('discounts', {
      'deleted_at': DateTime.now().toIso8601String(),
      'is_synced': 0,
    }, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getDeletedDiscounts() async {
    final db = await database;
    return await db.query('discounts',
        where: 'is_synced = 0 AND deleted_at IS NOT NULL');
  }

  Future<void> removeDiscountLocal(int id) async {
    final db = await database;
    await db.delete('discounts', where: 'id = ?', whereArgs: [id]);
  }

  DiscountResponseModel _discountFromMap(Map<String, dynamic> map) {
    return DiscountResponseModel(
      message: 'Discount loaded from local database',
      data: [
        DiscountModel(
          id: map['id'] as int,
          name: map['name'] as String? ?? 'Unknown Discount',
          description: map['description'] as String? ?? '',
          type: map['type'] as String? ?? 'percentage',
          value: (map['value'] as num?)?.toDouble() ?? 0.0,
          minQuantity: (map['min_quantity'] as num?)?.toDouble(),
          maxQuantity: (map['max_quantity'] as num?)?.toDouble(),
          minAmount: (map['min_amount'] as num?)?.toDouble(),
          buyQuantity: map['buy_quantity'] as int?,
          getQuantity: map['get_quantity'] as int?,
          quantityTiers: map['quantity_tiers'],
          applyTo: map['apply_to'] as String? ?? 'all',
          applicableItems: map['applicable_items'],
          customerType: map['customer_type'] as String? ?? 'all',
          combinable: (map['combinable'] as int?) == 1,
          usageLimit: map['usage_limit'] as int?,
          usageCount: (map['usage_count'] as int?) ?? 0,
          status: map['status'] as String? ?? 'inactive',
          startDate: map['start_date'] != null
              ? DateTime.parse(map['start_date'])
              : DateTime.now(),
          expiredDate: map['expired_date'] != null
              ? DateTime.tryParse(map['expired_date'])
              : null,
          startTime: map['start_time'] as String?,
          endTime: map['end_time'] as String?,
          createdAt: map['created_at'] != null
              ? DateTime.parse(map['created_at'])
              : DateTime.now(),
          updatedAt: map['updated_at'] != null
              ? DateTime.parse(map['updated_at'])
              : DateTime.now(),
          deletedAt: map['deleted_at'] != null
              ? DateTime.tryParse(map['deleted_at'])
              : null,
          validDays: (map['valid_days'] as String?)
                  ?.split(',')
                  .where((e) => e.isNotEmpty)
                  .map((e) => int.tryParse(e) ?? 0)
                  .toList() ??
              [],
        ),
      ],
      syncTime: DateTime.now().toUtc(),
      total: 1,
    );
  }

  //delete all categories
  Future<void> removeAllCategories() async {
    final db = await instance.database;
    await db.delete('categories');
  }

  //get all categories
  Future<List<Category>> getAllCategories() async {
    final db = await instance.database;
    final result = await db.query('categories');

    return result.map((e) => Category.fromLocal(e)).toList();
  }

  Future<List<Category>> getActiveLocalCategories() async {
    final db = await instance.database;
    final result = await db.query('categories', where: 'deleted_at IS NULL');
    return result.map((e) => Category.fromLocal(e)).toList();
  }

  //save draft order
  Future<int> saveDraftOrder(DraftOrderModel order) async {
    final db = await instance.database;
    int id = await db.insert('draft_orders', order.toMapForLocal());
    for (var orderItem in order.orders) {
      await db.insert('draft_order_items', orderItem.toMapForLocal(id));
    }
    return id;
  }

  //get all draft order
  Future<List<DraftOrderModel>> getAllDraftOrder() async {
    final db = await instance.database;
    final result = await db.query('draft_orders', orderBy: 'id ASC');

    List<DraftOrderModel> results = await Future.wait(result.map((item) async {
      // Your asynchronous operation here
      final draftOrderItem =
          await getDraftOrderItemByOrderId(item['id'] as int);
      return DraftOrderModel.newFromLocalMap(item, draftOrderItem);
    }));
    return results;
  }

  //get draft order item by id order
  Future<List<DraftOrderItem>> getDraftOrderItemByOrderId(int idOrder) async {
    final db = await instance.database;
    final result =
        await db.query('draft_order_items', where: 'id_draft_order = $idOrder');

    List<DraftOrderItem> results = await Future.wait(result.map((item) async {
      // Your asynchronous operation here
      final product = await getProductById(item['id_product'] as int);
      return DraftOrderItem(
          product: product!, quantity: item['quantity'] as int);
    }));
    return results;
  }

  //remove draft order by id
  Future<void> removeDraftOrderById(int id) async {
    final db = await instance.database;
    await db.delete('draft_orders', where: 'id = ?', whereArgs: [id]);
    await db.delete('draft_order_items',
        where: 'id_draft_order = ?', whereArgs: [id]);
  }

  /// Removes a draft order by its ID.
  /// This is a convenience method that wraps [removeDraftOrderById]
  /// to maintain backward compatibility with existing code.
  Future<void> removeDraftOrder(int? id) async {
    if (id != null) {
      await removeDraftOrderById(id);
    }
  }

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initDB(kDatabaseName);
    return _database!;
  }

  //remove all data product
  Future<void> removeAllProduct() async {
    final db = await instance.database;
    await db.delete(tableProducts);
  }

  Future<void> insertAllProducts(List<Product> products) async {
    final db = await instance.database;
    final batch = db.batch();

    // First, clear existing products
    await removeAllProduct();

    // Then insert all new products
    for (final product in products) {
      batch.insert(
        tableProducts,
        {
          'product_id': product.id,
          'name': product.name,
          'description': product.description ?? '',
          'price': product.price,
          'stock': product.stock,
          'category_id': product.categoryId,
          'sku': product.sku,
          'unit_of_measure': product.unitOfMeasure,
          'expired_date': product.expiredDate?.toIso8601String(),
          'image': product.image,
          'is_best_seller': product.isBestSeller ? 1 : 0,
          'is_ready': product.isReady ? 1 : 0,
          'is_sync': 1,
          'created_at': product.createdAt.toIso8601String(),
          'updated_at': product.updatedAt.toIso8601String(),
          'deleted_at': null,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  //insert data product from list product
  Future<void> insertAllProduct(List<Product> products) async {
    final db = await instance.database;

    // Start a transaction to ensure atomicity
    await db.transaction((txn) async {
      try {
        // First, delete all existing products
        await txn.delete(tableProducts);

        // Then insert all new products in a batch
        final batch = txn.batch();

        for (var product in products) {
          final map = product.toLocalMap();
          // Ensure all required fields are present
          map['product_id'] = product.id ?? 0;
          map['is_best_seller'] = product.isBestSeller ? 1 : 0;
          map['is_ready'] = product.isReady ? 1 : 0;
          map['is_sync'] = 1;
          map['created_at'] = product.createdAt.toIso8601String();
          map['updated_at'] = product.updatedAt.toIso8601String();
          map['deleted_at'] = null;

          batch.insert(tableProducts, map,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }

        await batch.commit(noResult: true);
      } catch (e) {
        // If any error occurs, the transaction will be rolled back automatically
        rethrow;
      }
    });
  }

  //insert data product
  Future<Product> insertProduct(Product product) async {
    try {
      final db = await instance.database;
      final map = product.toLocalMap();
      // Ensure all required fields are present
      map['product_id'] = product.id ?? 0;
      map['is_best_seller'] = product.isBestSeller ? 1 : 0;
      map['is_ready'] = product.isReady ? 1 : 0;
      map['created_at'] = product.createdAt.toIso8601String();
      map['updated_at'] = product.updatedAt.toIso8601String();
      map['deleted_at'] = null;

      final id = await db.insert(tableProducts, map);
      return product.copyWith(id: id);
    } catch (e) {
      // Handle database schema changes by recreating the table
      await _database?.close();
      _database = null;
      final db = await instance.database;
      final map = product.toLocalMap();
      map['product_id'] = product.id ?? 0;
      map['is_best_seller'] = product.isBestSeller ? 1 : 0;
      map['is_ready'] = product.isReady ? 1 : 0;
      map['created_at'] = product.createdAt.toIso8601String();
      map['updated_at'] = product.updatedAt.toIso8601String();
      map['deleted_at'] = null;

      final id = await db.insert(tableProducts, map);
      return product.copyWith(id: id);
    }
  }

  //get all data product
  Future<List<Product>> getAllProduct() async {
    try {
      final db = await instance.database;
      final result = await db.query(tableProducts);

      return result.map((e) => Product.fromMap(e)).toList();
    } catch (e) {
      // Handle database schema changes by recreating the table
      await _database?.close();
      _database = null;
      final db = await instance.database;
      final result = await db.query(tableProducts);
      return result.map((e) => Product.fromMap(e)).toList();
    }
  }

  //get product by id
  Future<Product?> getProductById(int id) async {
    try {
      final db = await instance.database;
      final result = await db.query(
        tableProducts,
        where: 'product_id = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) {
        return null;
      }

      return Product.fromMap(result.first);
    } catch (e) {
      // Handle database schema changes by recreating the table
      await _database?.close();
      _database = null;
      final db = await instance.database;
      final result = await db.query(
        tableProducts,
        where: 'product_id = ?',
        whereArgs: [id],
      );
      return result.isEmpty ? null : Product.fromMap(result.first);
    }
  }

  //insert all taxes
  Future<void> insertAllTax(List<TaxResponseModel> taxes) async {
    final db = await instance.database;
    await db.delete('taxes');
    final batch = db.batch();
    for (var tax in taxes) {
      batch.insert('taxes', _taxToMap(tax));
    }
    await batch.commit(noResult: true);
  }

  //delete all taxes
  Future<void> removeAllTax() async {
    final db = await instance.database;
    await db.delete('taxes');
  }

  //get all taxes
  Future<List<TaxResponseModel>> getAllTax() async {
    final db = await instance.database;
    final result = await db.query('taxes');
    return result.map((e) => _taxFromMap(e)).toList();
  }

  Map<String, dynamic> _taxToMap(TaxResponseModel t) => {
        'id': t.id,
        'name': t.name,
        'rate': t.rate,
        'created_at': t.createdAt?.toIso8601String(),
        'updated_at': t.updatedAt?.toIso8601String(),
        'deleted_at': t.deletedAt?.toIso8601String(),
      };

  TaxResponseModel _taxFromMap(Map<String, dynamic> map) {
    return TaxResponseModel(
      id: map['id'] as int,
      name: map['name'] as String,
      rate: (map['rate'] as num?)?.toDouble() ?? 0.0,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null,
      deletedAt: map['deleted_at'] != null
          ? DateTime.tryParse(map['deleted_at'])
          : null,
    );
  }

  //insert all service charges
  Future<void> insertAllServiceCharge(
      List<ServiceChargeResponseModel> charges) async {
    final db = await instance.database;
    await db.delete('service_charges');
    final batch = db.batch();
    for (var charge in charges) {
      batch.insert('service_charges', _serviceChargeToMap(charge));
    }
    await batch.commit(noResult: true);
  }

  //delete all service charges
  Future<void> removeAllServiceCharge() async {
    final db = await instance.database;
    await db.delete('service_charges');
  }

  //get all service charges
  Future<List<ServiceChargeResponseModel>> getAllServiceCharge() async {
    final db = await instance.database;
    final result = await db.query('service_charges');
    return result.map((e) => _serviceChargeFromMap(e)).toList();
  }

  Map<String, dynamic> _serviceChargeToMap(ServiceChargeResponseModel s) => {
        'id': s.id,
        'name': s.name,
        'rate': s.rate,
        'created_at': s.createdAt?.toIso8601String(),
        'updated_at': s.updatedAt?.toIso8601String(),
        'deleted_at': s.deletedAt?.toIso8601String(),
      };

  ServiceChargeResponseModel _serviceChargeFromMap(Map<String, dynamic> map) {
    return ServiceChargeResponseModel(
      id: map['id'] as int,
      name: map['name'] as String,
      rate: (map['rate'] as num?)?.toDouble() ?? 0.0,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null,
      deletedAt: map['deleted_at'] != null
          ? DateTime.tryParse(map['deleted_at'])
          : null,
    );
  }

  //insert all customers
  Future<void> insertAllCustomer(List<CustomerResponseModel> customers) async {
    final db = await instance.database;
    // Hanya hapus customer yang sudah tersinkronisasi (is_synced=1), biarkan yang offline tetap ada
    await db.delete('customers', where: 'is_synced = 1');
    final batch = db.batch();
    for (var c in customers) {
      batch.insert('customers', _customerToMap(c),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  //delete all customers
  Future<void> removeAllCustomer() async {
    final db = await instance.database;
    await db.delete('customers');
  }

  //get all customers
  Future<List<CustomerResponseModel>> getAllCustomer() async {
    final db = await instance.database;
    final result = await db.query('customers');
    return result.map((e) => _customerFromMap(e)).toList();
  }

  // Get unsynced customers (is_synced = 0 and request_json IS NOT NULL)
  Future<List<CustomerResponseModel>> getUnsyncedCustomers() async {
    final db = await instance.database;
    final result = await db.query('customers',
        where: 'is_synced = 0 AND request_json IS NOT NULL');
    return result.map((e) => _customerFromMap(e)).toList();
  }

  // Hapus customer lokal yang tidak valid (is_synced = 0 dan request_json IS NULL)
  Future<void> removeInvalidUnsyncedCustomers() async {
    final db = await instance.database;
    await db.delete('customers',
        where: 'is_synced = 0 AND request_json IS NULL');
  }

  // Update customer sync status
  Future<void> updateCustomerSyncStatus(int id, bool isSynced) async {
    final db = await instance.database;
    await db.update('customers', {'is_synced': isSynced ? 1 : 0},
        where: 'id = ?', whereArgs: [id]);
  }

  // Save customer with sync flag (request is required for offline customer)
  Future<void> saveCustomerWithSyncFlag(CustomerResponseModel customer,
      {required CustomerRequestModel request, bool isSynced = false}) async {
    final db = await instance.database;
    final map = _customerToMap(customer);
    map['is_synced'] = isSynced ? 1 : 0;
    map['request_json'] =
        request.toJson() != null ? json.encode(request.toJson()) : null;
    await db.insert('customers', map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Map<String, dynamic> _customerToMap(CustomerResponseModel c) => {
        'id': c.id,
        'name': c.name,
        'phone_number': c.phoneNumber,
        'email': c.email,
        'address': c.address,
        'city': c.city,
        'state': c.state,
        'postal_code': c.postalCode,
        'customer_type': c.customerType,
        'created_at': c.createdAt?.toIso8601String(),
        'updated_at': c.updatedAt?.toIso8601String(),
        'deleted_at': c.deletedAt?.toIso8601String(),
        'request_json': c.requestJson,
      };

  CustomerResponseModel _customerFromMap(Map<String, dynamic> map) {
    return CustomerResponseModel(
      id: map['id'] as int,
      name: map['name'] as String,
      phoneNumber: map['phone_number'] as String? ?? '',
      email: map['email'] as String? ?? '',
      address: map['address'] as String? ?? '',
      city: map['city'] as String? ?? '',
      state: map['state'] as String? ?? '',
      postalCode: map['postal_code'] as String? ?? '',
      customerType: map['customer_type'] as String? ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null,
      deletedAt: map['deleted_at'] != null
          ? DateTime.tryParse(map['deleted_at'])
          : null,
      requestJson: map['request_json'] as String?,
    );
  }

  // Update discount usage count
  Future<void> updateDiscountUsageCount(
      int discountId, int newUsageCount) async {
    final db = await instance.database;
    await db.update(
      'discounts',
      {'usage_count': newUsageCount},
      where: 'id = ?',
      whereArgs: [discountId],
    );
  }

  // Update all offline orders with old customer_id to new customer_id (server)
  Future<void> updateOfflineOrdersCustomerId({
    required int oldCustomerId,
    required int newCustomerId,
  }) async {
    final db = await instance.database;
    await db.update(
      'offline_orders',
      {'customer_id': newCustomerId},
      where: 'customer_id = ?',
      whereArgs: [oldCustomerId],
    );
  }
}
