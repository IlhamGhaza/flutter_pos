import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_pos/data/datasources/discount_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';

import 'sync_discount_event.dart';
import 'sync_discount_state.dart';

class SyncDiscountBloc extends Bloc<SyncDiscountEvent, SyncDiscountState> {
  final DiscountRemoteDatasource _discountRemoteDatasource;
  
  SyncDiscountBloc(this._discountRemoteDatasource) : super(const SyncDiscountState.initial()) {
    on<SyncDiscountEvent>((event, emit) async {
      await event.when(
        sync: () async {
          emit(const SyncDiscountState.loading());
          try {
            // Get list of discount responses
            final responses = await _discountRemoteDatasource.getDiscounts();
            
            if (responses.isEmpty) {
              emit(const SyncDiscountState.success());
              return;
            }
            
            // Process all responses
            await ProductLocalDatasource.instance.insertAllDiscount(responses);
            emit(const SyncDiscountState.success());
          } catch (e) {
            log('Error syncing discounts: $e');
            emit(SyncDiscountState.error(e.toString()));
          }
        },
      );
    });
  }
}
