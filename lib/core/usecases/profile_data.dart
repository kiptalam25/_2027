import '../services/auth_service.dart';
import 'SingleItem.dart';
import 'location.dart';

class ProfileData {
  late final Location? location;
  final Interests? interests;
  final String? id;
  final String? userId;
  final String? fullName;
  final String? profilePicUrl;
  final String? bio;
  final String? createdAt;
  final int? version;

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
      location:Location.fromJson(json['location']).city != null
              ? Location.fromJson(json['location']) : null,
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
