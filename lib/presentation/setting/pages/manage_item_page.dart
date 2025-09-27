import 'package:flutter/material.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/menu_button.dart';
import '../../../core/components/spaces.dart';
import 'manage_product_page.dart';
import 'manage_category_page.dart';
import 'manage_discount_page.dart';

class ManageItemPage extends StatefulWidget {
  const ManageItemPage({super.key});

  @override
  State<ManageItemPage> createState() => _ManageItemPageState();
}

class _ManageItemPageState extends State<ManageItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Flexible(
                    child: MenuButton(
                      iconPath: Assets.images.manageProduct.path,
                      label: 'Setting Product',
                      onPressed: () => context.push(const ManageProductPage()),
                      isImage: true,
                    ),
                  ),
                  const SpaceWidth(15.0),
                  Flexible(
                    child: MenuButton(
                      iconPath: Assets.images.managePrinter.path,
                      label: 'Setting Category',
                      onPressed: () {
                        context.push(const ManageCategoryPage());
                      },
                      isImage: true,
                    ),
                  ),
                ],
              ),
            ),
            const SpaceHeight(20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Flexible(
                    child: MenuButton(
                      iconPath: Assets.images.manageProduct.path,
                      label: 'Setting Discount',
                      onPressed: (){
                        context.push(const ManageDiscountPage());
                      },
                      isImage: true,
                    ),
                  ),
                  const SpaceWidth(15.0),
                  // Flexible(
                  //   child: MenuButton(
                  //     iconPath: Assets.images.managePrinter.path,
                  //     label: 'Setting Category',
                  //     onPressed: () {
                  //       // context.push(const ManagePrinterPage());
                  //     },
                  //     isImage: false,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
