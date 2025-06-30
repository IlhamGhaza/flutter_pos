import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:flutter_pos/presentation/draft_order/pages/draft_order_page.dart';
import 'package:flutter_pos/presentation/home/bloc/product/product_bloc.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/menu_button.dart';
import '../../../core/components/search_input.dart';
import '../../../core/components/spaces.dart';
import '../../../core/utils/connectivity_utils.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../bloc/category/category_bloc.dart';
import '../widgets/product_card.dart';
import '../widgets/product_empty.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  final indexValue = ValueNotifier(0);
  int currentIndex = 0;
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    // Fetch products from local storage
    context.read<ProductBloc>().add(const ProductEvent.fetchLocal());
    // Fetch categories from local storage
    context.read<CategoryBloc>().add(const CategoryEvent.getCategoriesLocal());
    
    // Initialize printer connection if available
    AuthLocalDatasource().getPrinter().then((value) async {
      if (value.isNotEmpty) {
        await PrintBluetoothThermal.connect(macPrinterAddress: value);
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final connected = await ConnectivityUtils.isConnected();
    if (mounted) {
      setState(() {
        isOnline = connected;
      });
    }
  }

  void onCategoryTap(int index, {String? categoryName, int? categoryId}) {
    searchController.clear();
    setState(() {
      currentIndex = index;
    });
    if (index == 0) {
      context.read<ProductBloc>().add(const ProductEvent.fetchLocal());
    } else if (categoryId != null) {
      // Fetch products by category from local data
      context.read<ProductBloc>().add(ProductEvent.fetchByCategory(categoryId.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    // final paddingHorizontal = EdgeInsets.symmetric(
    //   horizontal: isSmallScreen ? 12.0 : 16.0,
    // );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Menu Cafe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 6 : 8,
              vertical: 2,
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isOnline ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isOnline ? Icons.wifi : Icons.wifi_off,
                  color: Colors.white,
                  size: isSmallScreen ? 12 : 14,
                ),
                const SizedBox(width: 4),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 10 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              context.push(const DraftOrderPage());
            },
            icon: const Icon(Icons.note_alt_rounded),
          ),
          const SpaceWidth(8)
        ],
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SearchInput(
            controller: searchController,
            onChanged: (value) {
              if (value.isNotEmpty) {  // Reduced minimum length for better UX
                context
                    .read<ProductBloc>()
                    .add(ProductEvent.searchProduct(value));
              }
              if (value.isEmpty) {
                // When search is cleared, show all products from local storage
                context.read<ProductBloc>().add(const ProductEvent.fetchLocal());
              }
            },
          ),
          const SpaceHeight(16.0),
          BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
            return state.maybeWhen(
              orElse: () {
                return const SizedBox();
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              error: (message) {
                return Center(
                  child: Text(message),
                );
              },
              loadedLocal: (categories) {
                return SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // All Categories Button
                      SizedBox(
                        height: 80,
                        width: 90,
                        child: MenuButton(
                          iconPath: Assets.icons.allCategories.path,
                          label: 'All',
                          isActive: currentIndex == 0,
                          onPressed: () => onCategoryTap(0),
                        ),
                      ),
                      const SpaceWidth(10.0),
                      // Dynamic Category Buttons
                      ...categories.map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: SizedBox(
                            height: 80,
                            width: 90,
                            child: MenuButton(
                              iconPath: Assets.icons.allCategories.path,
                              label: category.name,
                              isActive: currentIndex == category.id,
                              onPressed: () => onCategoryTap(category.id,
                                  categoryId: category.id),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
          // ValueListenableBuilder(
          //   valueListenable: indexValue,
          //   builder: (context, value, _) => Row(
          //     children: [
          //       MenuButton(
          //         iconPath: Assets.icons.allCategories.path,
          //         label: 'All',
          //         isActive: value == 0,
          //         onPressed: () => onCategoryTap(0),
          //       ),
          //       const SpaceWidth(10.0),
          //       MenuButton(
          //         iconPath: Assets.icons.drink.path,
          //         label: 'Drink',
          //         isActive: value == 1,
          //         onPressed: () => onCategoryTap(1),
          //       ),
          //       const SpaceWidth(10.0),
          //       MenuButton(
          //         iconPath: Assets.icons.food.path,
          //         label: 'Food',
          //         isActive: value == 2,
          //         onPressed: () => onCategoryTap(2),
          //       ),
          //       const SpaceWidth(10.0),
          //       MenuButton(
          //         iconPath: Assets.icons.snack.path,
          //         label: 'Snack',
          //         isActive: value == 3,
          //         onPressed: () => onCategoryTap(3),
          //       ),
          //     ],
          //   ),
          // ),
          const SpaceHeight(16.0),
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return state.maybeWhen(orElse: () {
                return const SizedBox();
              }, loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }, error: (message) {
                return Center(
                  child: Text(message),
                );
              }, success: (products) {
                if (products.isEmpty) return const ProductEmpty();
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.75,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemBuilder: (context, index) => ProductCard(
                    data: products[index],
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
