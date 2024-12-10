import 'package:flutter/material.dart';

import '../../common/app_colors.dart';

class StatusPopup {
  static void show(
    BuildContext context, {
    required String message,
    required bool isSuccess,
    int durationInSeconds = 3,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: durationInSeconds), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(); // Close the popup
          }
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSuccess ? Icons.check_circle_outline : Icons.error,
                color: isSuccess ? AppColors.success : Colors.red,
                size: 60,
              ),
              // SizedBox(height: 16),
              // Text(
              //   isSuccess ? "Success" : "Error",
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     color: isSuccess ? AppColors.successColor : Colors.red,
              //   ),
              // ),
              SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.of(context).pop(); // Close the popup
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: isSuccess ? AppColors.success : Colors.red,
              //   ),
              //   child: Text("OK"),
              // ),
            ],
          ),
        );
      },
    );
  }
}
