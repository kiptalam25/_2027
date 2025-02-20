import 'conversation_response.dart';

class Exchange {
  final String id;
  final String? initiatorId;
  final String? recipientId;
  final String status;
  final ChatItem? initiatorItemId;
  final ChatItem? recipientItemId;

  Exchange({
    required this.id,
    required this.initiatorId,
    required this.recipientId,
    required this.status,
    required this.initiatorItemId,
    required this.recipientItemId,
  });

  factory Exchange.fromJson(Map<String, dynamic> json) {
    return Exchange(
      id: json['_id'],
      initiatorId: json['initiatorId'] !=null ? json['initiatorId'] :null,
      recipientId: json['recipientId'] ?? null,
      status: json['status'],
      initiatorItemId: json['initiatorItemId'] !=null ? ChatItem.fromJson(json['initiatorItemId']) : null ,
      recipientItemId: json['recipientItemId'] !=null ? ChatItem.fromJson(json['recipientItemId']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'initiatorId': initiatorId,
      'recipientId': recipientId,
      'initiatorItemId': initiatorItemId,
      'recipientItemId': recipientItemId,
      'status': status,
    };
  }
}
class ChatItem {
  final String id;
  final String title;
  final List<dynamic>? imageUrls;
  final String status;

  ChatItem({
    required this.id,
    required this.title,
    required this.imageUrls,
    required this.status,
  });

  factory ChatItem.fromJson(Map<String, dynamic> json) {
    return ChatItem(
      id: json['_id'],
      title: json['title'],
      imageUrls: json['imageUrls'] !=null ? json['imageUrls'] : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'imageUrls': imageUrls,
      'status': status,
    };
  }
}