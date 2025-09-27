import 'package:flutter/material.dart';
import 'package:flutter_pos/core/components/custom_text_field.dart';
import 'package:flutter_pos/core/components/spaces.dart';
import 'package:flutter_pos/core/utils/snackbar_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/category_manage/category_manage_cubit.dart';
import '../../../core/components/buttons.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameCtrl.text.trim().isEmpty) {
      SnackbarUtils(text: 'Name is required', backgroundColor: Colors.red).showErrorSnackBar(context);
      return;
    }
    await context.read<CategoryManageCubit>().addLocal(_nameCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: BlocConsumer<CategoryManageCubit, CategoryManageState>(
        listener: (context, state) {
          if (state.success) {
            SnackbarUtils(text: 'Category saved locally', backgroundColor: Colors.green).showSuccessSnackBar(context);
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
            ],
          );
        },
      ),
    );
  }
}
