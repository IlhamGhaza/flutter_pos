import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/utils/connectivity_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_pos/presentation/setting/bloc/discount/bloc/discount_bloc.dart';
import 'package:flutter_pos/presentation/setting/pages/add_discount_page.dart';
import 'package:flutter_pos/data/models/response/discount_response_model.dart';

import '../../../core/components/spaces.dart';
import '../widgets/menu_discount_item.dart';
import '../bloc/sync_discount/sync_discount_bloc.dart';
import '../bloc/sync_discount/sync_discount_event.dart';
import '../bloc/sync_discount/sync_discount_state.dart';

class ManageDiscountPage extends StatefulWidget {
  const ManageDiscountPage({super.key});

  @override
  State<ManageDiscountPage> createState() => _ManageDiscountPageState();
}

class _ManageDiscountPageState extends State<ManageDiscountPage> {
  StreamSubscription<List<ConnectivityResult>>? _connSub;
  @override
  void initState() {
    super.initState();
    context.read<DiscountBloc>().add(const DiscountEvent.getDiscounts());
    // auto sync when online
    _connSub = ConnectivityUtils.connectivityStream.listen((results) async {
      final online = await ConnectivityUtils.isConnected();
      if (online && mounted) {
        context.read<SyncDiscountBloc>().add(const SyncDiscountEvent.sync());
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Manage Discount',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<SyncDiscountBloc, SyncDiscountState>(
        listener: (context, state) {
          state.maybeWhen(
            success: () {
              context.read<DiscountBloc>().add(const DiscountEvent.getDiscounts());
            },
            orElse: () {},
          );
        },
        child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          BlocBuilder<DiscountBloc, DiscountState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                loaded: (discountResponses) {
                  // Extract all discounts from all responses
                  List<DiscountModel> allDiscounts = [];
                  for (var response in discountResponses) {
                    allDiscounts.addAll(response.data);
                  }
                  
                  if (allDiscounts.isEmpty) {
                    return const Center(
                      child: Text(
                        'No discounts available',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allDiscounts.length,
                    separatorBuilder: (context, index) => const SpaceHeight(20.0),
                    itemBuilder: (context, index) => MenuDiscountItem(
                      data: allDiscounts[index],
                    ),
                  );
                },
                error: (message) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: $message',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<DiscountBloc>().add(
                              const DiscountEvent.getDiscounts(),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddDiscountPage();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}