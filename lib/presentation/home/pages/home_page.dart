import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/presentation/home/bloc/product/product_bloc.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/menu_button.dart';
import '../../../core/components/search_input.dart';
import '../../../core/components/spaces.dart';
import '../../../core/utils/connectivity_utils.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../../l10n/app_localizations.dart';
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

  @override
  void dispose() {
    searchController.dispose();
    indexValue.dispose();
    super.dispose();
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
      context
          .read<ProductBloc>()
          .add(ProductEvent.fetchByCategory(categoryId.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            AppLocalizations.of(context)!.menuHome,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          // actions: [
          //   Container(
          //     padding: EdgeInsets.symmetric(
          //       horizontal: isSmallScreen ? 6 : 8,
          //       vertical: 2,
          //     ),
          //     margin: const EdgeInsets.symmetric(vertical: 8),
          //     decoration: BoxDecoration(
          //       color: isOnline ? Colors.green : Colors.red,
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Icon(
          //           isOnline ? Icons.wifi : Icons.wifi_off,
          //           color: Colors.white,
          //           size: isSmallScreen ? 12 : 14,
          //         ),
          //         const SizedBox(width: 4),
          //         Text(
          //           isOnline ? 'Online' : 'Offline',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: isSmallScreen ? 10 : 12,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          //   IconButton(
          //     onPressed: () {
          //       context.push(const DraftOrderPage());
          //     },
          //     icon: const Icon(Icons.note_alt_rounded),
          //   ),
          //   const SpaceWidth(8)
          // ],
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            SearchInput(
              controller: searchController,
              onChanged: (value) {
                if (value.length > 3) {
                  context
                      .read<ProductBloc>()
                      .add(ProductEvent.searchProduct(value));
                }
                if (value.isEmpty) {
                  context
                      .read<ProductBloc>()
                      .add(const ProductEvent.fetchAllFromState());
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
                            label: AppLocalizations.of(context)!.menuHome,
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
                                onPressed: () => onCategoryTap(
                                  category.id,
                                  categoryId: category.id,
                                ),
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
            const SpaceHeight(16.0),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SizedBox(),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (message) => Center(child: Text(message)),
                  success: (products) {
                    if (products.isEmpty) return const ProductEmpty();
                    // Responsive grid layout that adapts to different screen sizes
                    final screenWidth = MediaQuery.of(context).size.width;
                    final isMobile = screenWidth < 600; // Mobile breakpoint
                    final isTablet = screenWidth >= 600 &&
                        screenWidth < 1200; // Tablet breakpoint

                    // Calculate cross axis count based on screen width
                    final crossAxisCount = isMobile
                        ? 2
                        : isTablet
                            ? 3
                            : 4; // 2 for mobile, 3 for tablet, 4 for desktop

                    // Calculate item width as a fraction of screen width
                    final itemWidth =
                        (screenWidth - (16.0 * (crossAxisCount + 1))) /
                            crossAxisCount;
                    // Set aspect ratio based on screen size
                    final childAspectRatio = isMobile
                        ? 0.65
                        : isTablet
                            ? 0.7
                            : 0.8;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        mainAxisExtent: itemWidth *
                            (0.8 /
                                childAspectRatio), // Calculate height based on width and aspect ratio
                      ),
                      itemBuilder: (context, index) => ProductCard(
                        data: products[index],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ));
  }
}
