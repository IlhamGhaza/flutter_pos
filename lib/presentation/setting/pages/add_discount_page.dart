import 'package:flutter/material.dart';
import 'package:flutter_pos/core/components/custom_text_field.dart';
import 'package:flutter_pos/core/components/custom_dropdown.dart';
import 'package:flutter_pos/core/components/spaces.dart';
import 'package:flutter_pos/core/components/buttons.dart';
import 'package:flutter_pos/core/utils/snackbar_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/data/models/response/product_response_model.dart';
import 'package:flutter_pos/data/models/response/category_response_model.dart';
import 'package:flutter_pos/presentation/setting/bloc/discount_manage/discount_manage_cubit.dart';

class AddDiscountPage extends StatefulWidget {
  const AddDiscountPage({super.key});

  @override
  State<AddDiscountPage> createState() => _AddDiscountPageState();
}

class _AddDiscountPageState extends State<AddDiscountPage> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  final _minQtyCtrl = TextEditingController();
  final _maxQtyCtrl = TextEditingController();
  final _minAmountCtrl = TextEditingController();
  final _startDateCtrl = TextEditingController();
  final _endDateCtrl = TextEditingController();
  final _startTimeCtrl = TextEditingController();
  final _endTimeCtrl = TextEditingController();

  String _type = 'percentage';
  String _applyTo = 'all';
  String _customerType = 'all';
  bool _combinable = false;
  String _status = 'active';
  final Set<int> _validDays = <int>{};

  
  final List<int> _selectedCategoryIds = [];
  final List<int> _selectedProductIds = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _valueCtrl.dispose();
    _minQtyCtrl.dispose();
    _maxQtyCtrl.dispose();
    _minAmountCtrl.dispose();
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    _startTimeCtrl.dispose();
    _endTimeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split('T').first;
    }
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final h = picked.hour.toString().padLeft(2, '0');
      final m = picked.minute.toString().padLeft(2, '0');
      controller.text = '$h:$m:00';
    }
  }

  Future<void> _submit() async {
    if (_nameCtrl.text.trim().isEmpty) {
      SnackbarUtils(text: 'Name is required', backgroundColor: Colors.red).showErrorSnackBar(context);
      return;
    }
    if (_valueCtrl.text.trim().isEmpty) {
      SnackbarUtils(text: 'Value is required', backgroundColor: Colors.red).showErrorSnackBar(context);
      return;
    }

    final double? value = double.tryParse(_valueCtrl.text.trim());
    final double? minQty = _minQtyCtrl.text.trim().isEmpty ? null : double.tryParse(_minQtyCtrl.text.trim());
    final double? maxQty = _maxQtyCtrl.text.trim().isEmpty ? null : double.tryParse(_maxQtyCtrl.text.trim());
    final double? minAmount = _minAmountCtrl.text.trim().isEmpty ? null : double.tryParse(_minAmountCtrl.text.trim());

    if (value == null) {
      SnackbarUtils(text: 'Value must be a number', backgroundColor: Colors.red).showErrorSnackBar(context);
      return;
    }

    final Map<String, dynamic> payload = {
      'name': _nameCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'type': _type,
      'value': value,
      if (minQty != null) 'min_quantity': minQty,
      if (maxQty != null) 'max_quantity': maxQty,
      if (minAmount != null) 'min_amount': minAmount,
      'apply_to': _applyTo,
      'customer_type': _customerType,
      'combinable': _combinable,
      'status': _status,
      if (_startDateCtrl.text.isNotEmpty) 'start_date': _startDateCtrl.text,
      if (_endDateCtrl.text.isNotEmpty) 'expired_date': _endDateCtrl.text,
      if (_startTimeCtrl.text.isNotEmpty) 'start_time': _startTimeCtrl.text,
      if (_endTimeCtrl.text.isNotEmpty) 'end_time': _endTimeCtrl.text,
      if (_validDays.isNotEmpty) 'valid_days': _validDays.toList(),
    };

    // Add applicable items based on selection
    if (_applyTo == 'category' && _selectedCategoryIds.isNotEmpty) {
      payload['applicable_items'] = List<int>.from(_selectedCategoryIds);
    }
    if (_applyTo == 'product' && _selectedProductIds.isNotEmpty) {
      payload['applicable_items'] = List<int>.from(_selectedProductIds);
    }

    await context.read<DiscountManageCubit>().addLocal(payload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Discount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: BlocConsumer<DiscountManageCubit, DiscountManageState>(
        listener: (context, state) {
          if (state.success) {
            SnackbarUtils(text: 'Discount saved locally', backgroundColor: Colors.green).showSuccessSnackBar(context);
            Navigator.pop(context, true);
          } else if (state.error != null) {
            SnackbarUtils(text: state.error!, backgroundColor: Colors.red).showErrorSnackBar(context);
          }
        },
        builder: (context, state) {
          return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomTextField(controller: _nameCtrl, label: 'Name'),
          const SpaceHeight(12),
          CustomTextField(controller: _descCtrl, label: 'Description'),
          const SpaceHeight(12),
          CustomDropdown<String>(
            value: _type,
            items: const ['fixed', 'percentage'],
            label: 'Type',
            onChanged: (v) => setState(() => _type = v ?? 'percentage'),
          ),
          const SpaceHeight(12),
          CustomTextField(controller: _valueCtrl, label: 'Value', keyboardType: TextInputType.number),
          const SpaceHeight(12),
          CustomTextField(controller: _minQtyCtrl, label: 'Min Quantity', keyboardType: TextInputType.number),
          const SpaceHeight(12),
          CustomTextField(controller: _maxQtyCtrl, label: 'Max Quantity', keyboardType: TextInputType.number),
          const SpaceHeight(12),
          CustomTextField(controller: _minAmountCtrl, label: 'Min Amount', keyboardType: TextInputType.number),
          const SpaceHeight(12),
          CustomDropdown<String>(
            value: _applyTo,
            items: const ['all', 'category', 'product'],
            label: 'Apply To',
            onChanged: (v) => setState(() => _applyTo = v ?? 'all'),
          ),
          if (_applyTo == 'category') ...[
            const SpaceHeight(8),
            _CategoryMultiPicker(
              onPicked: (ids) {
                setState(() {
                  _selectedCategoryIds
                    ..clear()
                    ..addAll(ids);
                });
              },
            ),
          ]
          else if (_applyTo == 'product') ...[
            const SpaceHeight(8),
            _ProductMultiPicker(
              onPicked: (ids) {
                setState(() {
                  _selectedProductIds
                    ..clear()
                    ..addAll(ids);
                });
              },
            ),
          ],
          const SpaceHeight(12),
          CustomDropdown<String>(
            value: _customerType,
            items: const ['all', 'retail', 'wholesale', 'member'],
            label: 'Customer Type',
            onChanged: (v) => setState(() => _customerType = v ?? 'all'),
          ),
          const SpaceHeight(12),
          SwitchListTile(
            title: const Text('Combinable'),
            value: _combinable,
            onChanged: (v) => setState(() => _combinable = v),
          ),
          const SpaceHeight(12),
          CustomDropdown<String>(
            value: _status,
            items: const ['active', 'inactive'],
            label: 'Status',
            onChanged: (v) => setState(() => _status = v ?? 'active'),
          ),
          const SpaceHeight(12),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _startDateCtrl,
                  label: 'Start Date (YYYY-MM-DD)',
                  readOnly: true,
                  onTap: () => _pickDate(_startDateCtrl),
                ),
              ),
              const SpaceWidth(12),
              Expanded(
                child: CustomTextField(
                  controller: _endDateCtrl,
                  label: 'Expired Date (YYYY-MM-DD)',
                  readOnly: true,
                  onTap: () => _pickDate(_endDateCtrl),
                ),
              ),
            ],
          ),
          const SpaceHeight(12),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _startTimeCtrl,
                  label: 'Start Time (HH:MM:SS)',
                  readOnly: true,
                  onTap: () => _pickTime(_startTimeCtrl),
                ),
              ),
              const SpaceWidth(12),
              Expanded(
                child: CustomTextField(
                  controller: _endTimeCtrl,
                  label: 'End Time (HH:MM:SS)',
                  readOnly: true,
                  onTap: () => _pickTime(_endTimeCtrl),
                ),
              ),
            ],
          ),
          const SpaceHeight(12),
          const Text('Valid Days', style: TextStyle(fontWeight: FontWeight.w600)),
          const SpaceHeight(6),
          Wrap(
            spacing: 8,
            children: List.generate(7, (i) {
              final day = i + 1;
              final labels = const ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
              final selected = _validDays.contains(day);
              return FilterChip(
                label: Text(labels[i]),
                selected: selected,
                onSelected: (v) {
                  setState(() {
                    if (v) {
                      _validDays.add(day);
                    } else {
                      _validDays.remove(day);
                    }
                  });
                },
              );
            }),
          ),
          const SpaceHeight(24),
          Row(
            children: [
              Expanded(
                child: Button.outlined(
                  onPressed: () => Navigator.pop(context),
                  label: 'Cancel',
                  disabled: state.loading,
                ),
              ),
              const SpaceWidth(12),
              Expanded(
                child: state.loading
                    ? const Center(child: CircularProgressIndicator())
                    : Button.filled(
                        onPressed: _submit,
                        label: 'Save',
                        disabled: state.loading,
                      ),
              ),
            ],
          ),
          const SpaceHeight(8),
        ],
      );
        },
      ),
    );
  }
}

