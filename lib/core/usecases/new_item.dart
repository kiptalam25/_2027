import 'dart:convert';

import 'location.dart';

class NewItem {
  final String fullName;
  final List<String> profilePicUrls;
  final String bio;
  final Location location;
  final Interests interests;

  NewItem({
    required this.fullName,
    required this.profilePicUrls,
    required this.bio,
    required this.location,
    required this.interests,
  });

  // Convert UserProfile to JSON
  Map<String, dynamic> toJson() => {
        'firstName': fullName,
        'profilePicUrls': profilePicUrls,
        'bio': bio,
        'location': location.toJson(),
        'interests': interests.toJson(),
      };
}

class Interests {
  final List<String> subCategoryId;
  final List<String> city;

  Interests({
    required this.subCategoryId,
    required this.city,
  });

  // Convert Interests to JSON
  Map<String, dynamic> toJson() => {
        'subCategoryId': subCategoryId,
        'city': city,
      };
}
