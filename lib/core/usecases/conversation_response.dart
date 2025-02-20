import 'exchange.dart';

class ConversationResponseModel {
  final bool? success;
  final List<Message>? messages;

  ConversationResponseModel({this.success, this.messages});

  factory ConversationResponseModel.fromJson(
      Map<String, dynamic> json, String currentUserId) {
    return ConversationResponseModel(
      success: json['success'] as bool?,
      messages: (json['messages'] as List<dynamic>?)
          ?.map((message) =>
              Message.fromJson(message as Map<String, dynamic>, currentUserId))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'messages': messages?.map((message) => message.toJson()).toList(),
    };
  }
}

class Message {
  final String? id;
  final Exchange? exchangeId;
  final String exchangeType;
  final DateTime? lastMessageAt;
  final Conversation lastMessage;
  final String? status;
  final int? unreadCount;
  final Participants participants;

  Message( {
    this.id,
    this.exchangeId,
    required this.exchangeType,
    required this.lastMessage,
    this.status,
    this.lastMessageAt,
    this.unreadCount,
    required this.participants,
  });

  factory Message.fromJson(Map<String, dynamic> json, String currentUserId) {
    return Message(
      id: json['_id'] as String?,
      exchangeId: json['exchangeId'] != null
          ? Exchange.fromJson(json['exchangeId'])
          : null,
      exchangeType: json['exchangeType'],
      status: json['status'] as String?,
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'] as String)
          : null,
      unreadCount: json['unreadCount'] as int?,
      lastMessage: Conversation.fromJson(
              json['lastMessage'] as Map<String, dynamic>, currentUserId),
      participants: Participants.fromJson(json['participants']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'exchangeId': exchangeId?.toJson(),
      'exchangeType': exchangeType,
      'lastMessage': lastMessage.toJson(),
      'status': status,
      'lastMessageAt': lastMessageAt,
      'unreadCount': unreadCount,
      "participants":participants

    };
  }
}

class Participants {
  final String? recipient;
  final String initiator;


  Participants({required this.recipient, required this.initiator});

  factory Participants.fromJson(Map<String, dynamic> json) {
    return Participants(
      recipient: json['initiator']!=null ?  json['initiator']:json['donor']!=null?json['initiator']:null,
      initiator: json['recipient'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'initiator': initiator,
      'recipient': recipient
    };
  }

}

class Recipient {
  final String? id;
  final RecipientProfile? recipientProfile;

  Recipient({this.id, this.recipientProfile});

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      id: json['_id'] as String? ?? "none",
      recipientProfile: json['profile'] != null
          ? RecipientProfile.fromJson(json["profile"] as Map<String, dynamic>)
          : null,
    );
  }
}

class Initiator {
  final String? id;
  final RecipientProfile? recipientProfile;

  Initiator({this.id, this.recipientProfile});

  factory Initiator.fromJson(Map<String, dynamic> json) {
    return Initiator(
      id: json['_id'] as String?,
      recipientProfile: json['profile'] != null
          ? RecipientProfile.fromJson(json["profile"] as Map<String, dynamic>)
          : null,
    );
  }
}

class RecipientProfile {
  final String? fullName;
  final String? profilePicture;
  final String? id;

  RecipientProfile({this.fullName, this.profilePicture, this.id});
  factory RecipientProfile.fromJson(Map<String, dynamic> json) {
    return RecipientProfile(
        id: json["_id"],
        fullName: json["fullName"],
        profilePicture: json["profilePicUrl"] ?? "");
  }
}



class Conversation {
  final String? senderId;
  final String? content;
  final bool? isRead;
  final String? id;
  final DateTime? timestamp;
  final bool? isSentByMe;

  Conversation(
      {this.senderId,
      this.content,
      this.isRead,
      this.id,
      this.timestamp,
      this.isSentByMe});

  factory Conversation.fromJson(
      Map<String, dynamic> json, String currentUserId) {
    return Conversation(
        senderId: json['senderId'] as String?,
        content: json['content'] as String?,
        isRead: json['isRead'] as bool?,
        id: json['_id'] as String?,
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : null,
        isSentByMe: json['senderId'] == currentUserId);
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'content': content,
      'isRead': isRead,
      '_id': id,
      'timestamp': timestamp?.toIso8601String(),
      'isSentByMe': isSentByMe
    };
  }
}
