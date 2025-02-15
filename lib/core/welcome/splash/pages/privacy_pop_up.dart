import 'package:flutter/material.dart';
import 'package:swapifymobile/common/app_colors.dart';
import 'package:swapifymobile/core/main/widgets/loading.dart';
import 'package:swapifymobile/core/services/policy_service.dart';

class PrivacyPolicyPopup extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onContinue;

  const PrivacyPolicyPopup({
    Key? key,
    required this.onCancel,
    required this.onContinue,
  }) : super(key: key);

  @override
  _PrivacyPolicyPopupState createState() => _PrivacyPolicyPopupState();
}

class _PrivacyPolicyPopupState extends State<PrivacyPolicyPopup> {
  bool isChecked = false;
  bool ageChecked = false;
  bool fetchingPolicy = false;

  late Map<String, dynamic> pp;
  late Map<String, dynamic> privacyPolicy;
  late Map<String, dynamic> termsOfUse;

  Future<void> fetchPolicy() async {
    setState(() {
      fetchingPolicy = true;
    });
    try {
      final response = await PolicyService().fetchPolicy();
      if (response?.data != null) {
        final data = response?.data;
        if (data['success'] == true) {
          print("=========================================");
          // print(data["data"]["privacyPolicy"]);
          // pp = data["data"];
          // print(pp);
          setState(() {
            pp = data["data"];
            privacyPolicy =
                pp['privacyPolicy']['sections'] as Map<String, dynamic>;
            termsOfUse = pp['termsOfUse']['sections'] as Map<String, dynamic>;
          });
        }
      }
    } catch ($e) {
    } finally {
      setState(() {
        privacyPolicy={};
        fetchingPolicy = false;
      });
    }
  }

  @override
  void initState() {
    privacyPolicy={};
    fetchPolicy();
    super.initState();
  }
  // final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    // if (pp.isNotEmpty)
    // final privacyPolicy =
    //     pp!['privacyPolicy']['sections'] as Map<String, dynamic>;
    // final termsOfUse = pp!['termsOfUse']['sections'] as Map<String, dynamic>;

    return Scaffold(
      body: fetchingPolicy
          ? Loading()
          : privacyPolicy !=null ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionTitle('Privacy Policy'),
                  ...privacyPolicy.entries.map((entry) {
                    return buildSection(entry.key, entry.value);
                  }).toList(),
                  buildSectionTitle('Terms of Use'),
                  ...termsOfUse.entries.map((entry) {
                    return buildSection(entry.key, entry.value);
                  }).toList(),
                  accept()
                ],
              ),
            ):Text("Policy Loading Failed!\n Check Your Connection"),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildSection(String title, dynamic content) {
    if (content is String) {
      // If the content is a simple string, display it directly.
      return ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      );
    } else if (content is Map<String, dynamic>) {
      // If the content is a nested map, use ExpansionTile.
      return ExpansionTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        children: content.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            subtitle: Text(entry.value.toString()),
          );
        }).toList(),
      );
    } else if (content is List<dynamic>) {
      // If the content is a list, display it as a list of items.
      return ExpansionTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        children: content.map((item) {
          return ListTile(
            title: Text(item),
          );
        }).toList(),
      );
    }
    return SizedBox.shrink(); // Fallback for unknown content type.
  }

  Widget accept() {
    return Column(
      children: [
        Column(
          children: [
            CheckboxListTile(
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
                });
              },
              title: Text('I accept the Privacy Policy'),
              activeColor: AppColors.primary,
              checkColor: Colors.white,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              value: ageChecked,
              // checkColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  ageChecked = value!;
                });
              },
              title: Text('I am at least 16 Years Old'),
              activeColor: AppColors.primary,
              checkColor: Colors.white,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
        SizedBox(height: 16),
        Column(
          children: [
            ElevatedButton(
              onPressed: isChecked && ageChecked ? widget.onContinue : () {},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 46),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                backgroundColor: isChecked && ageChecked
                    ? AppColors.primary
                    : AppColors.fadedButton,
              ),
              child: Text(
                'Continue',
                style: TextStyle(color: AppColors.background),
              ),
            ),
            // onPressed: isChecked && ageChecked ? widget.onContinue : null),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: widget.onCancel,
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.primary),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 46),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
