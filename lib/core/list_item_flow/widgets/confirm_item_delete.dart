import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';

import '../../config/themes/app_colors.dart';

class ConfirmItemDelete extends StatelessWidget {
  final VoidCallback? onConfirmDelete;
  const ConfirmItemDelete({Key? key, this.onConfirmDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              "Delete Item",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            color: AppColors.dashColor,
            height: 1,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Deleting this item will remove it from your listed items permanently.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                  flex: 1,
                  child: BasicAppButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    height: 37,
                    radius: 24,
                    backgroundColor: AppColors.background,
                    textColor: AppColors.primary,
                    title: "Cancel",
                  )),
              SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      onConfirmDelete?.call();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deleteBtn,
                    ),
                    child: Text(
                      'Delete anyway',
                      style: TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
