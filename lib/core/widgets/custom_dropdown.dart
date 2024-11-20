import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  // final List<String> items;
  final List<Map<String, String>> items;
  final String hintText;
  final void Function(String?)? onChanged;
  final EdgeInsets contentPadding;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText = '',
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((category) {
          return DropdownMenuItem<String>(
            value: category['id'],
            child: Text(category['name']!),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: hintText,
          contentPadding: contentPadding,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