class _CategoryMultiPicker extends StatefulWidget {
  final ValueChanged<List<int>> onPicked;
  const _CategoryMultiPicker({required this.onPicked});

  @override
  State<_CategoryMultiPicker> createState() => _CategoryMultiPickerState();
}

class _CategoryMultiPickerState extends State<_CategoryMultiPicker> {
  final _local = ProductLocalDatasource.instance;
  final List<int> _selected = [];

  Future<List<Category>> _load() async {
    return await _local.getActiveLocalCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _load(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snapshot.data!;
        if (items.isEmpty) {
          return const Text('No categories available');
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Categories'),
            const SpaceHeight(8),
            Wrap(
              spacing: 8,
              children: items.map((c) {
                final selected = _selected.contains(c.id);
                return FilterChip(
                  label: Text(c.name),
                  selected: selected,
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        _selected.add(c.id);
                      } else {
                        _selected.remove(c.id);
                      }
                      widget.onPicked(_selected);
                    });
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _ProductMultiPicker extends StatefulWidget {
  final ValueChanged<List<int>> onPicked;
  const _ProductMultiPicker({required this.onPicked});

  @override
  State<_ProductMultiPicker> createState() => _ProductMultiPickerState();
}

class _ProductMultiPickerState extends State<_ProductMultiPicker> {
  final _local = ProductLocalDatasource.instance;
  final List<int> _selected = [];

  Future<List<Product>> _load() async {
    return await _local.getAllProduct();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _load(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snapshot.data!;
        if (items.isEmpty) {
          return const Text('No products available');
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Products'),
            const SpaceHeight(8),
            Wrap(
              spacing: 8,
              children: items.map((p) {
                final selected = _selected.contains(p.id);
                return FilterChip(
                  label: Text(p.name),
                  selected: selected,
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        _selected.add(p.id);
                      } else {
                        _selected.remove(p.id);
                      }
                      widget.onPicked(_selected);
                    });
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
