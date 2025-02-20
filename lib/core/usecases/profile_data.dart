import '../services/auth_service.dart';
import 'SingleItem.dart';
import 'location.dart';

class ProfileData {
  late  Location? location;
  late Interests? interests;
  late String? id;
  late String? userId;
  late String? fullName;
  late String? profilePicUrl;
  late String? bio;
  late String? createdAt;
  late int? version;

  ProfileData({
    this.location,
    this.interests,
    this.id,
    this.userId,
    this.fullName,
    this.profilePicUrl,
    this.bio,
    this.createdAt,
    this.version,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      location: json['location'] != null && json['location']['city'] != null
          ? Location.fromJson(json['location'])
          : null, // ✅ Ensure null safety
      interests: json['interests'] != null
          ? Interests.fromJson(json['interests'])
          : null,
      id: json['_id'],
      userId: json['userId'],
      fullName: json['fullName'],
      profilePicUrl: json['profilePicUrl'] ?? null,
      bio: json['bio']??null,
      createdAt: json['createdAt'],
      version: json['__v'] != null ? json['__v'] as int : null,
    );
  }

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
      '__v': version,
    };
  }
}
