import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/data/datasources/discount_remote_datasource.dart';

class SyncDiscountUploadState {
  final bool loading;
  final int syncedCount;
  final String? error;
  const SyncDiscountUploadState({this.loading = false, this.syncedCount = 0, this.error});
}

class SyncDiscountUploadCubit extends Cubit<SyncDiscountUploadState> {
  final ProductLocalDatasource _local;
  final DiscountRemoteDatasource _remote;

  SyncDiscountUploadCubit({
    ProductLocalDatasource? local,
    DiscountRemoteDatasource? remote,
  })  : _local = local ?? ProductLocalDatasource.instance,
        _remote = remote ?? DiscountRemoteDatasource(),
        super(const SyncDiscountUploadState());

  Future<void> sendPending() async {
    emit(const SyncDiscountUploadState(loading: true));
    int success = 0;
    try {
      final unsynced = await _local.getUnsyncedDiscounts();
      for (final row in unsynced) {
        final localTempId = row['id'] as int; // negative id
        final req = row['request_json'] as String?;
        if (req == null) continue;
        final map = json.decode(req) as Map<String, dynamic>;
        final serverId = await _remote.createDiscount(map);
        if (serverId != null) {
          await _local.updateDiscountServerId(localTempId: localTempId, serverId: serverId);
          success++;
        }
      }

      final deleted = await _local.getDeletedDiscounts();
      for (final row in deleted) {
        final id = row['id'] as int;
        if (id > 0) {
          final ok = await _remote.deleteDiscount(id);
          if (ok) {
            await _local.removeDiscountLocal(id);
            success++;
          }
        } else {
          // local-only discount, remove it
          await _local.removeDiscountLocal(id);
          success++;
        }
      }

      emit(SyncDiscountUploadState(loading: false, syncedCount: success));
    } catch (e) {
      emit(SyncDiscountUploadState(loading: false, syncedCount: success, error: e.toString()));
    }
  }
}
