import 'package:flutter/material.dart';
import 'package:flutter_pos/core/components/custom_text_field.dart';
import 'package:flutter_pos/core/components/custom_dropdown.dart';
import 'package:flutter_pos/core/components/spaces.dart';
import 'package:flutter_pos/core/components/buttons.dart';
import 'package:flutter_pos/data/models/response/discount_response_model.dart';

class EditDiscountPage extends StatefulWidget {
  final DiscountModel discount;
  const EditDiscountPage({super.key, required this.discount});

  @override
  State<EditDiscountPage> createState() => _EditDiscountPageState();
}

class _EditDiscountPageState extends State<EditDiscountPage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _valueCtrl;
  String _type = 'percentage';
  String _status = 'active';

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.discount.name);
    _descCtrl = TextEditingController(text: widget.discount.description);
    _valueCtrl = TextEditingController(text: widget.discount.value.toString());
    _type = widget.discount.type;
    _status = widget.discount.status;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _valueCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Discount',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: ListView(
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
          CustomTextField(
              controller: _valueCtrl,
              label: 'Value',
              keyboardType: TextInputType.number),
          const SpaceHeight(12),
          CustomDropdown<String>(
            value: _status,
            items: const ['active', 'inactive'],
            label: 'Status',
            onChanged: (v) => setState(() => _status = v ?? 'active'),
          ),
          const SpaceHeight(24),
          Row(
            children: [
              Expanded(
                child: Button.outlined(
                  onPressed: () => Navigator.pop(context),
                  label: 'Cancel',
                ),
              ),
              const SpaceWidth(12),
              Expanded(
                child: Button.filled(
                  onPressed: () {
                    final updated = <String, dynamic>{
                      'name': _nameCtrl.text,
                      'description': _descCtrl.text,
                      'type': _type,
                      'value': double.tryParse(_valueCtrl.text) ?? widget.discount.value,
                      'status': _status,
                    };
                    Navigator.pop(context, updated);
                  },
                  label: 'Save Changes',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
