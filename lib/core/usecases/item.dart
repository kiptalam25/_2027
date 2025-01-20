import 'package:flutter/foundation.dart';

class Item {
  final String id;
  final String userId;
  final String categoryId;
  final String subCategoryId;
  final String title;
  final String description;
  final String condition;
  final List<String> imageUrls;
  final List<String> tags;
  final String status;
  final String exchangeMethod;
  final List<String> swapInterests;
  final String? additionalInformation;
  final bool warrantStatus;
  final DateTime createdAt;
  final String createdBy;

  Item({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.subCategoryId,
    required this.title,
    required this.description,
    required this.condition,
    required this.imageUrls,
    required this.tags,
    required this.status,
    required this.exchangeMethod,
    required this.swapInterests,
    this.additionalInformation,
    required this.warrantStatus,
    required this.createdAt,
    required this.createdBy,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      categoryId: json['categoryId'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
      title: json['title'] ?? 'Untitled',
      description: json['description'] ?? '',
      condition: json['condition'] ?? 'unknown',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      status: json['status'] ?? 'unknown',
      exchangeMethod: json['exchangeMethod'] ?? 'unknown',
      swapInterests: List<String>.from(json['swapInterests'] ?? []),
      additionalInformation: json['additionalInformation'],
      warrantStatus: json['warrantStatus'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'] ?? '',
    );
  }
}

// class Item {
//   final List<String> imageUrls;
//   final String? id;
//   final String? userId;
//   final String? categoryId;
//   final String? subCategoryId;
//   final String? title;
//   final String? description;
//   final String? condition;
//   final List<String> tags;
//   final String? status;
//   final DateTime estimatedDateOfPurchase;
//   final String? exchangeMethod;
//   final List<String> swapInterests;
//   final DateTime createdAt;
//   final String? createdBy;
//   final int version;
//
//   Item({
//     required this.imageUrls,
//     required this.id,
//     required this.userId,
//     required this.categoryId,
//     required this.subCategoryId,
//     required this.title,
//     required this.description,
//     required this.condition,
//     required this.tags,
//     required this.status,
//     required this.estimatedDateOfPurchase,
//     required this.exchangeMethod,
//     required this.swapInterests,
//     required this.createdAt,
//     required this.createdBy,
//     required this.version,
//   });
//
//   // Factory constructor to create an Item instance from a JSON object
//   factory Item.fromJson(Map<String, dynamic> json) {
//     return Item(
//       imageUrls: List<String>.from(json['imageUrls'] ?? []),
//       id: json['_id'] ?? '',
//       userId: json['userId'] ?? '',
//       categoryId: json['categoryId'] ?? '',
//       subCategoryId: json['subCategoryId'] ?? '',
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       condition: json['condition'] ?? '',
//       tags: List<String>.from(json['tags'] ?? []),
//       status: json['status'] ?? '',
//       estimatedDateOfPurchase: DateTime.parse(json['estimatedDateOfPurchase']),
//       exchangeMethod: json['exchangeMethod'] ?? '',
//       swapInterests: List<String>.from(json['swapInterests'] ?? []),
//       createdAt: DateTime.parse(json['createdAt']),
//       createdBy: json['createdBy'],
//       version: json['__v'],
//     );
//   }
//
//   // Convert the Item instance back to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'imageUrls': imageUrls,
//       '_id': id,
//       'userId': userId,
//       'categoryId': categoryId,
//       'subCategoryId': subCategoryId,
//       'title': title,
//       'description': description,
//       'condition': condition,
//       'tags': tags,
//       'status': status,
//       'estimatedDateOfPurchase': estimatedDateOfPurchase.toIso8601String(),
//       'exchangeMethod': exchangeMethod,
//       'swapInterests': swapInterests,
//       'createdAt': createdAt.toIso8601String(),
//       'createdBy': createdBy,
//       '__v': version,
//     };
//   }
// }
