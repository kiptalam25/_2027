import 'package:flutter/material.dart';
import 'package:swapifymobile/extensions/string_casing_extension.dart';
import '../../../common/app_colors.dart';
import '../../usecases/SingleItem.dart';

class ReusableListView extends StatelessWidget {
  final List<SingleItem> items;
  final void Function(String detailsUrl)? onDetailsTap;

  const ReusableListView({
    Key? key,
    required this.items,
    this.onDetailsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: Container(
            // height: 150,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: item.imageUrls!.isNotEmpty
                      ? Image.network(
                          item.imageUrls![0],
                          fit: BoxFit.cover,
                          width: 130, // Set fixed width
                          height: 120, // Set fixed height
                        )
                      : Container(
                          width: 130, // Set fixed width
                          height: 120,
                          color: Colors.grey[300],
                          child: const Center(
                            child:
                                Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                        ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title.toTitleCase,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: AppColors.primary),
                                color: AppColors.smallBtnBackground,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(item.exchangeMethod.toTitleCase),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.pin_drop_outlined,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' 3Km', // Add space between icon and text
                                    style: TextStyle(
                                      color: Color(0xFF5e5e5e), // Text color
                                    ),
                                  ),
                                ],
                              ),
                              textAlign:
                                  TextAlign.right, // Align text to the right
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => onDetailsTap?.call(item.id),
                              child: Text(
                                'See Details',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            Icon(Icons.arrow_forward)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
