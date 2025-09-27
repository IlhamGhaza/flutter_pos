import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/utils/connectivity_utils.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/data/datasources/product_remote_datasource.dart';
import 'package:flutter_pos/data/models/response/category_response_model.dart';
import 'package:flutter_pos/presentation/home/bloc/category/category_bloc.dart';

class ManageCategoryPage extends StatefulWidget {
  const ManageCategoryPage({super.key});

  @override
  State<ManageCategoryPage> createState() => _ManageCategoryPageState();
}

class _ManageCategoryPageState extends State<ManageCategoryPage> {
  final _local = ProductLocalDatasource.instance;
  final _remote = ProductRemoteDatasource();
  StreamSubscription<List<dynamic>>? _connSub; // dynamic to avoid plugin type mismatch

  @override
  void initState() {
    super.initState();
    // Load local first, then remote via CategoryBloc
    context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
    // Auto-sync pending when back online
    _connSub = ConnectivityUtils.connectivityStream.listen((_) async {
      final online = await ConnectivityUtils.isConnected();
      if (!mounted) return;
      if (online) {
        await _processPendingCategories();
        // Refresh categories from remote
        context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
      }
    });
  }

  @override
  void dispose() {
    _connSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Category'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await _processPendingCategories();
              if (!mounted) return;
              context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
            },
          )
        ],
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (categories) => _buildList(categories),
            loadedLocal: (categories) => _buildList(categories),
            error: (msg) => Center(child: Text('Error: $msg')),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildList(List<Category> categories) {
    if (categories.isEmpty) {
      return const Center(child: Text('No categories'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final c = categories[index];
        return ListTile(
          title: Text(c.name),
          subtitle: Text('ID: ${c.id}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditDialog(c),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteCategory(c),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
      itemCount: categories.length,
    );
  }

  Future<void> _showAddDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Category name'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
          ],
        );
      },
    );
    if (result == true) {
      final name = controller.text.trim();
      if (name.isEmpty) return;
      await _createCategory(name);
      if (!mounted) return;
      context.read<CategoryBloc>().add(const CategoryEvent.getCategoriesLocal());
    }
  }

  Future<void> _showEditDialog(Category c) async {
    final controller = TextEditingController(text: c.name);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Category name'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Update')),
          ],
        );
      },
    );
    if (result == true) {
      final name = controller.text.trim();
      if (name.isEmpty) return;
      await _updateCategory(c, name);
      if (!mounted) return;
      context.read<CategoryBloc>().add(const CategoryEvent.getCategoriesLocal());
    }
  }

  Future<void> _createCategory(String name) async {
    final online = await ConnectivityUtils.isConnected();
    if (online) {
      final createdEither = await _remote.createCategory(name);
      await createdEither.fold(
        (err) async {
          // fallback local
          final tempId = -DateTime.now().millisecondsSinceEpoch;
          await _local.upsertCategoryLocal(categoryId: tempId, name: name);
          await _local.enqueuePendingCategory(action: 'create', payload: {'name': name}, localTempId: tempId);
        },
        (created) async {
          await _local.upsertCategoryLocal(categoryId: created.id, name: created.name);
        },
      );
    } else {
      final tempId = -DateTime.now().millisecondsSinceEpoch;
      await _local.upsertCategoryLocal(categoryId: tempId, name: name);
      await _local.enqueuePendingCategory(action: 'create', payload: {'name': name}, localTempId: tempId);
    }
  }

  Future<void> _updateCategory(Category c, String name) async {
    // Local update
    await _local.upsertCategoryLocal(categoryId: c.id, name: name);
    // Enqueue update for future server sync (requires server endpoint)
    await _local.enqueuePendingCategory(action: 'update', payload: {'id': c.id, 'name': name});
  }

  Future<void> _deleteCategory(Category c) async {
    final online = await ConnectivityUtils.isConnected();
    if (online && c.id > 0) {
      final res = await _remote.deleteCategory(c.id);
      await res.fold(
        (err) async {
          // enqueue if server failed
          await _local.deleteCategoryLocal(c.id);
          await _local.enqueuePendingCategory(action: 'delete', payload: {'id': c.id});
        },
        (_) async {
          await _local.deleteCategoryLocal(c.id);
        },
      );
    } else {
      await _local.deleteCategoryLocal(c.id);
      await _local.enqueuePendingCategory(action: 'delete', payload: {'id': c.id});
    }
    if (!mounted) return;
    context.read<CategoryBloc>().add(const CategoryEvent.getCategoriesLocal());
  }

  Future<void> _processPendingCategories() async {
    final queue = await _local.getPendingCategoriesQueue();
    for (final row in queue) {
      try {
        final action = row['action'] as String;
        final payload = row['payload_json'] as String;
        final localTempId = row['local_temp_id'] as int?;
        final data = jsonDecode(payload) as Map<String, dynamic>;
        if (action == 'create') {
          final createdEither = await _remote.createCategory(data['name'] as String);
          await createdEither.fold((err) async {}, (created) async {
            if (localTempId != null) {
              await _local.deleteCategoryLocal(localTempId);
            }
            await _local.upsertCategoryLocal(categoryId: created.id, name: created.name);
          });
        } else if (action == 'delete') {
          final id = data['id'] as int;
          if (id > 0) {
            await _remote.deleteCategory(id);
          }
          await _local.deleteCategoryLocal(id);
        } else if (action == 'update') {
          // TODO: Add server update call when available
          // For now, local is already updated above.
        }
        await _local.removePendingCategoryById(row['id'] as int);
      } catch (_) {}
    }
  }
}
