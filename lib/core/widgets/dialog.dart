import 'package:flutter/material.dart';

void showAutoDismissDialog({
  required BuildContext context,
  required String title,
  required String message,
  Duration duration = const Duration(seconds: 2),
}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      Future.delayed(duration, () {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop(); // Close the dialog
        }
      });

      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          // TextButton(
          //   onPressed: () {
          //     Navigator.of(context).pop(); // Close the dialog manually
          //   },
          //   child: Text('Close Now'),
          // ),
        ],
      );
    },
  );
}
