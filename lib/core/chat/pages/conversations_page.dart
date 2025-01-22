import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/core/main/widgets/bottom_navigation.dart';
import 'package:swapifymobile/core/main/widgets/loading.dart';
import 'package:swapifymobile/core/services/chat_service.dart';

import '../../services/sharedpreference_service.dart';
import '../../usecases/conversation_response.dart';
import '../../usecases/profile_data.dart';
import 'chat_page.dart';

class ConversationsPage extends StatefulWidget {
  final String conversationId;

  const ConversationsPage({super.key, required this.conversationId});
  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  ProfileData profileData = ProfileData();

  bool loadingChats = false;
  late List<Message> chats = [];
  final ChatService chatService = ChatService(new ApiClient());

  Future<void> loadProfileData() async {
    final data = await SharedPreferencesService.getProfileData();
    if (data != null) {
      setState(() {
        profileData = data;
      });
    }
  }

  Future<void> _fetchConversations() async {
    setState(() {
      loadingChats = true;
    });
    try {
      final response = await chatService.fetchConversations();
      if (response != null && response.data != null) {
        final data = response.data;

        if (data['success'] == true && data['messages'] != null) {
          final List<Message> chats1 = (data['messages'] as List<dynamic>)
              .map((chat) => Message.fromJson(chat, profileData.userId!))
              .where((message) =>
                  message.exchangeId?.recipient?.recipientProfile !=
                  null) // Filter out null recipients
              .toList();
          setState(() {
            chats = chats1;
          });
        }
      }
    } catch ($e) {
      setState(() {
        loadingChats = false;
      });

      print($e);
    } finally {
      setState(() {
        loadingChats = false;
      });
    }
  }

  @override
  void initState() {
    loadProfileData();
    _fetchConversations();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Conversations")),
        body: BasePage(
          initialIndex: 2,
          child: loadingChats
              ? Loading()
              : chats.isEmpty
                  ? Center(
                      child: Text("no conversations"),
                    )
                  : ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        print(chat.exchangeId?.initiator?.id);
                        print(profileData.userId);
                        return ListTile(
                          leading: chat.exchangeId?.initiator?.id ==
                                  profileData.userId
                              ? CircleAvatar(
                                  backgroundImage: chat
                                                  .exchangeId!
                                                  .recipient!
                                                  .recipientProfile!
                                                  .profilePicture !=
                                              null &&
                                          chat
                                              .exchangeId!
                                              .recipient!
                                              .recipientProfile!
                                              .profilePicture!
                                              .isNotEmpty
                                      ? NetworkImage(chat.exchangeId!.recipient!
                                          .recipientProfile!.profilePicture!)
                                      : null,
                                  child: chat
                                                  .exchangeId!
                                                  .recipient!
                                                  .recipientProfile!
                                                  .profilePicture ==
                                              null ||
                                          chat
                                              .exchangeId!
                                              .recipient!
                                              .recipientProfile!
                                              .profilePicture!
                                              .isEmpty
                                      ? Text(
                                          chat.exchangeId!.recipient!
                                              .recipientProfile!.fullName!
                                              .substring(0, 1)
                                              .toUpperCase(),
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : null,
                                )
                              : CircleAvatar(
                                  backgroundImage: chat
                                                  .exchangeId!
                                                  .initiator!
                                                  .recipientProfile!
                                                  .profilePicture !=
                                              null &&
                                          chat
                                              .exchangeId!
                                              .initiator!
                                              .recipientProfile!
                                              .profilePicture!
                                              .isNotEmpty
                                      ? NetworkImage(chat.exchangeId!.initiator!
                                          .recipientProfile!.profilePicture!)
                                      : null,
                                  child: chat
                                                  .exchangeId!
                                                  .initiator!
                                                  .recipientProfile!
                                                  .profilePicture ==
                                              null ||
                                          chat
                                              .exchangeId!
                                              .initiator!
                                              .recipientProfile!
                                              .profilePicture!
                                              .isEmpty
                                      ? Text(
                                          chat.exchangeId!.initiator!
                                              .recipientProfile!.fullName!
                                              .substring(0, 1)
                                              .toUpperCase(),
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : null,
                                ),
                          title: chat.exchangeId?.initiator?.id ==
                                  profileData.userId
                              ? chat.exchangeId!.recipient!.recipientProfile!
                                          .fullName !=
                                      null
                                  ? Text(chat.exchangeId!.recipient!
                                      .recipientProfile!.fullName
                                      .toString())
                                  : Text("No Name")
                              : chat.exchangeId!.initiator!.recipientProfile!
                                          .fullName !=
                                      null
                                  ? Text(chat.exchangeId!.initiator!
                                      .recipientProfile!.fullName
                                      .toString())
                                  : Text("No Name"),
                          subtitle: Text(
                            chat.conversation![0].content!,
                            maxLines: 1, // Limit text to 1 line
                            overflow: TextOverflow
                                .ellipsis, // Show "..." if text overflows
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                DateFormat.jm().format(DateTime.parse(
                                    chat.lastMessage!.timestamp!.toString())),
                                style: TextStyle(fontSize: 12),
                              ),

                              SizedBox(
                                  height:
                                      4), // Add spacing between the time and message count
                              Text(
                                '${chat.conversation!.length}', // Number of messages
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Navigate to ChatPage with selected user
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  exchange: chat.exchangeId!,
                                  isRecipient: chat.exchangeId?.initiator?.id ==
                                          profileData.userId
                                      ? false
                                      : true,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
        ));
  }
}
