import 'location.dart';

class SingleItem {
  final String id;
  final String userId;
  final Category? category;
  final SubCategory subCategory;
  final String title;
  final String description;
  final String condition;
  late final List<String> imageUrls;
  final List<String>? tags;
  final String status;
  final String exchangeMethod;
  final List<String>? swapInterests;
  final String? additionalInformation;
  final bool? warrantStatus;
  final DateTime createdAt;
  final String createdBy;
  final Location? location;

  SingleItem({
    required this.id,
    required this.userId,
    required this.category,
    required this.subCategory,
    required this.title,
    required this.description,
    required this.condition,
    required this.imageUrls,
    required this.tags,
    required this.status,
    required this.exchangeMethod,
    required this.swapInterests,
    required this.additionalInformation,
    required this.warrantStatus,
    required this.createdAt,
    required this.createdBy,
    required this.location,
  });

  factory SingleItem.fromJson(Map<String, dynamic> json) {
    return SingleItem(
      id: json['_id'],
      userId: json['userId'],
      category:json['categoryId']!=null? Category.fromJson(json['categoryId']):null,
      subCategory: SubCategory.fromJson(json['subCategoryId']),
      title: json['title'],
      description: json['description'],
      condition: json['condition'],
      imageUrls: json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'])
          : [],
      // imageUrls: List<String>.from(json['imageUrls']),
      tags: List<String>.from(json['tags']),
      status: json['status'],
      exchangeMethod: json['exchangeMethod'],
      swapInterests: List<String>.from(json['swapInterests']),
      additionalInformation:
          json['additionalInformation'] ?? "no additional info",
      warrantStatus: json['warrantStatus'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'],
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      // location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'categoryId': category?.toJson(),
      'subCategoryId': subCategory.toJson(),
      'title': title,
      'description': description,
      'condition': condition,
      'imageUrls': imageUrls,
      'tags': tags,
      'status': status,
      'exchangeMethod': exchangeMethod,
      'swapInterests': swapInterests,
      'additionalInformation': additionalInformation,
      'warrantStatus': warrantStatus,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'location': location?.toJson(),
    };
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class SubCategory {
  final String id;
  final String name;

  SubCategory({required this.id, required this.name});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

// class Location {
//   final String? country;
//   final String? city;
//
//   Location({this.country, this.city});
//
//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       country: json['country'],
//       city: json['city'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'country': country,
//       'city': city,
//     };
//   }
// }

// class Coordinates {
//   final String type;
//   final List<double> coordinates;
//
//   Coordinates({required this.type, required this.coordinates});
//
//   factory Coordinates.fromJson(Map<String, dynamic> json) {
//     return Coordinates(
//       type: json['type'],
//       coordinates: List<double>.from(json['coordinates']),
//     );
//   }

// Map<String, dynamic> toJson() {
//   return {
//     'type': type,
//     'coordinates': coordinates,
//   };
// }
// }
