import 'package:flutter/material.dart';
import 'package:swapifymobile/core/config/themes/app_colors.dart';

class SingleColumnGrid extends StatelessWidget {
  final List<String> items;
  final Function(String) onTap;
  final double spacing;

  const SingleColumnGrid({
    Key? key,
    required this.items,
    required this.onTap,
    this.spacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () => onTap(item),
                child: Column(
                  children: [_row(context, item)],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _row(BuildContext context, item) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align children to the start
        children: [
          // Image
          SizedBox(
            width: MediaQuery.of(context).size.width /
                2.5, // Adjust size for better fit
            child: Image.asset(
              "images/home_images/m1.png",
              fit: BoxFit.cover, // Ensure the image covers the space properly
            ),
          ),
          SizedBox(width: 4.0),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the left
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Nike Samba",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Barter"), Text("1Km")],
                ),
                SizedBox(height: 2.0), // Space below the first row
                GestureDetector(
                  onTap: () => onTap(item), // Trigger the onTap callback
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "See details",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
                      Icon(Icons.arrow_forward),
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
  //
  //   GridView.builder(
  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //     crossAxisCount: 1,
  //     mainAxisSpacing: spacing,
  //   ),
  //   itemCount: items.length,
  //   itemBuilder: (context, index) {
  //     final item = items[index];
  //     return Container(
  //       margin: EdgeInsets.symmetric(
  //           vertical: 4.0), // Vertical spacing between cards
  //       padding: EdgeInsets.all(8.0), // Padding inside the card
  //       color: Colors.red,
  //       // constraints: BoxConstraints(
  //       //   // Limit the height and width
  //       //   maxHeight: 80, // Set a maximum height
  //       //   minHeight: 60, // Set a minimum height
  //       // ),
  //       child:
  //     );
  //   },
  // );
}
