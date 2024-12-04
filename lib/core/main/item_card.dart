import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/common/widgets/app_navigator.dart';
import 'package:swapifymobile/core/main/pages/product_description.dart';
import 'package:swapifymobile/extensions/string_casing_extension.dart';
import '../../common/app_colors.dart';
import '../usecases/item.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: item.imageUrls.isNotEmpty
                  ? Image.network(
                      item.imageUrls[0], // Use the first image URL
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
            ),
          ),
          // Title and Exchange Method
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: const Divider(
                    // Line under the title
                    color: AppColors.dividerColor, // Color of the line
                    thickness: 2, // Thickness of the line
                  ),
                ),
                Text(
                  item.title.toTitleCase,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      // flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: AppColors.primary),
                          color: AppColors.smallBtnBackground,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(item.exchangeMethod.toCapitalized),
                      ),
                    ),
                    Flexible(
                      // flex: 1,
                      child: Text.rich(
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
                              text: ' 3Km', // Add space between icon and text
                              style: TextStyle(
                                color: Color(0xFF5e5e5e), // Text color
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    AppNavigator.push(
                        context, ProductDescription(itemId: item.id));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text(
                        "See details",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
