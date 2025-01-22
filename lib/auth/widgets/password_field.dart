import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/constants/app_constants.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;

  PasswordField({
    required this.controller,
    required this.label,
    required this.hintText,
  });

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObscured,
      controller: widget.controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (!AppConstants.passwordRegex.hasMatch(value)) {
          return 'Password must be at least 8 characters, include\n'
              'a capital letter, a number, and a special character.';
        }
        return null;
      },
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: widget.label,
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured; // Toggle password visibility
            });
          },
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: AppColors.hintColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: AppColors.primary, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: AppColors.primary, width: 1.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
      ),
    );
  }
}
