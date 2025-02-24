import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/common/widgets/app_navigator.dart';
import 'package:swapifymobile/core/main/widgets/bottom_navigation.dart';
import 'package:swapifymobile/core/main/widgets/loading.dart';
import 'package:swapifymobile/core/services/chat_service.dart';
import 'package:swapifymobile/core/usecases/exchange.dart';
import 'package:swapifymobile/core/widgets/dialog.dart';
import 'package:swapifymobile/extensions/string_casing_extension.dart';

import '../../services/sharedpreference_service.dart';
import '../../usecases/chat_user.dart';
import '../../usecases/conversation_response.dart';
import '../../usecases/profile_data.dart';
import 'chat_page.dart';

class ConversationsPage extends StatefulWidget {
  final String conversationId;
  final ChatUser chatUser;

  const ConversationsPage({super.key, required this.conversationId, required this.chatUser});
  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  ProfileData profileData = ProfileData();

  bool loadingChats = false;
  late List<Message> chats = [];
  List<dynamic>  swapConversations= [];
  List<dynamic>  donationConversations= [];
  final ChatService chatService = ChatService(new ApiClient());

  Future<void> loadProfileData() async {
    final data = await SharedPreferencesService.getProfileData();
    if (data != null) {
      setState(() {
        profileData = data;
      });
    }
  }

  String createPayload(){
    Map<String, dynamic> payload;
    ChatUser user=widget.chatUser;

    payload = {
      "swapId":
      user.swapId,
      "donationId": user.donationId
    };
    if(user.donationId.isEmpty){
      payload.remove("donationId");
    }
    if(user.userId.isEmpty){
      payload.remove("userId");
    }
    String jsonString = jsonEncode(payload);
    print("Payload: "+payload.toString());
    return jsonString;
  }

