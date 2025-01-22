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
  final String? exchangeType;
  final List<Conversation>? conversation;
  final String? status;
  final DateTime? lastMessageAt;
  final int? unreadCount;
  final int? version;
  final Conversation? lastMessage;

  Message({
    this.id,
    this.exchangeId,
    this.exchangeType,
    this.conversation,
    this.status,
    this.lastMessageAt,
    this.unreadCount,
    this.version,
    this.lastMessage,
  });

  factory Message.fromJson(Map<String, dynamic> json, String currentUserId) {
    return Message(
      id: json['_id'] as String?,
      exchangeId: json['exchangeId'] != null
          ? Exchange.fromJson(json['exchangeId'] as Map<String, dynamic>)
          : null,
      exchangeType: json['exchangeType'] as String?,
      conversation: (json['conversation'] as List<dynamic>?)
          ?.map((conv) => Conversation.fromJson(
              conv as Map<String, dynamic>, currentUserId))
          .toList(),
      status: json['status'] as String?,
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'] as String)
          : null,
      unreadCount: json['unreadCount'] as int?,
      version: json['__v'] as int?,
      lastMessage: json['lastMessage'] != null
          ? Conversation.fromJson(
              json['lastMessage'] as Map<String, dynamic>, currentUserId)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'exchangeId': exchangeId?.toJson(),
      'exchangeType': exchangeType,
      'conversation': conversation?.map((conv) => conv.toJson()).toList(),
      'status': status,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'unreadCount': unreadCount,
      '__v': version,
      'lastMessage': lastMessage?.toJson(),
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

class Exchange {
  final String? id;
  final Initiator? initiator;
  final Recipient? recipient;
  final String? initiatorItemId;
  final String? recipientItemId;
  final String? status;
  final bool? isActive;
  final DateTime? createdAt;
  final int? version;

  Exchange({
    this.id,
    this.initiator,
    this.recipient,
    this.initiatorItemId,
    this.recipientItemId,
    this.status,
    this.isActive,
    this.createdAt,
    this.version,
  });

  factory Exchange.fromJson(Map<String, dynamic> json) {
    return Exchange(
      id: json['_id'] as String?,
      // initiatorId: json['initiatorId'] as String?,
      initiator: json['initiatorId'] != null
          ? Initiator.fromJson(json["initiatorId"] as Map<String, dynamic>)
          : null,
      recipient: json['recipientId'] != null
          ? Recipient.fromJson(json["recipientId"] as Map<String, dynamic>)
          : null,
      initiatorItemId: json['initiatorItemId'] as String?,
      recipientItemId: json['recipientItemId'] as String?,
      status: json['status'] as String?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      version: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'initiatorId': initiator,
      'recipientId': recipient,
      'initiatorItemId': initiatorItemId,
      'recipientItemId': recipientItemId,
      'status': status,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      '__v': version,
    };
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
