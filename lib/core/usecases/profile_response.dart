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
  final Location? location;
  final Interests? interests;
  final String id;
  final String userId;
  final String fullName;
  final String profilePicUrl;
  final String bio;
  final String createdAt;
  final int v;
  Profile({
    this.location,
    this.interests,
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
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : Location(country: "no country", city: "no city"),
      interests: json['interests'] != null
          ? Interests.fromJson(json['interests'])
          : null,
      id: json['_id'] ?? "no_id",
      userId: json['userId'] ?? "no_userId",
      fullName: json['fullName'] ?? "Anonymous",
      profilePicUrl: json['profilePicUrl'] ?? "https://example.com/default.jpg",
      bio: json['bio'] ?? "No bio available",
      createdAt: json['createdAt'] ?? DateTime.now().toIso8601String(),
      v: json['__v'] ?? 0,
    );
  }

  // factory Profile.fromJson(Map<String, dynamic> json) {
  //   return Profile(
  //     location: json['location'] != null
  //         ? Location.fromJson(json['location'])
  //         : Location(country: "no country", city: "no city"),
  //     interests: json['interests'] != null
  //         ? Interests.fromJson(json['interests'])
  //         : null, // Handle null interests if applicable
  //     id: json['_id'],
  //     userId: json['userId'],
  //     fullName: json['fullName'],
  //     profilePicUrl: json['profilePicUrl'],
  //     bio: json['bio'],
  //     createdAt: json['createdAt'],
  //     v: json['__v'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'location': location?.toJson(),
      'interests': interests?.toJson(),
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
