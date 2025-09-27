import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_pos/data/datasources/discount_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/data/models/request/discount_request_model.dart';
import 'package:flutter_pos/data/models/response/discount_response_model.dart';

import 'sync_discount_event.dart';
import 'sync_discount_state.dart';

class SyncDiscountBloc extends Bloc<SyncDiscountEvent, SyncDiscountState> {
  final DiscountRemoteDatasource _discountRemoteDatasource;
  final ProductLocalDatasource _local;

  SyncDiscountBloc(this._discountRemoteDatasource, this._local)
      : super(const SyncDiscountState.initial()) {
    on<SyncDiscountEvent>((event, emit) async {
      await event.when(
        sync: () async {
          emit(const SyncDiscountState.loading());
          try {
            // First process pending queue
            final pending = await _local.getPendingDiscountsQueue();
            for (final row in pending) {
              try {
                final action = row['action'] as String;
                final payloadJson = row['payload_json'] as String;
                final localTempId = row['local_temp_id'] as int?;
                final payload =
                    json.decode(payloadJson) as Map<String, dynamic>;
                if (action == 'create') {
                  final req = DiscountRequestModel(
                    name: payload['name'],
                    description: payload['description'],
                    type: payload['type'],
                    value: (payload['value'] as num).toDouble(),
                    minQuantity: payload['min_quantity'],
                    maxQuantity: payload['max_quantity'],
                    minAmount: (payload['min_amount'] as num?)?.toDouble(),
                    applyTo: payload['apply_to'],
                    customerType: payload['customer_type'],
                    combinable: payload['combinable'] == true ||
                        payload['combinable'] == 1,
                    status: payload['status'] ?? 'active',
                    startDate: payload['start_date'],
                    expiredDate: payload['expired_date'],
                    startTime: payload['start_time'],
                    endTime: payload['end_time'],
                    validDays: (payload['valid_days'] as List?)
                        ?.map((e) => e as int)
                        .toList(),
                  );
                  final created =
                      await _discountRemoteDatasource.createDiscount(req);
                  // replace local temp with server
                  if (localTempId != null) {
                    await _local.deleteDiscountLocal(localTempId);
                  }
                  await _local.upsertDiscountLocal(created);
                } else if (action == 'delete') {
                  final id = payload['id'] as int;
                  await _discountRemoteDatasource.deleteDiscount(id);
                  await _local.deleteDiscountLocal(id);
                }
                await _local.removePendingDiscountById(row['id'] as int);
              } catch (e) {
                log('Error processing pending discount row: $e',
                    name: 'SyncDiscountBloc', stackTrace: StackTrace.current);
              }
            }

            // Get list of discount responses after processing queue
            final responses = await _discountRemoteDatasource.getDiscounts();

            if (responses.isEmpty) {
              emit(const SyncDiscountState.success());
              return;
            }

            // Process all responses
            await _local.insertAllDiscount(responses);
            emit(const SyncDiscountState.success());
          } catch (e) {
            log('Error syncing discounts: $e',
                name: 'SyncDiscountBloc', stackTrace: StackTrace.current);
            emit(SyncDiscountState.error(e.toString()));
          }
        },
      );
    });
  }
}
