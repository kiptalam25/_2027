import 'package:flutter/material.dart';

Future<void> showYesNoAlertDialog(
  {
    required BuildContext context,
    required String title,
  required String message,
  required VoidCallback onYesPressed, // Action for Yes button
  required VoidCallback onNoPressed, // Action for No button
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              onNoPressed();
              Navigator.of(context).pop();
            },
            child: Text("No", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              onYesPressed();
              Navigator.of(context).pop();
            },
            child: Text("Yes", style: TextStyle(color: Colors.green)),
          ),
        ],
      );
    },
  );
}
