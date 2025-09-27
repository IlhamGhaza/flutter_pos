import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/models/request/discount_request_model.dart';
import 'package:flutter_pos/presentation/setting/bloc/discount/bloc/discount_bloc.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';
import '../../../core/utils/snackbar_utils.dart';

class AddDiscountPage extends StatefulWidget {
  const AddDiscountPage({super.key});

  @override
  State<AddDiscountPage> createState() => _AddDiscountPageState();
}

class _AddDiscountPageState extends State<AddDiscountPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController valueController;
  late TextEditingController minQuantityController;
  late TextEditingController maxQuantityController;
  late TextEditingController minAmountController;
  late TextEditingController startDateController;
  late TextEditingController expiredDateController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;

  // Dropdown values
  String selectedType = 'percentage';
  String selectedApplyTo = 'all';
  String selectedCustomerType = 'all';
  bool combinable = false;
  String selectedStatus = 'active';
  
  // Valid days selection
  List<int> selectedValidDays = [];
  final List<String> dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    valueController = TextEditingController();
    minQuantityController = TextEditingController();
    maxQuantityController = TextEditingController();
    minAmountController = TextEditingController();
    startDateController = TextEditingController();
    expiredDateController = TextEditingController();
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    valueController.dispose();
    minQuantityController.dispose();
    maxQuantityController.dispose();
    minAmountController.dispose();
    startDateController.dispose();
    expiredDateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
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
          'Add Discount',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<DiscountBloc, DiscountState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            success: (message) {
              SnackbarUtils(
                text: message,
                backgroundColor: Colors.green,
              ).showSuccessSnackBar(context);
              Navigator.pop(context);
              // Refresh discount list
              context.read<DiscountBloc>().add(const DiscountEvent.getDiscounts());
            },
            error: (message) {
              SnackbarUtils(
                text: message,
                backgroundColor: Colors.red,
              ).showErrorSnackBar(context);
            },
          );
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Basic Information
              CustomTextField(
                controller: nameController,
                label: 'Discount Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter discount name';
                  }
                  return null;
                },
              ),
              const SpaceHeight(16.0),
              
              CustomTextField(
                controller: descriptionController,
                label: 'Description (Optional)',
                // maxLines: 3,
              ),
              const SpaceHeight(16.0),

              // Type Selection
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Discount Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'fixed', child: Text('Fixed')),
                  DropdownMenuItem(value: 'percentage', child: Text('Percentage')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),
              const SpaceHeight(16.0),

              // Value
              CustomTextField(
                controller: valueController,
                label: selectedType == 'percentage' ? 'Percentage (%)' : 'Fixed Amount',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter discount value';
                  }
                  final numValue = double.tryParse(value);
                  if (numValue == null || numValue <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  if (selectedType == 'percentage' && numValue > 100) {
                    return 'Percentage cannot exceed 100%';
                  }
                  return null;
                },
              ),
              const SpaceHeight(16.0),

              // Apply To Selection
              DropdownButtonFormField<String>(
                value: selectedApplyTo,
                decoration: const InputDecoration(
                  labelText: 'Apply To',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(value: 'category', child: Text('Category')),
                  DropdownMenuItem(value: 'product', child: Text('Product')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedApplyTo = value!;
                  });
                },
              ),
              const SpaceHeight(16.0),

              // Customer Type Selection
              DropdownButtonFormField<String>(
                value: selectedCustomerType,
                decoration: const InputDecoration(
                  labelText: 'Customer Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(value: 'retail', child: Text('Retail')),
                  DropdownMenuItem(value: 'wholesale', child: Text('Wholesale')),
                  DropdownMenuItem(value: 'member', child: Text('Member')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCustomerType = value!;
                  });
                },
              ),
              const SpaceHeight(16.0),

              // Optional Fields
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: minQuantityController,
                      label: 'Min Quantity (Optional)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SpaceWidth(16.0),
                  Expanded(
                    child: CustomTextField(
                      controller: maxQuantityController,
                      label: 'Max Quantity (Optional)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SpaceHeight(16.0),

              CustomTextField(
                controller: minAmountController,
                label: 'Minimum Amount (Optional)',
                keyboardType: TextInputType.number,
              ),
              const SpaceHeight(16.0),

              // Date Range
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: startDateController,
                      // : 'Start Date (Optional)',
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          startDateController.text = date.toIso8601String().split('T')[0];
                        }
                      },
                    ),
                  ),
                  const SpaceWidth(16.0),
                  Expanded(
                    child: TextField(
                      controller: expiredDateController,
                      // label: 'End Date (Optional)',
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 1)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          expiredDateController.text = date.toIso8601String().split('T')[0];
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SpaceHeight(16.0),

              // Time Range
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: startTimeController,
                      // label: 'Start Time (Optional)',
                      readOnly: true,
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          startTimeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
                        }
                      },
                    ),
                  ),
                  const SpaceWidth(16.0),
                  Expanded(
                    child: TextFormField(
                      controller: endTimeController,
                      // label: 'End Time (Optional)',
                      readOnly: true,
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          endTimeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SpaceHeight(16.0),

              // Valid Days Selection
              const Text(
                'Valid Days (Optional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SpaceHeight(8.0),
              Wrap(
                spacing: 8.0,
                children: List.generate(7, (index) {
                  final dayValue = index + 1; // 1-7 for Monday-Sunday
                  final isSelected = selectedValidDays.contains(dayValue);
                  return FilterChip(
                    label: Text(dayNames[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedValidDays.add(dayValue);
                        } else {
                          selectedValidDays.remove(dayValue);
                        }
                      });
                    },
                  );
                }),
              ),
              const SpaceHeight(16.0),

              // Combinable Checkbox
              CheckboxListTile(
                title: const Text('Combinable with other discounts'),
                value: combinable,
                onChanged: (value) {
                  setState(() {
                    combinable = value ?? false;
                  });
                },
              ),
              const SpaceHeight(16.0),

              // Status Selection
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              ),
              const SpaceHeight(32.0),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: Button.outlined(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: 'Cancel',
                    ),
                  ),
                  const SpaceWidth(16.0),
                  Expanded(
                    child: BlocBuilder<DiscountBloc, DiscountState>(
                      builder: (context, state) {
                        return state.maybeWhen(
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          orElse: () => Button.filled(
                            onPressed: _submitForm,
                            label: 'Save Discount',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SpaceHeight(20.0),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final request = DiscountRequestModel(
        name: nameController.text,
        description: descriptionController.text.isEmpty ? null : descriptionController.text,
        type: selectedType,
        value: double.parse(valueController.text),
        minQuantity: minQuantityController.text.isEmpty ? null : int.tryParse(minQuantityController.text),
        maxQuantity: maxQuantityController.text.isEmpty ? null : int.tryParse(maxQuantityController.text),
        minAmount: minAmountController.text.isEmpty ? null : double.tryParse(minAmountController.text),
        applyTo: selectedApplyTo,
        customerType: selectedCustomerType,
        combinable: combinable,
        status: selectedStatus,
        startDate: startDateController.text.isEmpty ? null : startDateController.text,
        expiredDate: expiredDateController.text.isEmpty ? null : expiredDateController.text,
        startTime: startTimeController.text.isEmpty ? null : startTimeController.text,
        endTime: endTimeController.text.isEmpty ? null : endTimeController.text,
        validDays: selectedValidDays.isEmpty ? null : selectedValidDays,
      );

      context.read<DiscountBloc>().add(DiscountEvent.createDiscount(request));
    }
  }
}
