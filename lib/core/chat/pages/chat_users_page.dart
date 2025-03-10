import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/core/chat/pages/conversations_page.dart';
import 'package:swapifymobile/core/main/widgets/bottom_navigation.dart';
import 'package:swapifymobile/core/main/widgets/loading.dart';
import 'package:swapifymobile/core/services/chat_service.dart';

import '../../../common/app_colors.dart';
import '../../services/NetworkHelper.dart';
import '../../services/sharedpreference_service.dart';
import '../../usecases/conversation_response.dart';
import '../../usecases/profile_data.dart';
import '../../usecases/chat_user.dart';
import 'chat_page.dart';

class ChatUsersPage extends StatefulWidget {
  // final String conversationId;

  const ChatUsersPage({super.key});
  @override
  State<ChatUsersPage> createState() => _ChatUsersPageState();
}

class _ChatUsersPageState extends State<ChatUsersPage> {
  ProfileData profileData = ProfileData();

  bool loadingUsers = false;
  late List<ChatUser> users = [];
  final ChatService chatService = ChatService(new ApiClient());

  Future<void> loadProfileData() async {
    final data = await SharedPreferencesService.getProfileData();
    if (data != null) {
      setState(() {
        profileData = data;
      });
    }
  }

  Future<void> _fetchChatUsers() async {
    setState(() {
      loadingUsers = true;
    });
    try {
      final response = await chatService.fetchChatUsers();
      if (response != null && response.data != null) {
        final data = response.data;

        if (data['success'] == true) {
          final List<ChatUser> users1 = (data['users'] as List<dynamic>)
              .map((user) => ChatUser.fromJson(user)).toList();
          setState(() {
            users = users1;
          });
        }
      }
    } catch ($e) {
      setState(() {
        loadingUsers = false;
      });

      print($e);
    } finally {
      setState(() {
        loadingUsers = false;
      });
    }
  }

  @override
  void initState() {
    // NetworkHelper.checkInternetAndShowPopup(context);
    loadProfileData();
    _fetchChatUsers();
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
        appBar: AppBar(title: const Text("Users")),
        body: BasePage(
          initialIndex: 2,
          child: loadingUsers
              ? Loading()
              : users.isEmpty
              ? Center(
            child: Text("no conversations"),
          )
              : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              print(user.userId);
              print(profileData.userId);
              return ListTile(
                leading: user.userId ==
                    profileData.userId
                    ? CircleAvatar(
                  backgroundImage: user
                      .profilePicUrl !=
                      null
                      ? NetworkImage(user.profilePicUrl!)
                      : null,
                  child: user.profilePicUrl ==
                      null
                      ? Text(
                    user.fullName?? "No name".substring(0, 1)
                        .toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  )
                      : null,
                )
                    : CircleAvatar(
                  backgroundImage: user.profilePicUrl !=
                      null &&
                      user
                          .profilePicUrl!
                          .isNotEmpty
                      ? NetworkImage(user.profilePicUrl!)
                      : null,
                  child: user.profilePicUrl ==
                      null ||
                      user
                          .profilePicUrl!
                          .isEmpty
                      ? Text(
                    user.fullName ?? "No name"
                        .substring(0, 1)
                        .toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  )
                      : null,
                ),
                title: user.userId ==
                    profileData.userId
                    ? user.profilePicUrl !=
                    null
                    ? Text(user.fullName
                    .toString())
                    : Text("No Name")
                    : Text(user.fullName
                    .toString()),

                /*
                Show Number of Chats
                /
                 */
                subtitle: Column(children: [
                  user.swapId!.isNotEmpty ?
                  Text("Swaps: "+
                      user.swapId!.length.toString()
                  ):Text(""),
                  user.donationId!.isNotEmpty ?
                  Text("Donations: "+
                      user.donationId!.length.toString()
                  ):Text(""),
                ],),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
                onTap: () {
                  // Navigate to ChatPage with selected user
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConversationsPage(chatUser: user,conversationId: '',
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
