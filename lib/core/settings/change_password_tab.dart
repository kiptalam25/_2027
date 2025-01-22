import 'package:flutter/material.dart';
import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/auth/models/response_model.dart';
import 'package:swapifymobile/core/services/settings_service.dart';

import '../widgets/notification_popup.dart';

class ChangePasswordTab extends StatefulWidget {
  @override
  _ChangePasswordTabState createState() => _ChangePasswordTabState();
}

class _ChangePasswordTabState extends State<ChangePasswordTab> {
  SettingsService settingsService = SettingsService(ApiClient());
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  Future<void> _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      // Simulate a password change process
      final oldPassword = _oldPasswordController.text;
      final newPassword = _newPasswordController.text;
      ResponseModel response =
          await settingsService.changePassword(oldPassword, newPassword);

      // Example validation (replace with actual backend call)
      if (response.success) {
        setState(() {
          isLoading = false;
        });
        // Old password is correct
        StatusPopup.show(
          context,
          message: response.message,
          isSuccess: true,
        );
      } else {
        setState(() {
          isLoading = false;
        });
        // Old password is incorrect
        StatusPopup.show(
          context,
          message: response.message,
          isSuccess: false,
        );
      }

      // Clear fields
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Old Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(24), // Border radius when enabled
                    // borderSide: BorderSide(color: Colors.grey), // Customize border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(24), // Border radius when focused
                    // borderSide: BorderSide(color: Colors.blue, width: 2), // Customize border color and thickness
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your old password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(24), // Border radius when enabled
                    // borderSide: BorderSide(color: Colors.grey), // Customize border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(24), // Border radius when focused
                    // borderSide: BorderSide(color: Colors.blue, width: 2), // Customize border color and thickness
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmNewPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(24), // Set border radius
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(24), // Border radius when enabled
                    // borderSide: BorderSide(color: Colors.grey), // Customize border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(24), // Border radius when focused
                    // borderSide: BorderSide(color: Colors.blue, width: 2), // Customize border color and thickness
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  } else if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Center(
                child: !isLoading
                    ? ElevatedButton(
                        onPressed: _handleChangePassword,
                        child: Text('Submit'),
                      )
                    : CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}
