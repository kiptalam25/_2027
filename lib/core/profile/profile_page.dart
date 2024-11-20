import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/common/widgets/appbar/app_bar.dart';
import 'package:swapifymobile/core/main/widgets/bottom_navigation.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: true,
      ),
      body: BasePage(
        initialIndex: 3,
        child: Text("Hello Profile feature coming soon"),
      ),
    );
  }
}
