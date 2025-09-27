import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/components/spaces.dart';
import 'package:flutter_pos/core/utils/snackbar_utils.dart';
import 'package:flutter_pos/presentation/setting/bloc/discount/bloc/discount_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/discount_manage/discount_manage_cubit.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'add_discount_page.dart';
import 'edit_discount_page.dart';

class ManageDiscountPage extends StatefulWidget {
  const ManageDiscountPage({super.key});

  @override
  State<ManageDiscountPage> createState() => _ManageDiscountPageState();
}

class _ManageDiscountPageState extends State<ManageDiscountPage> {
  final _local = ProductLocalDatasource.instance;

  @override
  void initState() {
    super.initState();
    context.read<DiscountBloc>().add(const DiscountEvent.getDiscounts());
  }

  Future<void> _refresh() async {
    context.read<DiscountBloc>().add(const DiscountEvent.getDiscounts());
  }

  Future<void> _delete(int id) async {
    await context.read<DiscountManageCubit>().softDeleteLocal(id);
    SnackbarUtils(text: 'Discount marked for deletion (local)', backgroundColor: Colors.green).showSuccessSnackBar(context);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Discount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: BlocBuilder<DiscountBloc, DiscountState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (msg) => Center(child: Text(msg)),
              loaded: (responses) {
                // responses is List<DiscountResponseModel>; flatten
                final items = <dynamic>[];
                for (final r in responses) {
                  items.addAll(r.data);
                }
                if (items.isEmpty) {
                  return const Center(child: Text('No discounts'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (_, i) {
                    final d = items[i];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue.shade100, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(d.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SpaceHeight(4),
                          Text('${d.type.toString().toUpperCase()} • ${d.value}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SpaceHeight(8),
                          Row(
                            children: [
                              Text('Status: ${d.status}', style: const TextStyle(fontSize: 12)),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  final updated = await Navigator.push(context, MaterialPageRoute(builder: (_) => EditDiscountPage(discount: d)));
                                  if (updated is Map<String, dynamic>) {
                                    await _local.updateDiscountWithSyncFlag(id: d.id as int, payload: updated);
                                    SnackbarUtils(text: 'Discount updated locally', backgroundColor: Colors.green).showSuccessSnackBar(context);
                                    _refresh();
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Delete Discount'),
                                      content: Text('Are you sure to delete "${d.name}"?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    _delete(d.id as int);
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SpaceHeight(12),
                  itemCount: items.length,
                );
              },
              orElse: () => const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddDiscountPage())) as bool?;
          if (created == true) {
            _refresh();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
