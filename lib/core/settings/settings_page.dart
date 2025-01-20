import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/auth/login/login_state.dart';
import 'package:swapifymobile/auth/models/response_model.dart';
import 'package:swapifymobile/common/widgets/app_bar.dart';
import 'package:swapifymobile/common/widgets/app_navigator.dart';
import 'package:swapifymobile/core/services/auth_service.dart';
import 'package:swapifymobile/core/services/settings_service.dart';
import 'package:swapifymobile/core/settings/change_password_tab.dart';
import 'package:swapifymobile/core/settings/show_account_deletion_dialog.dart';
import 'package:swapifymobile/core/welcome/splash/pages/welcome.dart';

import '../widgets/alert_dialog.dart';
import '../widgets/notification_popup.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsService settingsService = SettingsService(ApiClient());
  // final TextEditingController _reasonController = TextEditingController();
  // String? _selectedReason;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Account Settings'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Change Password'),
              Tab(text: 'Other Settings'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChangePasswordTab(),
            Center(
                child: ElevatedButton(
              onPressed: _handleDeleteAccount,
              child: Text('Delete Account'),
            )),
          ],
        ),
      ),
    );
  }

  String? _selectedReason;

  void _handleDeleteAccount() async {
    showAccountDeletionDialog(
      context,
      selectedReason: _selectedReason,
      onReasonChanged: (String? newReason) {
        setState(() {
          _selectedReason = newReason; // Update the selected reason
        });
      },
      onSubmit: (String? reason, String additionalComments) async {
        // Handle the submit action, e.g., delete the account
        if (reason != null) {
          ResponseModel response = await settingsService.deleteAccount();
          if (response.success) {
            StatusPopup.show(
              context,
              message: response.message,
              isSuccess: true,
            );

            AuthService authService = AuthService(ApiClient());
            var loggedOut = await authService.logout();
            if (loggedOut) {
              AppNavigator.pushAndRemove(context, WelcomePage());
            }
          } else {
            StatusPopup.show(
              context,
              message: "Failed to delete profile",
              isSuccess: false,
            );
          }
          print("Profile deleted");
        }
      },
    );
  }

  _confirmDelete() async {
    // showYesNoAlertDialog(
    //   context,
    //   title: "Delete Profile",
    //   message: "Are you sure you want to delete your profile?",
    //   onYesPressed: () async {
    ResponseModel response = await settingsService.deleteAccount();
    if (response.success) {
      StatusPopup.show(
        context,
        message: response.message,
        isSuccess: true,
      );
    } else {
      StatusPopup.show(
        context,
        message: "Failed to delete profile",
        isSuccess: true,
      );
    }
    print("Profile deleted");
    //   },
    //   onNoPressed: () {
    //     // Handle the "No" action (e.g., cancel deletion)
    //     print("Deletion cancelled");
    //   },
    // );
  }
}
