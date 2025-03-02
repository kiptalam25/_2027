import 'package:flutter/material.dart';

import '../../common/app_colors.dart';

class InputSection extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final int maxCharacters;

  const InputSection({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.maxCharacters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   label,
        //   style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        // ),
        SizedBox(
          height: 16,
        ),
        SizedBox(
          height: maxCharacters > 0 ? 126 : 50,
          child: TextFormField(
            controller: controller,

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null; // Return null if validation passes
            },
            maxLength: maxCharacters > 0 ? maxCharacters : null,
            maxLines: maxCharacters > 0 ? 5 : 1, // Maximum lines before scroll
            minLines: maxCharacters > 0 ? 5 : 1, // Initial height for 5 lines
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              labelText: label,
              labelStyle: TextStyle(color: Colors.black), // Change label text color
              floatingLabelBehavior: FloatingLabelBehavior.always, // Keep label at the top
              hintStyle: TextStyle(color: Colors.grey), // Change hint text color if needed
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0), // Push text to the top
              // hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              // contentPadding:
              //     EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              counterText: '', // Hides the default Flutter counter
            ),
            onChanged: (text) {
              // Triggers UI update for character counter
            },
          ),
        ),
        if (maxCharacters > 0)
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 5),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${controller.text.length}/$maxCharacters',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }
}
