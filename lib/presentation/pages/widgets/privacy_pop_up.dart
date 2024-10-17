import 'package:flutter/material.dart';
import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';
import 'package:swapifymobile/core/config/themes/app_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Privacy Policy & Agreement',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        // Scrollable text container
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              'Please read and accept our privacy policy before continuing.\n'
                      'The Procuring Entity as defined in the TDS invites tenders for'
                      'supply of goods and, if applicable, any Related Services incidental'
                      'thereto, as specified in Section V, Supply Requirements. The name,'
                      'identification, and number of lots (contracts) of this Tender'
                      'Document are specified in the TDS' *
                  10, // Long text to demonstrate scrolling
              textAlign: TextAlign.left,
            ),
          ),
        ),
        CheckboxListTile(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
            });
          },
          title: Text('I accept the Privacy Policy'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
            });
          },
          title: Text('I am atleast 16 Years Old'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        SizedBox(height: 16),
        Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 46),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: isChecked ? widget.onContinue : null,
              child: Text('Continue'),
            ),
            SizedBox(
              height: 16,
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
