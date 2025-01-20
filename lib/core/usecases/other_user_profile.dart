import '../services/auth_service.dart';
import 'SingleItem.dart';

class OtherUserProfile {
  final int listedItemCount;
  final int completedSwapCount;
  final int completedDonationCount;
  final String fullName;
  final String? profilePicUrl;
  final String? bio;
  // final String? createdAt;
  // final int? version;

  OtherUserProfile(
      {required this.fullName,
      this.profilePicUrl,
      this.bio,
      required this.listedItemCount,
      required this.completedSwapCount,
      required this.completedDonationCount
      // this.createdAt,
      // this.version,
      });

  factory OtherUserProfile.fromJson(Map<String, dynamic> json) {
    return OtherUserProfile(
      // location:
      // json['location'] != null ? Location.fromJson(json['location']) : null,
      // interests: json['interests'] != null
      //     ? Interests.fromJson(json['interests'])
      //     : null,
      // id: json['_id'],
      // userId: json['userId'],
      completedDonationCount: json["completedDonationCount"] ?? 0,
      completedSwapCount: json["completedSwapCount"] ?? 0,
      listedItemCount: json["listedItemCount"] ?? 0,
      fullName: json['fullName'],
      profilePicUrl: json['profilePicUrl'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'location': location?.toJson(),
      // 'interests': interests?.toJson(),
      // '_id': id,
      // 'userId': userId,
      "completedDonationCount": completedDonationCount,
      "completedSwapCount": completedSwapCount,
      "listedItemCount": listedItemCount,
      'fullName': fullName,
      'profilePicUrl': profilePicUrl,
      'bio': bio,
      // 'createdAt': createdAt,
      // '__v': version,
    };
  }
}