  Future<void> _fetchConversations() async {
    setState(() {
      loadingChats = true;
    });
    String payload=createPayload();
    final response = await chatService.fetchConversations(payload);
    if (response != null && response.data != null) {
      final data = response.data;
      print("..............................Data............................");
      print(data.toString());

      if (data['success'] == true && data['conversations'] != null) {

        // Extract conversations list
        List<dynamic> conversations = data["conversations"];

        // Filter into two lists
        swapConversations =
        conversations.where((c) => c["exchangeType"] == "Swap").toList();

        donationConversations =
        conversations.where((c) => c["exchangeType"] == "Donation").toList();

        // Print results
        print("Swap Conversations: ${swapConversations.length}");
        print("Donation Conversations: ${donationConversations.length}");

        final List<Message> chats1 = (data['conversations'] as List<dynamic>)
                .map((chat) => Message.fromJson(chat, profileData.userId!))
                .where((message) =>
                    message.exchangeId?.recipientId !=
                    null) // Filter out null recipients
                .toList();
        setState(() {
          chats=chats1;
          loadingChats=false;
        });

      }
      if (data['success'] == false) {

        showAutoDismissDialog(context: context, title: "Error", message: "UnExpected Error Occurred");
      }

    }
    try {
      // final response = await chatService.fetchConversations();
      // if (response != null && response.data != null) {
      //   final data = response.data;
      //
      //   if (data['success'] == true && data['messages'] != null) {
      //     final List<Message> chats1 = (data['messages'] as List<dynamic>)
      //         .map((chat) => Message.fromJson(chat, profileData.userId!))
      //         .where((message) =>
      //             message.exchangeId?.recipient?.recipientProfile !=
      //             null) // Filter out null recipients
      //         .toList();
      //     setState(() {
      //       chats = chats1;
      //     });
        // }
      // }
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
  void showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context), // Close dialog on tap
          child: InteractiveViewer(
            panEnabled: true, // Allow pinch to zoom and drag
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }

  String truncateText(String text, int maxLength) {
    return text.length > maxLength ? "${text.substring(0, maxLength)}..." : text;
  }

 bool isAccepting=false;
 bool isRejecting=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.chatUser.fullName)),
        body: BasePage(
          initialIndex: 2,
          child: loadingChats
              ? Loading(): Column(
            children: [

                  swapConversations.isNotEmpty ?
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: swapConversations.length,
                      itemBuilder: (context, index) {
                        var swap = swapConversations[index];
                        var initiatorItem = swap["participants"]["initiatorItem"];
                        var recipientItem = swap["participants"]["recipientItem"];

                        return GestureDetector(
                          onTap: () {
                            AppNavigator.push(context,
                                ChatPage(chatUser: widget.chatUser,
                                    isRecipient: profileData.userId==swap["exchangeId"]["initiatorId"] ?
                                    true:false,
                                    exchangeId: swap["exchangeId"]["_id"])
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: ListTile(
                              leading: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Recipient Item (Background)
                                  recipientItem["imageUrls"].isNotEmpty
                                      ? GestureDetector(
                                    onTap: () => showFullImage(context, recipientItem["imageUrls"][0]),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Opacity(
                                        opacity: 0.6,
                                        child: Image.network(
                                          recipientItem["imageUrls"][0],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                      : Icon(Icons.image, size: 50),

                                  // Initiator Item (Overlapping)
                                  Positioned(
                                    top: 15,
                                    left: 15,
                                    child: initiatorItem["imageUrls"].isNotEmpty
                                        ? GestureDetector(
                                      onTap: () => showFullImage(context, initiatorItem["imageUrls"][0]),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                        child: ClipOval(
                                          child: Image.network(
                                            initiatorItem["imageUrls"][0],
                                            width: 30,
                                            height: 30,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                        : Icon(Icons.image, size: 30),
                                  ),
                                ],
                              ),
                              title: Text(
                                "${initiatorItem["title"]} ↔ ${recipientItem["title"]}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: swap["exchangeId"]["status"] =='pending' && isRecipient(swap["exchangeId"]["recipientId"]) ?  Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: isRejecting ? (){}: () async {
                                        setState(() {
                                          isRejecting=true;
                                        });
                                        Map<String, dynamic> payload;
                                        payload = {
                                          "status":"rejected"
                                        };

                                        String jsonString = jsonEncode(payload);

                                        final response=await chatService.updateExchangeStatus(swap["exchangeId"]["_id"],jsonString);

                                        final data = response.data;
                                        print(data['message']);
                                        if(data['success']) {
                                          setState(() {
                                            isRejecting=false;
                                            swap["exchangeId"]["status"] =
                                            "rejected";
                                          });
                                        }
                                        setState(() {
                                          isRejecting=false;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(20), // Rounded corners
                                        ),
                                        child: isRejecting ? Loading(): Text("Reject", style: TextStyle(color: Colors.white,fontSize: 10)),
                                      ),
                                    ),
                                    SizedBox(width: 8,),
                                    GestureDetector(
                                      onTap:  isAccepting ? (){}: () async {
                                        setState(() {
                                          isAccepting=true;
                                        });
                                          Map<String, dynamic> payload;
                                          payload = {
                                            "status":"approved"
                                          };

                                          String jsonString = jsonEncode(payload);
                                       final response=await chatService.updateExchangeStatus(swap["exchangeId"]["_id"],jsonString);
                                          final data = response.data;
                                          print(data['message']);
                                          if(data['success']) {
                                            _fetchConversations();
                                            // setState(() {
                                            //   isAccepting=false;
                                            //   swap["exchangeId"]["status"] =
                                            //   "approved";
                                            // });
                                          }
                                        setState(() {
                                          isAccepting=false;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(20), // Rounded corners
                                        ),
                                        child: isAccepting ? Loading(): Text("Accept", style: TextStyle(color: Colors.white,fontSize: 10)),
                                      ),
                                    ),

                                  ],
                                )

                              ):Text(swap["exchangeId"]["status"].toString().toTitleCase),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                :SizedBox(),
              donationConversations.isNotEmpty ?
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,  // Ensures it takes only needed space
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: donationConversations.length,
                  itemBuilder: (context, index) {
                    var swap = donationConversations[index];
                    var donationItem = swap["participants"]["donationItem"];
                    // var recipientItem = swap["participants"]["recipientItem"];

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: donationItem["imageUrls"].isNotEmpty
                            ? Image.network(
                          donationItem["imageUrls"][0],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                            : Icon(Icons.image),
                        title: Text(
                            "${donationItem["title"]}"),
                        subtitle: Text(
                          truncateText(swap["lastMessage"]["content"] ?? "", 40),
                          overflow: TextOverflow.ellipsis, // Ensure it doesn't overflow
                        ),
                        trailing: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print("Accepted swap: ${swap["_id"]}");
                              },
                              child: Icon(Icons.check_circle, color: Colors.green), // Reduce icon size

                            ),
                            GestureDetector(
                              onTap: () {
                                print("Rejected swap: ${swap["_id"]}");
                              },
                              child: Icon(Icons.cancel, color: Colors.red,),
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                ),
              ):SizedBox()

            ],
          )
        ));
  }

 Widget? Leading(Message chat) {
   ChatItem?
   recipientItem=chat.exchangeId?.recipientItemId;
    if(recipientItem!=null && recipientItem.imageUrls!=null){
      if(recipientItem.imageUrls!.isEmpty){
        return null;
      }
      return CircleAvatar(
        backgroundImage: recipientItem.imageUrls !=
            null
            ? NetworkImage(recipientItem.imageUrls?.first)
            : null,
        child: recipientItem.imageUrls !=null
            ? Text(
          widget.chatUser.fullName.substring(0, 1)
              .toUpperCase(),
          style: TextStyle(color: Colors.white),
        )
            : null,
      );
    }

    return null;


 }
 Widget? Trailing(Message chat) {
   ChatItem?
   initiatorItem=chat.exchangeId?.initiatorItemId;
   if(initiatorItem!=null) {
     if (initiatorItem.imageUrls != null) {
       if (initiatorItem.imageUrls!.isEmpty) {
         return null;
       }
     }
     return CircleAvatar(
       backgroundImage: initiatorItem != null &&
           initiatorItem.imageUrls?.first !=
               null
           ? NetworkImage(initiatorItem.imageUrls?.first)
           : null,
       child: initiatorItem!.imageUrls?.first.isEmpty
           ? Text(
         widget.chatUser.fullName.substring(0, 1)
             .toUpperCase(),
         style: TextStyle(color: Colors.white),
       )
           : null,
     );
   }
 }
 
 /* Check if current logged in user is recipient or initiator
 
  */
 bool isRecipient(String recipientId){
    if(profileData.userId==recipientId){
      return true;
    }
    return false;
 }

}
