import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:flutter_pos/core/components/spaces.dart';
import 'package:flutter_pos/core/utils/snackbar_utils.dart';
import 'package:flutter_pos/presentation/home/pages/dashboard_page.dart';
import 'package:flutter_pos/presentation/home/bloc/category/category_bloc.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'add_category_page.dart';
import 'edit_category_page.dart';

class ManageCategoryPage extends StatefulWidget {
  const ManageCategoryPage({super.key});

  @override
  State<ManageCategoryPage> createState() => _ManageCategoryPageState();
}

class _ManageCategoryPageState extends State<ManageCategoryPage> {
  final _local = ProductLocalDatasource.instance;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(const CategoryEvent.getCategoriesLocal());
  }

  Future<void> _refresh() async {
    context.read<CategoryBloc>().add(const CategoryEvent.getCategoriesLocal());
  }

  Future<void> _deleteCategory(int id) async {
    await _local.softDeleteCategoryByAnyId(id);
    SnackbarUtils(text: 'Category marked for deletion (local)', backgroundColor: Colors.green).showSuccessSnackBar(context);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.push(const DashboardPage()),
        ),
        title: const Text(
          'Manage Category',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (msg) => Center(child: Text(msg)),
              loaded: (data) => _buildList(data),
              loadedLocal: (data) => _buildList(data),
              orElse: () => const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddCategoryPage())) as bool?;
          if (created == true) {
            _refresh();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildList(List categories) {
    if (categories.isEmpty) {
      return const Center(child: Text('No categories'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final c = categories[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue.shade100, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    const SpaceHeight(4),
                    Text('ID: ${c.id}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete Category'),
                      content: Text('Are you sure to delete "${c.name}"?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    _deleteCategory(c.id);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final renamed = await Navigator.push(context, MaterialPageRoute(
                    builder: (_) => EditCategoryPage(categoryId: c.id, currentName: c.name),
                  )) as bool?;
                  if (renamed == true) {
                    _refresh();
                  }
                },
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) => const SpaceHeight(12),
      itemCount: categories.length,
    );
  }
}
