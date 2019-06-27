import 'dart:io';

import 'package:flutter_login/src/models/product_model.dart';
import 'package:flutter_login/src/providers/product_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc {
  final _productController = new BehaviorSubject<List<ProductModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _productProvider = new ProductProvider();

  Stream<List<ProductModel>> get productStream => _productController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;

  void listProducts() async {
    final products = await _productProvider.listProducts();
    _productController.sink.add(products);
  }

  void createProduct(ProductModel product) async {
    //mostrar que se esta cargando informacion, para bloquiar botones
    _loadingController.sink.add(true);
    await _productProvider.createProduct(product);
    _loadingController.sink.add(false);
  }

  void updateProduct(ProductModel product) async {
    //mostrar que se esta cargando informacion, para bloquiar botones
    _loadingController.sink.add(true);
    await _productProvider.updateProduct(product);
    _loadingController.sink.add(false);
  }

  void deleteProduct(String id) async {
    await _productProvider.deleteProduct(id);
  }

  Future<String> uploadImg(File photo) async {
    //mostrar que se esta cargando informacion, para bloquiar botones
    _loadingController.sink.add(true);
    final photoUrl = await _productProvider.uploadImg(photo);
    _loadingController.sink.add(false);
    return photoUrl;
  }

  dispose() {
    _productController.close();
    _loadingController.close();
  }
}
