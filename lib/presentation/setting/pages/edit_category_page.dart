import 'package:flutter/material.dart';
import 'package:flutter_pos/core/components/custom_text_field.dart';
import 'package:flutter_pos/core/components/spaces.dart';
import 'package:flutter_pos/core/components/buttons.dart';
import 'package:flutter_pos/core/utils/snackbar_utils.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';

class EditCategoryPage extends StatefulWidget {
  final int categoryId; // can be local id or server id
  final String currentName;
  const EditCategoryPage({super.key, required this.categoryId, required this.currentName});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final _nameCtrl = TextEditingController();
  final _local = ProductLocalDatasource.instance;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.currentName;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      SnackbarUtils(text: 'Name is required', backgroundColor: Colors.red).showErrorSnackBar(context);
      return;
    }
    setState(() => _saving = true);
    await _local.updateCategoryNameByAnyId(anyId: widget.categoryId, newName: _nameCtrl.text.trim());
    setState(() => _saving = false);
    SnackbarUtils(text: 'Category updated locally', backgroundColor: Colors.green).showSuccessSnackBar(context);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: ListView(
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
                  disabled: _saving,
                ),
              ),
              const SpaceWidth(12),
              Expanded(
                child: _saving
                    ? const Center(child: CircularProgressIndicator())
                    : Button.filled(
                        onPressed: _save,
                        label: 'Save Changes',
                        disabled: _saving,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
