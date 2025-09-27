import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_pos/data/datasources/discount_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/core/utils/connectivity_utils.dart';
import 'package:flutter_pos/data/models/request/discount_request_model.dart';
import 'package:flutter_pos/data/models/response/discount_response_model.dart';

part 'discount_event.dart';
part 'discount_state.dart';
part 'discount_bloc.freezed.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final DiscountRemoteDatasource discountRemoteDatasource;
  final ProductLocalDatasource local;

  DiscountBloc(this.discountRemoteDatasource, this.local)
      : super(const _Initial()) {
    on<_GetDiscounts>((event, emit) async {
      emit(const _Loading());
      try {
        // Local first
        final localDiscounts = await local.getAllDiscount();
        if (localDiscounts.isNotEmpty) {
          if (!emit.isDone) emit(_Loaded(localDiscounts));
          // Refresh from remote in background
          try {
            final remote = await discountRemoteDatasource.getDiscounts();
            if (!emit.isDone) emit(_Loaded(remote));
            // Save remote to local
            await ProductLocalDatasource.instance.insertAllDiscount(remote);
          } catch (_) {}
        } else {
          // If no local, fetch remote
          final remote = await discountRemoteDatasource.getDiscounts();
          if (!emit.isDone) emit(_Loaded(remote));
          await ProductLocalDatasource.instance.insertAllDiscount(remote);
        }
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });

    on<_GetTodayDiscounts>((event, emit) async {
      emit(const _Loading());
      try {
        final discounts = await discountRemoteDatasource.getTodayDiscounts();
        emit(_Loaded(discounts));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });

    on<_GetDiscountById>((event, emit) async {
      emit(const _Loading());
      try {
        final discount =
            await discountRemoteDatasource.getDiscountById(event.id);
        emit(_LoadedDetail(discount));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });

    on<_CreateDiscount>((event, emit) async {
      emit(const _Loading());
      try {
        final online = await ConnectivityUtils.isConnected();
        if (online) {
          final created = await discountRemoteDatasource.createDiscount(event.request);
          // Save to local
          await local.upsertDiscountLocal(created);
          emit(const _Success('Discount created successfully'));
        } else {
          // Create temp local discount with negative id
          final tempId = -DateTime.now().millisecondsSinceEpoch;
          final now = DateTime.now();
          final d = DiscountModel(
            id: tempId,
            name: event.request.name,
            description: event.request.description ?? '',
            type: event.request.type,
            value: event.request.value,
            minQuantity: event.request.minQuantity?.toDouble(),
            maxQuantity: event.request.maxQuantity?.toDouble(),
            minAmount: event.request.minAmount,
            buyQuantity: null,
            getQuantity: null,
            quantityTiers: null,
            applyTo: event.request.applyTo,
            applicableItems: null,
            customerType: event.request.customerType,
            combinable: event.request.combinable,
            usageLimit: null,
            usageCount: 0,
            status: event.request.status,
            startDate: event.request.startDate != null ? DateTime.parse(event.request.startDate!) : now,
            expiredDate: event.request.expiredDate != null ? DateTime.tryParse(event.request.expiredDate!) : null,
            startTime: event.request.startTime,
            endTime: event.request.endTime,
            createdAt: now,
            updatedAt: now,
            deletedAt: null,
            validDays: event.request.validDays ?? <int>[],
          );
          await local.upsertDiscountLocal(d);
          await local.enqueuePendingDiscount(
            action: 'create',
            payload: event.request.toMap(),
            localTempId: tempId,
          );
          emit(const _Success('Saved locally. Will sync when online.'));
        }
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });

    on<_DeleteDiscount>((event, emit) async {
      emit(const _Loading());
      try {
        final online = await ConnectivityUtils.isConnected();
        if (online) {
          await discountRemoteDatasource.deleteDiscount(event.id);
          await local.deleteDiscountLocal(event.id);
          emit(const _Success('Discount deleted successfully'));
        } else {
          // delete locally and enqueue
          await local.deleteDiscountLocal(event.id);
          await local.enqueuePendingDiscount(
            action: 'delete',
            payload: {'id': event.id},
          );
          emit(const _Success('Deleted locally. Will sync when online.'));
        }
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
  }
}
