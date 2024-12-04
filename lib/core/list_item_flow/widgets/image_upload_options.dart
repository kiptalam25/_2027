import 'package:flutter/material.dart';
import 'package:swapifymobile/common/app_colors.dart';

class ImageUploadOptions extends StatelessWidget {
  final Function(String) onGestureSelected;

  const ImageUploadOptions({required this.onGestureSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom +
            16.0, // Adjust for keyboard
        left: 16.0,
        right: 16.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Makes the sheet's height flexible
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Center(
                  child: Container(
                    height: 3,
                    width: 40,
                    color: AppColors.dashColor, // Set the background color
                  ),
                ),
                const SizedBox(
                  height: 32,
                  child: Align(
                    alignment:
                        Alignment.bottomCenter, // Align the text at the bottom
                    child: Text(
                      'Add Photos',
                      style: TextStyle(fontSize: 16, color: AppColors.primary),
                    ),
                  ),
                ),
                Divider(
                  // Line under the title
                  color: AppColors.dividerColor, // Color of the line
                  thickness: 1, // Thickness of the line
                ),
                SizedBox(
                  height: 16,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => onGestureSelected('gallery'),
                      child: Row(
                        children: [
                          Icon(
                            Icons.image,
                            color: AppColors.primary,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Upload from gallery",
                            style: TextStyle(color: AppColors.primary),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () => onGestureSelected('camera'),
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: AppColors.primary,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text("Take a photo",
                              style: TextStyle(color: AppColors.primary))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
