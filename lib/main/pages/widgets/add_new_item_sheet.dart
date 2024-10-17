import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';
import 'package:swapifymobile/core/config/themes/app_colors.dart';

class AddNewItemSheet extends StatefulWidget {
  @override
  _AddNewItemSheetState createState() => _AddNewItemSheetState();
}

class _AddNewItemSheetState extends State<AddNewItemSheet> {
  bool isBarterChecked = false;
  bool isDonationChecked = false;

  bool isFirstStep = true;

  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceRange = TextEditingController();
  String selectedCondition = 'New';
  String selectedCategory = 'Clothes';
  String selectedCategoryOfInterest = 'Bicycles';

  // Method to create JSON from the selected checkboxes
  String getCheckboxJson() {
    Map<String, bool> checkboxData = {
      'Barter': isBarterChecked,
      'Donation': isDonationChecked,
    };
    return jsonEncode(checkboxData);
  }

  // Method to create JSON from the selected items
  String getSelectedItemsAsJson() {
    Map<String, bool> selectedItems = {
      'Barter': isBarterChecked,
      'Donation': isDonationChecked,
    };
    return jsonEncode(selectedItems); // Convert map to JSON string
  }

  String getAdditionalFieldsJson() {
    Map<String, String> additionalData = {
      'Item Name': itemNameController.text,
      'Description': descriptionController.text,
      'Condition': selectedCondition,
      'Price Range': priceRange.text,
      'Category': selectedCategory,
      'Category of Interest': selectedCategoryOfInterest,
    };
    return jsonEncode(additionalData);
  }

  Widget _buildInputSection(
      String label, String hintText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 10),
        SizedBox(
          height: 36,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ),
      ],
    );
  }

  // Method to combine JSON objects
  String combineJson(String json1, String json2) {
    Map<String, dynamic> combinedData = {
      ...jsonDecode(json1),
      ...jsonDecode(json2),
    };
    return jsonEncode(combinedData);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom +
            16.0, // Adjust for keyboard
        left: 16.0,
        right: 16.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Makes the sheet's height flexible
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Center(
                  child: Container(
                    height: 3,
                    width: 40,
                    color: AppColors.dashColor, // Set the background color
                  ),
                ),
                const SizedBox(
                  height: 32,
                  child: Align(
                    alignment:
                        Alignment.bottomCenter, // Align the text at the bottom
                    child: Text(
                      'Add New Item',
                      style: TextStyle(fontSize: 16, color: AppColors.primary),
                    ),
                  ),
                ),
                Divider(
                  // Line under the title
                  color: AppColors.dividerColor, // Color of the line
                  thickness: 2, // Thickness of the line
                ),
              ],
            ),

            // const SizedBox(height: 48),
            if (isFirstStep) ...[
              CheckboxListTile(
                title: Text('Barter'),
                value: isBarterChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isBarterChecked = value ?? false;
                  });
                },
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: Text('Donation'),
                value: isDonationChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isDonationChecked = value ?? false;
                  });
                },
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              )
            ] else ...[
              _buildInputSection(
                  "Item Name*", "Enter item name", itemNameController),
              SizedBox(
                height: 16,
              ),
              // TextField(
              // controller: descriptionController,
              _buildInputSection("Description*", "Briefly describe the item",
                  descriptionController),
              // decoration: InputDecoration(labelText: 'Description'),
              // ),
              SizedBox(
                height: 16,
              ),
              DropdownButtonFormField<String>(
                value: selectedCondition,
                items: ['New', 'Used'].map((String condition) {
                  return DropdownMenuItem<String>(
                    value: condition,
                    child: Text(condition),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCondition = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Condition*'),
              ),
              const SizedBox(
                height: 16,
              ),
              _buildInputSection(
                  "Price Range", "Enter price range of the item", priceRange),
              // TextField(
              //   controller: priceRange,
              //   decoration: InputDecoration(labelText: 'Price Range'),
              // ),
              const SizedBox(
                height: 16,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: ['Clothes', 'Tools'].map((String condition) {
                  return DropdownMenuItem<String>(
                    value: condition,
                    child: Text(condition),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Item Category*'),
              ),
              const SizedBox(
                height: 16,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategoryOfInterest,
                items: ['Bicycles', 'Toys'].map((String condition) {
                  return DropdownMenuItem<String>(
                    value: condition,
                    child: Text(condition),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategoryOfInterest = newValue!;
                  });
                },
                decoration: const InputDecoration(
                    labelText: 'Categories of interest(Barter only)'),
              ),
              SizedBox(height: 16),
            ],

            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BasicAppButton(
                  title: isFirstStep ? "Next" : "Submit",
                  radius: 24,
                  height: 38,
                  width: MediaQuery.of(context).size.width,
                  // width: isFirstStep ? 300 : 160,
                  onPressed: () {
                    if (isFirstStep) {
                      // Move to the second step
                      setState(() {
                        isFirstStep = false;
                      });
                    } else {
                      String jsonCheckbox = getCheckboxJson();
                      String jsonAdditional = getAdditionalFieldsJson();
                      String finalJson =
                          combineJson(jsonCheckbox, jsonAdditional);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Final JSON: $finalJson'),
                          duration: Duration(
                              seconds:
                                  3), // Duration for how long the SnackBar will be visible
                        ),
                      );
                      Navigator.pop(context);
                    }
                    // String jsonSelectedItems = getSelectedItemsAsJson();
                    // print(jsonSelectedItems);
                    // Navigator.pop(context);
                  },
                ),
                if (!isFirstStep) ...[
                  BasicAppButton(
                    title: "Cancel",
                    width: MediaQuery.of(context).size.width,
                    radius: 24,
                    height: 38,
                    backgroundColor: AppColors.background,
                    textColor: AppColors.primary,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  // Spacer(),
                ],
              ],
            )
            // SizedBox(
            //   width: double.infinity, // Full-width button
            //   child: ElevatedButton(
            //     onPressed: () {
            //       String jsonSelectedItems = getSelectedItemsAsJson();
            //       print(jsonSelectedItems); // Print the JSON string to console
            //
            //       Navigator.pop(context); // Close the bottom sheet
            //     },
            //     child: Text('Submit'),
            //     style: ElevatedButton.styleFrom(
            //       padding: EdgeInsets.symmetric(vertical: 16),
            //       textStyle: TextStyle(fontSize: 18),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
