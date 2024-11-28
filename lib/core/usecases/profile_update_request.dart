import 'location.dart';
import 'new_item.dart';

class ProfileUpdateRequest {
  final String fullName;
  final String profilePicUrl;
  final String bio;
  final Location location;

  ProfileUpdateRequest({
    required this.fullName,
    required this.profilePicUrl,
    required this.bio,
    required this.location,
  });

  factory ProfileUpdateRequest.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateRequest(
      fullName: json['fullName'],
      profilePicUrl: json['profilePicUrl'],
      bio: json['bio'],
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'profilePicUrl': profilePicUrl,
      'bio': bio,
      'location': location.toJson(),
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
