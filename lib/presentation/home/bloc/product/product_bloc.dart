import 'package:bloc/bloc.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_pos/data/datasources/product_remote_datasource.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/models/request/product_request_model.dart';
import '../../../../data/models/response/product_response_model.dart';

part 'product_bloc.freezed.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource _productRemoteDatasource;
  List<Product> products = [];
  ProductBloc(
    this._productRemoteDatasource,
  ) : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      emit(const ProductState.loading());
      try {
        final response = await _productRemoteDatasource.getProducts();
        await response.fold(
          (l) async {
            emit(ProductState.error(l));
          },
          (r) async {
            products = r.data;
            // Save products to local database
            await ProductLocalDatasource.instance.insertAllProduct(r.data);
            if (!emit.isDone) {
              emit(ProductState.success(products));
            }
          },
        );
      } catch (e) {
        if (!emit.isDone) {
          emit(ProductState.error('Failed to fetch products: $e'));
        }
      }
    });

    on<_FetchLocal>((event, emit) async {
      emit(const ProductState.loading());
      try {
        final localProducts = await ProductLocalDatasource.instance.getAllProduct();
        products = localProducts;
        if (!emit.isDone) {
          emit(ProductState.success(products));
        }
      } catch (e) {
        if (!emit.isDone) {
          emit(ProductState.error('Failed to load local products: $e'));
        }
      }
    });

    on<_FetchByCategory>((event, emit) async {
      emit(const ProductState.loading());

      final newProducts = event.category == 'all'
          ? products
          : products
              .where(
                  (element) => element.categoryId.toString() == event.category)
              .toList();

      emit(ProductState.success(newProducts));
    });

    on<_AddProduct>((event, emit) async {
      emit(const ProductState.loading());
      final requestData = ProductRequestModel(
        name: event.product.name,
        description: event.product.description,
        price: event.product.price.toInt(),
        stock: event.product.stock,
        categoryId: event.product.categoryId,
        sku: event.product.sku,
        unitOfMeasure: event.product.unitOfMeasure,
        expiredDate: event.product.expiredDate?.toIso8601String(),
        isBestSeller: event.product.isBestSeller,
        isReady: event.product.isReady,
        image: event.image,
      );
      final response = await _productRemoteDatasource.addProduct(requestData);
      // products.add(newProduct);
      response.fold(
        (l) => emit(ProductState.error(l)),
        (r) {
          products.add(r.data);
          emit(ProductState.success(products));
        },
      );
    });

    on<_SearchProduct>((event, emit) async {
      emit(const ProductState.loading());
      final newProducts = products
          .where((element) =>
              element.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();

      emit(ProductState.success(newProducts));
    });

    on<_FetchAllFromState>((event, emit) async {
      emit(const ProductState.loading());

      emit(ProductState.success(products));
    });

    //edit
    // on<_EditProduct>((event, emit) async {
    //   emit(const ProductState.loading());
    //   final requestData = ProductRequestModel(
    //     name: event.product.name,
    //     price: event.product.price,
    //     stock: event.product.stock,
    //     category: event.product.category,
    //     categoryId: event.product.categoryId,
    //     isBestSeller: event.product.isBestSeller ? 1 : 0,
    //     image: event.image,
    //   );
    //   final response = await _productRemoteDatasource.editProduct(
    //     event.product.id!,
    //     requestData
    //   );
    //   // products.add(newProduct);
    //   response.fold(
    //     (l) => emit(ProductState.error(l)),
    //     (r) {
    //       products.add(r.data);
    //       emit(ProductState.success(products));
    //     },
    //   );
    //   emit(ProductState.success(products));
    // });
  }
}
