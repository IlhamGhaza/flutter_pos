import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pos/core/components/buttons.dart';
import 'package:flutter_pos/core/components/custom_text_field.dart';
import 'package:flutter_pos/core/components/image_picker_widget.dart';
import 'package:flutter_pos/core/components/spaces.dart';
import 'package:flutter_pos/core/extensions/string_ext.dart';
import 'package:flutter_pos/data/models/response/product_response_model.dart';

class EditProductPage extends StatefulWidget {
  final Product product;
  
  const EditProductPage({
    super.key,
    required this.product,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController stockController;
  File? imageFile;
  bool isBestSeller = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    priceController = TextEditingController(text: widget.product.price.toString());
    stockController = TextEditingController(text: widget.product.stock.toString());
    isBestSeller = widget.product.isBestSeller;
    
    // If product has an image, set it
    if (widget.product.image.isNotEmpty) {
      imageFile = File(widget.product.image);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Produk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          CustomTextField(
            controller: nameController,
            label: 'Nama Produk',
          ),
          const SpaceHeight(16.0),
          CustomTextField(
            controller: priceController,
            label: 'Harga',
            keyboardType: TextInputType.number,
          ),
          const SpaceHeight(16.0),
          ImagePickerWidget(
            label: 'Foto Produk',
            initialImage: widget.product.image,
            onChanged: (file) {
              setState(() {
                imageFile = file;
              });
            },
          ),
          const SpaceHeight(16.0),
          CustomTextField(
            controller: stockController,
            label: 'Stok',
            keyboardType: TextInputType.number,
          ),
          const SpaceHeight(16.0),
          Row(
            children: [
              Checkbox(
                value: isBestSeller,
                onChanged: (value) {
                  setState(() {
                    isBestSeller = value!;
                  });
                },
              ),
              const Text('Best Seller'),
            ],
          ),
          const SpaceHeight(24.0),
          Row(
            children: [
              Expanded(
                child: Button.outlined(
                  onPressed: () => Navigator.pop(context),
                  label: 'Batal',
                ),
              ),
              const SpaceWidth(16.0),
              Expanded(
                child: Button.filled(
                  onPressed: () {
                    // Update product with new data
                    final updatedProduct = widget.product.copyWith(
                      name: nameController.text,
                      price: double.parse(priceController.text),
                      stock: int.parse(stockController.text),
                      isBestSeller: isBestSeller,
                      // Update image path if a new image was selected
                      image: imageFile?.path ?? widget.product.image,
                    );
                    
                    // Return the updated product
                    Navigator.pop(context, updatedProduct);
                  },
                  label: 'Simpan Perubahan',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}