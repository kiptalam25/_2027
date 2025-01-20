import 'package:swapifymobile/core/usecases/profile_data.dart';

import 'location.dart';

class UserProfileResponse {
  final bool success;
  final String message;
  final Profile profile;

  UserProfileResponse({
    required this.success,
    required this.message,
    required this.profile,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      success: json['success'],
      message: json['message'],
      profile: Profile.fromJson(json['profile']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'profile': profile.toJson(),
    };
  }
}

class Profile {
  final Location location;
  final Interests interests;
  final String id;
  final String userId;
  final String fullName;
  final String profilePicUrl;
  final String bio;
  final String createdAt;
  final int v;
  Profile({
    required this.location,
    required this.interests,
    required this.id,
    required this.userId,
    required this.fullName,
    required this.profilePicUrl,
    required this.bio,
    required this.createdAt,
    required this.v,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      location: Location.fromJson(json['location']),
      interests: Interests.fromJson(json['interests']),
      id: json['_id'],
      userId: json['userId'],
      fullName: json['fullName'],
      profilePicUrl: json['profilePicUrl'],
      bio: json['bio'],
      createdAt: json['createdAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'interests': interests.toJson(),
      '_id': id,
      'userId': userId,
      'fullName': fullName,
      'profilePicUrl': profilePicUrl,
      'bio': bio,
      'createdAt': createdAt,
      '__v': v,
    };
  }
}

// class Location {
//   final String country;
//   final String city;
//
//   Location({
//     required this.country,
//     required this.city,
//   });
//
//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       country: json['country'] ?? '',
//       city: json['city'] ?? '',
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

class Interests {
  final List<String> categoryId;
  final List<String> city;

  Interests({
    required this.categoryId,
    required this.city,
  });

  factory Interests.fromJson(Map<String, dynamic> json) {
    return Interests(
      categoryId: List<String>.from(json['categoryId'] ?? []),
      city: List<String>.from(json['city'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'city': city,
    };
  }
}
