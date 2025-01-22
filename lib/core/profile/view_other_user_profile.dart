import 'package:flutter/material.dart';
import 'package:swapifymobile/common/widgets/app_bar.dart';
import 'package:swapifymobile/core/usecases/other_user_profile.dart';

import '../../common/app_colors.dart';

class ViewOtherUserProfile extends StatelessWidget {
  final OtherUserProfile otherUserProfile;
  const ViewOtherUserProfile({Key? key, required this.otherUserProfile})
      : super(key: key);
  String truncateToFirstWord(String? fullName) {
    if (fullName == null || fullName.isEmpty) return '';
    return fullName.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                    truncateToFirstWord(otherUserProfile.fullName) +
                        "'s Profile",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              // Text("Full Name: "),
              // Text(otherUserProfile.fullName),
              _buildProfileImageSection(),
              SizedBox(
                height: 16,
              ),

              Text("Listed Items", style: TextStyle(fontSize: 16)),
              Text(otherUserProfile.listedItemCount.toString()),
              SizedBox(
                height: 16,
              ),
              Text("Completed Donations", style: TextStyle(fontSize: 16)),
              Text(
                otherUserProfile.completedSwapCount.toString(),
              ),
              SizedBox(
                height: 16,
              ),
              Text("Bio", style: TextStyle(fontSize: 16)),
              Text(otherUserProfile.bio.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Row(
      children: [
        Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                      image: NetworkImage(
                          otherUserProfile.profilePicUrl.toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (otherUserProfile.profilePicUrl == "") ...[
                  Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Icon(
                        Icons.person_outline,
                        size: 32,
                        color: AppColors.primary,
                      )),
                ],
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(otherUserProfile.fullName.toString(),
                  style: TextStyle(fontSize: 20)),
              Text(
                  "Swaps Completed " +
                      otherUserProfile.completedSwapCount.toString(),
                  style: TextStyle(fontSize: 16)),
              // Text("Items " + otherUserProfile.listedItemCount.toString(),
              //     style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }
}
