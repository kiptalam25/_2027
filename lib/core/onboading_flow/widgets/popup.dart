import 'package:flutter/material.dart';
import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';

import '../../config/themes/app_colors.dart';
import '../../../main/pages/home.dart';

void showCustomModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(12.0),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        width: double.infinity, // Full width for the modal sheet
        height: 276, // Height
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Verification message
            const Text(
              'Verification Complete',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Great Job! You are all set!!',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Tick icon
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.primary,
              size: 80,
            ),
            BasicAppButton(
              title: "Start Swapping",
              radius: 24,
              height: 46,
              onPressed: () {
                Navigator.of(context).pop(); // Close the modal
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
          ],
        ),
      );
    },
  );
}

// import 'package:flutter/material.dart';
// import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';
//
// import '../../core/config/themes/app_colors.dart';
// import '../../core/onboading_flow/choose_categories.dart';
// import '../../main/pages/home.dart';
//
// void showCustomPopup(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: Container(
//           width: 390, // Width
//           height: 276, // Height
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Verification message
//               Text(
//                 'Verification Complete',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 'Great Job! You are all set!!',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: AppColors.primary,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               // Tick icon
//               Icon(
//                 Icons.check_circle_rounded,
//                 color: AppColors.primary,
//                 size: 80,
//               ),
//               BasicAppButton(
//                 title: "Start Swapping",
//                 radius: 24,
//                 height: 38,
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => HomePage()));
//                 },
//               )
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
