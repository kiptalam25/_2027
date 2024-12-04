import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/common/app_colors.dart';
import 'package:swapifymobile/common/widgets/basic_app_button.dart';

import '../../chat/pages/chatpage.dart';
import 'animated_dropdown.dart';

class MakeSwapOfferBottomsheet extends StatefulWidget {
  const MakeSwapOfferBottomsheet({Key? key}) : super(key: key);

  @override
  State<MakeSwapOfferBottomsheet> createState() =>
      _MakeSwapOfferBottomsheetState();
}

class _MakeSwapOfferBottomsheetState extends State<MakeSwapOfferBottomsheet> {
  final List<String> _items = ["Shoes", "Handbag", "Clothing"];
  String? _selectedItem;
  bool _isChecked = false;

  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Text(
                "This user wants",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                padding: EdgeInsets.all(4.0), // Text padding
                decoration: BoxDecoration(
                  color: AppColors.hintColor, // Background color
                  border: Border.all(
                    // Border
                    color: AppColors.primary,
                    width: 1.0,
                  ),
                  borderRadius:
                      BorderRadius.circular(8.0), // Rounded corners (optional)
                ),
                child: Text(
                  "Any article of clothing, a new pair of shoes or a hand bag",
                  style: TextStyle(
                    fontSize: 14.0, // Adjust text size
                    color: AppColors.primary, // Text color
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "What are you offering",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 4,
              ),
              AnimatedDropdown<String>(
                items: _items,
                selectedItem: _selectedItem,
                itemLabel: (item) => item, // Display item directly
                onItemSelected: (item) {
                  // Handle selection
                  _selectedItem = item;
                  print("Selected: $item");
                },
                placeholder: "Select an item",
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "I confirm that my item is in the user’s desired category",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              BasicAppButton(
                  height: 38,
                  title: "Make offer",
                  radius: 24,
                  onPressed: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConversationListPage()))
                      }),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ],
      ),
    );
  }
}
