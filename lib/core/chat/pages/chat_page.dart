import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/common/widgets/appbar/app_bar.dart';
import 'package:swapifymobile/core/main/widgets/bottom_navigation.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppbar(
          hideBack: true,
        ),
        body: BasePage(
          child: Text("Hello Chat feature coming soon"),
          initialIndex: 2,
        ));
  }
}
