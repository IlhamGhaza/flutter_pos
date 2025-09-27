import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/data/datasources/product_remote_datasource.dart';

class SyncCategoryUploadState {
  final bool loading;
  final int syncedCount;
  final String? error;
  const SyncCategoryUploadState({this.loading = false, this.syncedCount = 0, this.error});
}

class SyncCategoryUploadCubit extends Cubit<SyncCategoryUploadState> {
  final ProductLocalDatasource _local;
  final ProductRemoteDatasource _remote;

  SyncCategoryUploadCubit({
    ProductLocalDatasource? local,
    ProductRemoteDatasource? remote,
  })  : _local = local ?? ProductLocalDatasource.instance,
        _remote = remote ?? ProductRemoteDatasource(),
        super(const SyncCategoryUploadState());

  Future<void> sendPending() async {
    emit(const SyncCategoryUploadState(loading: true));
    int success = 0;
    try {
      // Create/rename
      final unsynced = await _local.getUnsyncedCategories();
      for (final row in unsynced) {
        final localId = row['id'] as int;
        final req = row['request_json'] as String?;
        if (req == null) continue;
        final map = json.decode(req) as Map<String, dynamic>;
        final name = map['name']?.toString() ?? '';
        final res = await _remote.addCategory(name);
        await res.fold((_) async {}, (serverId) async {
          await _local.updateCategoryServerId(localId: localId, serverId: serverId);
          success++;
        });
      }

      // Deletes
      final deleted = await _local.getDeletedCategories();
      for (final row in deleted) {
        final localId = row['id'] as int;
        final serverId = (row['category_id'] as int?) ?? 0;
        if (serverId > 0) {
          final delRes = await _remote.deleteCategory(serverId);
          delRes.fold((_) async {}, (_) async {
            await _local.removeCategoryLocal(localId);
            success++;
          });
        } else {
          // never synced to server, just remove local
          await _local.removeCategoryLocal(localId);
          success++;
        }
      }

      emit(SyncCategoryUploadState(loading: false, syncedCount: success));
    } catch (e) {
      emit(SyncCategoryUploadState(loading: false, syncedCount: success, error: e.toString()));
    }
  }

  Future<void> fetchFromServer() async {
    emit(const SyncCategoryUploadState(loading: true));
    try {
      final res = await _remote.getCategories();
      await res.fold((_) async {}, (model) async {
        await _local.insertAllCategories(model.data ?? []);
      });
      emit(const SyncCategoryUploadState(loading: false, syncedCount: 0));
    } catch (e) {
      emit(SyncCategoryUploadState(loading: false, error: e.toString()));
    }
  }
}
