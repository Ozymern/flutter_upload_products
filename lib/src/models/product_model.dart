// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String id;
  String title;
  int value;
  bool available;
  String photoUrl;

  ProductModel({
    this.id,
    this.title = '',
    this.value = 0,
    this.available = true,
    this.photoUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => new ProductModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        value: json["value"] == null ? null : json["value"],
        available: json["available"] == null ? null : json["available"],
        photoUrl: json["photoUrl"] == null ? null : json["photoUrl"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id == null ? null : id,
        "title": title == null ? null : title,
        "value": value == null ? null : value,
        "available": available == null ? null : available,
        "photoUrl": photoUrl == null ? null : photoUrl,
      };
}
