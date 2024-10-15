import 'package:flutter/material.dart';
import 'package:swapifymobile/core/onboading_flow/create_account.dart';

/// ** Made with love by kiptalam for swapify.ee
/// This file consists of onboading flow as per the figma file
///
///
class OnboardFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Registration(currentPage: 0),
    );
  }
}
