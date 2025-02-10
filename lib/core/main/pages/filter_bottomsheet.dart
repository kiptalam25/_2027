import 'package:flutter/material.dart';
import '../../../api_client/api_client.dart';
import '../../../common/app_colors.dart';
import '../../../common/widgets/basic_app_button.dart';
import '../../services/category_service.dart';
import '../../widgets/custom_dropdown.dart';
import '../widgets/loading.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final CategoryService categoryService = CategoryService(ApiClient());
  List<Map<String, String>> _categories = [];
  late String? selectedCategory1 = "";
  bool isBarterChecked = false;
  bool isDonationChecked = false;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCategories();
  }
  Future<void> _fetchCategories() async {
    List<Map<String, String>> categories =
    await categoryService.fetchCategories();
    setState(() {
      _categories = categories;

      if (_categories.isNotEmpty) {
        // selectedCondition = _conditions.first['id']!;
        selectedCategory1 = _categories.first['id']!;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: Text(
                'Filter Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(height: 20),
            Text("By Category:"),
            _categories.isEmpty
                ? Loading()
                : CustomDropdown(
              items: _categories,
              // hintText: 'Item Category*',
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory1 = newValue!;
                });
              }, value: selectedCategory1,
            ),
            Text("By Condition:")
            ,_categories.isEmpty
                ? Loading()
                : CustomDropdown(
              items: _categories,
              // hintText: 'Item Category*',
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory1 = newValue!;
                });
              }, value: selectedCategory1,
            ),
            CheckboxListTile(
              title: Text('Barter'),
              value: isBarterChecked,
              onChanged: (bool? value) {
                setState(() {
                  isBarterChecked = value ?? false;
                });
              },
              activeColor: AppColors.primary,
              checkColor: Colors.white,
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
              activeColor: AppColors.primary,
              checkColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: BasicAppButton(
                    onPressed: () {
                    },
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    title: "Cancel",
                    radius: 24,
                    backgroundColor: AppColors.background,
                    textColor: AppColors.primary,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 1,
                  child: BasicAppButton(
                      height: 40,
                      radius: 24,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      content: Text(
                        "Save",
                        style: TextStyle(
                            color: AppColors.background),
                      )),
                ),
              ],
            )
            // ElevatedButton(
            //   onPressed: () => Navigator.pop(context),
            //   child: Text('Close'),
            // ),
          ],
        ),
      ),
    );
  }
}