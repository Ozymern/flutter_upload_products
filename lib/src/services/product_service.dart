import 'dart:convert';
import 'dart:io';

import 'package:flutter_login/src/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class ProductService {
  final String _urlBase = 'https://flutter-1c50d.firebaseio.com';

  Future<bool> createProduct(ProductModel product) async {
    final url = '$_urlBase/product.json';
    final resp = await http.post(url, body: productModelToJson(product));

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;
  }

  Future<bool> updateProduct(ProductModel product) async {
    final url = '$_urlBase/product/${product.id}.json';
    final resp = await http.put(url, body: productModelToJson(product));

    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<List<ProductModel>> listProducts() async {
    final url = '$_urlBase/product.json';
    final resp = await http.get(url);
    List<ProductModel> products = new List();

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    if (decodedData == null) return [];
    decodedData.forEach((id, prod) {
      final prodTemp = ProductModel.fromJson(prod);
      prodTemp.id = id;
      products.add(prodTemp);
    });

    return products;
  }

  Future<int> deleteProduct(String id) async {
    final url = '$_urlBase/product/$id.json';

    final resp = await http.delete(url);

    print(json.decode(resp.body));

    return 1;
  }

  //subir la imagen
  Future<String> uploadImg(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dkjtmooz7/image/upload?upload_preset=rkzkfgu0');
    //conocer el mime_type si es jpg, png ....
    final mimeType = mime(image.path).split('/'); //image/jpg

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    //ejecuto la peticion
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal ${resp.body}');
      return null;
    }
    final respData = json.decode(resp.body);
    return respData['url'];
  }
}
