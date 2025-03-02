class ChatUser {
  final String userId;
  final List<String>? swapId;
  final List<String>? donationId;
  final String? username;
  final String? fullName;
  final String? profilePicUrl;


  ChatUser({
    required this.userId,
    required this.swapId,
    required this.donationId,
    required this.username,
    required this.fullName,
    required this.profilePicUrl,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json){
    return ChatUser(
        userId: json['userId'],
        swapId:json['swapId'] != null? List<String>.from(json['swapId']):[],
        donationId:json['donationId'] != null? List<String>.from(json['donationId']):[],
        username: json['username'],
        fullName: json['fullName'],
        profilePicUrl:json['profilePicUrl'] != null ?  json['profilePicUrl']:null
    );
  }
  // Convert UserProfile to JSON
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'swapId': swapId,
    'donationId': donationId,
    'username': username,
    'fullName': fullName,
    'profilePicUrl': profilePicUrl,
  };
}
