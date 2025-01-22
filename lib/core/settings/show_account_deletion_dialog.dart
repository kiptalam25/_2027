import 'package:flutter/material.dart';

Future<void> showAccountDeletionDialog(
  BuildContext context, {
  required void Function(String?, String) onSubmit, // Action for Submit button
  String? selectedReason, // Pass selected reason as parameter
  required Function(String?)
      onReasonChanged, // Callback to handle reason change
}) {
  // Controllers for the TextField and the Dropdown selection
  TextEditingController _reasonController = TextEditingController();

  // Predefined reasons for account deletion
  List<String> reasons = [
    "Privacy concerns",
    "No longer needed",
    "Too many ads",
    "Other"
  ];

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text("Account Deletion"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown for selecting the reason
                  DropdownButton<String>(
                    value: selectedReason,
                    hint: Text("Select Reason"),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedReason = newValue; // Update the selected reason
                      });
                      onReasonChanged(
                          newValue); // Call the callback to update reason
                    },
                    items:
                        reasons.map<DropdownMenuItem<String>>((String reason) {
                      return DropdownMenuItem<String>(
                        value: reason,
                        child: Text(reason),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),

                  // TextField for additional comments
                  TextField(
                    controller: _reasonController,
                    decoration: InputDecoration(
                      labelText: "Additional Comments (optional)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            actions: [
              // Cancel Button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Cancel"),
              ),
              // Submit Button
              TextButton(
                onPressed: () {
                  if (selectedReason != null) {
                    // Capture the additional comments
                    String additionalComments = _reasonController.text;

                    // Pass selected reason and additional comments in the callback
                    onSubmit(selectedReason, additionalComments);

                    Navigator.of(context).pop(); // Close the dialog
                  } else {
                    // Show a message if no reason is selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select a reason")),
                    );
                  }
                },
                child: Text("Submit"),
              ),
            ],
          );
        },
      );
    },
  );
}
