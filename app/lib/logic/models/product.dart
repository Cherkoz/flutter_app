import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.discountPrice,
    required this.imageUrl,
    required this.rating,
    required this.weight,
    required this.characteristics,
  });

  factory Product.fromJson(json) {
    return _$ProductFromJson(json);
  }
  final String id;
  final String name;
  final String categoryId;
  final double price;
  final double? discountPrice;
  final String imageUrl;
  final double? rating;
  final String weight;
  final Map<String, String> characteristics;

  static List<Product> parseListFromJson(dynamic json) {
    if (json is! List) {
      return [];
    }

    return json.map(Product.fromJson).toList().cast<Product>();
  }

  static List<Map<String, dynamic>> parseListToJson(List<Product> products) {
    return products.map((product) => product.toJson()).toList();
  }

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  List<Object?> get props => [id];
}
