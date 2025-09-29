import 'package:equatable/equatable.dart';

enum ProductCategory { supplement, equipment, nutrition, recovery }
enum ProductType { protein, creatine, vitamins, equipment, apparel }

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final ProductCategory category;
  final ProductType type;
  final double price;
  final int credits;
  final bool isAvailable;
  final int stockQuantity;
  final Map<String, dynamic> specifications;
  final List<String> benefits;
  final String brand;
  final double? rating;
  final int? reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.type,
    required this.price,
    required this.credits,
    required this.isAvailable,
    required this.stockQuantity,
    required this.specifications,
    required this.benefits,
    required this.brand,
    this.rating,
    this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      category: ProductCategory.values[json['category'] as int],
      type: ProductType.values[json['type'] as int],
      price: (json['price'] as num).toDouble(),
      credits: json['credits'] as int,
      isAvailable: json['isAvailable'] as bool,
      stockQuantity: json['stockQuantity'] as int,
      specifications: json['specifications'] as Map<String, dynamic>,
      benefits: List<String>.from(json['benefits'] as List),
      brand: json['brand'] as String,
      rating: json['rating'] as double?,
      reviewCount: json['reviewCount'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category.index,
      'type': type.index,
      'price': price,
      'credits': credits,
      'isAvailable': isAvailable,
      'stockQuantity': stockQuantity,
      'specifications': specifications,
      'benefits': benefits,
      'brand': brand,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        category,
        type,
        price,
        credits,
        isAvailable,
        stockQuantity,
        specifications,
        benefits,
        brand,
        rating,
        reviewCount,
        createdAt,
        updatedAt,
      ];
}
