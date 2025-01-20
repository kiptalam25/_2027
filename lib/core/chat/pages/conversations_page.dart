import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final List<Map<String, dynamic>> conversations = [
    {"name": "Alice", "lastMessage": "Hi there!", "time": "12:30 PM"},
    {"name": "Bob", "lastMessage": "Are we meeting today?", "time": "11:00 AM"},
    {"name": "Charlie", "lastMessage": "Thanks!", "time": "9:15 AM"},
  ];
  // bool isRecipient = false;
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

          // if (profileData.userId == chats1[0].exchangeId?.recipient?.id) {
          //   setState(() {
          //     isRecipient = true;
          //   });
          // }

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

// import 'package:flutter/material.dart';
// import 'package:swapifymobile/common/app_colors.dart';
//
// import '../../main/widgets/bottom_navigation.dart';
//
// class ChatApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ConversationListPage(),
//     );
//   }
// }
//
// class ConversationListPage extends StatelessWidget {
//   final List<Map<String, dynamic>> conversations = [
//     {
//       "name": "Alice",
//       "messages": [
//         {"text": "Hi, how are you?", "reply": ""},
//         {
//           "text": "Iam interested in the boots will you take a watch?",
//           "reply": "Yes, I will!"
//         },
//       ],
//     },
//     {
//       "name": "Bob",
//       "messages": [
//         {
//           "text": "Can you swap show for a watch",
//           "reply": "What kind of watch"
//         },
//         {"text": "Let me know if you need it.", "reply": ""},
//       ],
//     },
//     {
//       "name": "Charlie",
//       "messages": [
//         {"text": "Good morning!", "reply": "Good morning, Charlie!"},
//         {"text": "Any plans for swap?", "reply": ""},
//       ],
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "Conversations",
//             style: TextStyle(color: AppColors.primary),
//           ),
//           backgroundColor: AppColors.background,
//         ),
//         body: BasePage(
//           initialIndex: 2,
//           child: ListView.builder(
//             itemCount: conversations.length,
//             itemBuilder: (context, index) {
//               final conversation = conversations[index];
//               return ListTile(
//                 leading: CircleAvatar(
//                   child: Text(conversation["name"][0]),
//                   backgroundColor: AppColors.primary,
//                 ),
//                 title: Text(
//                   conversation["name"],
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text(
//                   conversation["messages"].isNotEmpty
//                       ? conversation["messages"].last["text"]
//                       : "No messages yet",
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChatPage(
//                         name: conversation["name"],
//                         messages: conversation["messages"],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ));
//   }
// }
//
// class ChatPage extends StatefulWidget {
//   final String name;
//   final List<Map<String, String>> messages;
//
//   ChatPage({required this.name, required this.messages});
//
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   late List<Map<String, String>> _messages;
//   final TextEditingController _controller = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _messages = List.from(widget.messages);
//   }
//
//   void _sendMessage(String text) {
//     if (text.isEmpty) return;
//     setState(() {
//       _messages.add({"text": text, "reply": ""});
//     });
//     _controller.clear();
//   }
//
//   void _replyMessage(int index, String reply) {
//     setState(() {
//       _messages[index]["reply"] = reply;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.name),
//         backgroundColor: AppColors.background,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             // colors: [Colors.deepPurple.shade700, Colors.purple.shade200],
//             colors: [AppColors.background, AppColors.background],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _messages.length,
//                 itemBuilder: (context, index) {
//                   final message = _messages[index];
//                   return Padding(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               child: Text(
//                                 widget.name[0],
//                                 style: TextStyle(color: AppColors.background),
//                               ),
//                               backgroundColor: AppColors.primary,
//                             ),
//                             SizedBox(width: 10),
//                             Expanded(
//                               child: Container(
//                                 padding: EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Text(message["text"]!),
//                               ),
//                             ),
//                           ],
//                         ),
//                         if (message["reply"]!.isNotEmpty)
//                           Padding(
//                             padding: const EdgeInsets.only(left: 50, top: 5),
//                             child: Row(
//                               children: [
//                                 Icon(Icons.reply,
//                                     color: AppColors.primary, size: 16),
//                                 SizedBox(width: 5),
//                                 Text(
//                                   message["reply"]!,
//                                   style: TextStyle(
//                                     color: Colors.white70,
//                                     fontStyle: FontStyle.italic,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             TextButton(
//                               onPressed: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                     title: Text("Reply to message"),
//                                     content: TextField(
//                                       onSubmitted: (value) {
//                                         Navigator.pop(context);
//                                         _replyMessage(index, value);
//                                       },
//                                       decoration: InputDecoration(
//                                         hintText: "Enter your reply",
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Text("Reply"),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       decoration: InputDecoration(
//                         hintText: "Type your message...",
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   CircleAvatar(
//                     backgroundColor: AppColors.primary,
//                     child: IconButton(
//                       onPressed: () => _sendMessage(_controller.text),
//                       icon: Icon(Icons.send, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
