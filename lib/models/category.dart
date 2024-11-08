import 'dart:convert';

class CategoryModel {
  final String name;
  final String image;
  final String? id;
  CategoryModel({
    required this.name,
    required this.image,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image':image,
      'id': id,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] ?? '',
      id: map['_id'],
      image: map['image']
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));
}
