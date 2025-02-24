import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/common/widgets/basic_app_button.dart';
import 'package:swapifymobile/core/main/widgets/loading.dart';
import 'package:swapifymobile/core/services/chat_service.dart';
import 'package:swapifymobile/core/usecases/chat_user.dart';
import 'package:swapifymobile/core/widgets/alert_dialog.dart';

import '../../../common/app_colors.dart';
import '../../services/sharedpreference_service.dart';
import '../../usecases/conversation_response.dart';
import '../../usecases/exchange.dart';
import '../../usecases/profile_data.dart';
import 'dart:async';

import '../chat_bubble.dart';

class ChatPage extends StatefulWidget {
  final String exchangeId;
  final bool isRecipient;
  final ChatUser chatUser;

  const ChatPage({Key? key, required this.exchangeId, required this.isRecipient, required this.chatUser})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // final List<Map<String, dynamic>> messages = [
  //   {"text": "Hello!", "isSentByMe": false},
  //   {"text": "Hi! How are you?", "isSentByMe": true},
  //   {"text": "I'm good, thanks. And you?", "isSentByMe": false},
  // ];

  final ChatService chatService = ChatService(ApiClient());
  // final SharedPreferencesService sharedPreferencesService;

  final TextEditingController _messageController = TextEditingController();

  List<Conversation> messages = [];
  bool fetchingMessages = false;
  // Timer? _timer;
  bool initialLoading = true;
  bool isSending = false;

  Future<void> fetchChat(exchangeId) async {
    if (initialLoading) {
      setState(() {
        fetchingMessages = true;
      });
    }
    try {
      final response = await chatService.fetchChat(exchangeId);
      if (response != null && response.data != null) {
        final data = response.data;

        if (data['success'] == true && data['conversation'] != null) {
          final List<Conversation> chats1 = (data['conversation']
                  as List<dynamic>)
              .map((chat) => Conversation.fromJson(chat, profileData.userId!))
              .toList();
          setState(() {
            messages = chats1;
            fetchingMessages = false;
            initialLoading = false;
          });
        }
      }
    } catch ($e) {
      setState(() {
        fetchingMessages = false;
        initialLoading = false;
      });
      print($e.toString());
    } finally {}
  }

  ProfileData profileData = ProfileData();
  Future<void> loadProfileData() async {
    final data = await SharedPreferencesService.getProfileData();
    if (data != null) {
      setState(() {
        profileData = data;
      });
    }
  }

  @override
  void initState() {
    loadProfileData();
    if (initialLoading) {
      fetchChat(widget.exchangeId);
    }
    // _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
    //   fetchChat(widget.exchange.id);
    // });
    super.initState();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to avoid memory leaks
    // _timer?.cancel();
    super.dispose();
  }

  Future<void> _sendMessage(String message) async {
    setState(() {
      isSending = true;
    });
    try {
      if (_messageController.text.trim().isEmpty) return;
      final response = await chatService.sendMessage(message);

      if (response != null && response.data != null) {
        final data = response.data;
        if (data['success'] == true) {
          final List<Conversation> conversations =
              (data["conversation"] as List)
                  .map((item) => Conversation.fromJson(
                      item as Map<String, dynamic>, profileData.userId!))
                  .toList();
          setState(() {
            _messageController.clear();
            messages = conversations;
          });
        }
      }
    } catch ($e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text($e.toString())));
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.chatUser.fullName),

        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              // Handle the selected value here
              switch (value) {
                case 1:
                  print('Option 1 selected');
                  break;
                // case 2:
                //   print('Option 2 selected');
                //   break;
                // case 3:
                //   print('Option 3 selected');
                //   break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                onTap: () {
                  showConfirmationDialog(context, widget.exchangeId);
                },
                child: const Text('End Swap'),
              ),
            ],
          )
        ],

      ),
      body:


          fetchingMessages
          ? Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            )
          : messages.isEmpty
              ? Center(
                  child: Text("No Messages"),
                )
              : Column(
                  children: [
                    Column(
                      children: [ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Color(0xFF50644C), width: 2),
                          backgroundColor: AppColors.primary,
                        ),
                        onPressed: () {
                          showConfirmationDialog(context, widget.exchangeId)  ;
                        },
                        child: Text(
                          "End Swap",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppColors.background,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),],
                    ),
                    // Messages List
                    Expanded(
                      child: ListView.builder(
                        reverse: true, // Show the latest message at the bottom
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[messages.length - 1 - index];
                          return ChatBubble(
                            text: message.content!,
                            isSentByMe: message.isSentByMe!,
                          );
                        },
                      ),
),
                    // Message Input
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: const InputDecoration(
                                hintText: "Type a message",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          isSending
                              ? Loading()
                              : IconButton(
                                  icon: const Icon(Icons.send,
                                      color: AppColors.primary),
                                  onPressed: () {
                                    Map<String, String> message;
                                    message = {
                                      "exchangeId":
                                          widget.exchangeId.toString(),
                                      "exchangeType": "swap",
                                      "content": _messageController.text
                                    };
                                    String jsonString = jsonEncode(message);
                                    if (_messageController.text.isNotEmpty) {
                                      _sendMessage(jsonString);
                                    }
                                  }),
                        ],
                      ),
                    ),
                  ],
                ),

    );
  }

  void showConfirmationDialog(BuildContext context, String swapId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          title: Column(
            children: [
              Icon(
                Icons.warning_amber_outlined, // Exclamation icon
                color: Colors.black,
                size: 50,
              ),
              SizedBox(height: 10),
              // Text(
              //   "Are you sure?",
              //   style: TextStyle(fontWeight: FontWeight.bold),
              //   textAlign: TextAlign.center,
              // ),
            ],
          ),
          content: Text(
            "Was this swap completed\n successfully??",
            textAlign: TextAlign.center,
          ),
          actions: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BasicAppButton(
                  title: "Yes",
                  height: 40,
                  radius: 32,
                  onPressed:  () {
                  
                },),
                SizedBox(height: 8,),
                BasicAppButton(
                  title: "No",
                  height: 40,
                  radius: 32,
                  textColor: AppColors.primary,
                  backgroundColor: AppColors.background,
                  onPressed: () {

                },)
              ],
            ),
          ],
        );
      },
    );
  }

}
