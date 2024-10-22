import 'package:flutter/material.dart';
import 'package:swapifymobile/common/widgets/appbar/app_bar.dart';

class AddItemPhoto extends StatefulWidget {
  const AddItemPhoto({Key? key}) : super(key: key);

  @override
  State<AddItemPhoto> createState() => _AddItemPhotoState();
}

class _AddItemPhotoState extends State<AddItemPhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(hideBack: true),
      body: SingleChildScrollView(
          child: Column(
        children: [],
      )),
    );
  }
}
