import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:flutter_pos/data/models/response/discount_response_model.dart';
import 'package:flutter_pos/presentation/setting/bloc/discount/bloc/discount_bloc.dart';
import 'package:flutter_pos/presentation/setting/pages/edit_discount_page.dart';

import '../../../core/components/spaces.dart';

class MenuDiscountItem extends StatelessWidget {
  final DiscountModel data;
  const MenuDiscountItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: data.isActive ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  data.status.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SpaceHeight(8.0),
          if (data.description.isNotEmpty) ...[
            Text(
              data.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SpaceHeight(8.0),
          ],
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Type: ${data.type.toUpperCase()}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Value: ${data.isPercentage ? '${data.value}%' : 'Rp ${data.value.toStringAsFixed(0)}'}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Apply to: ${data.applyTo}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Customer: ${data.customerType}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      context.push(EditDiscountPage(discount: data));
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      _showDeleteDialog(context);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Discount'),
          content: Text('Are you sure you want to delete "${data.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<DiscountBloc>().add(
                  DiscountEvent.deleteDiscount(data.id),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
