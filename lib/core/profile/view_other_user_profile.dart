import 'package:flutter/material.dart';
import 'package:swapifymobile/common/widgets/app_bar.dart';
import 'package:swapifymobile/core/main/widgets/loading.dart';
import 'package:swapifymobile/core/usecases/other_user_profile.dart';

import '../../api_client/api_client.dart';
import '../../common/app_colors.dart';
import '../../common/widgets/app_navigator.dart';
import '../list_item_flow/widgets/list_view.dart';
import '../services/items_service.dart';
import '../services/profile_service.dart';
import '../usecases/SingleItem.dart';
import '../widgets/initial_circle.dart';

class ViewOtherUserProfile extends StatefulWidget {
  final String userId;
  const ViewOtherUserProfile({Key? key, required this.userId})
      : super(key: key);

  @override
  State<ViewOtherUserProfile> createState() => _ViewOtherUserProfileState();
}

class _ViewOtherUserProfileState extends State<ViewOtherUserProfile> {
  String truncateToFirstWord(String? fullName) {
    if (fullName == null || fullName.isEmpty) return '';
    return fullName.split(' ').first;
  }
   late OtherUserProfile otherUserProfile;

  final TextEditingController _searchController = TextEditingController();
  final ItemsService itemsService = ItemsService(ApiClient());

@override
  void initState() {
  _fetchPostersProfile(widget.userId);
  fetchUserItems(widget.userId);
    super.initState();
  }
  final ProfileService profileService = ProfileService(new ApiClient());

bool isLoading=false;
  // List<dynamic>  swapConversations= [];
  void fetchUserItems(String userId) async {
    setState(() {
      items = [];
      isLoading = true;
    });
    String keyword = _searchController.text;
    var response = await itemsService.fetchUserItems(userId);
    if (response != null) {
      var data=response.data;
      if (data['success'] == true) {
        print(
            "...............................................................................");
        print(response.data['data']['items'].toString());
        setState(() {
          items=data['data']['items'];
          // items = (data['data']['items'] as List)
          //     .map((item) => SingleItem.fromJson(item))
          //     .toList();
          filteredItems = items;
        });
      }
      setState(() {
        isLoading = false;
      });
      final responseData = response.data;

      if (responseData['success'] == true) {
        setState(() {
          items = (responseData['items'] as List)
              .map((item) => SingleItem.fromJson(item))
              .toList();
          items=data['data']['items'];
          filteredItems = items;
        });
      } else {
        print('Request failed with message: ${responseData["message"]}');
      }
    } else {
      print('Service returned null');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchPostersProfile(String createdBy) async {
    setState(() {
      isLoading=true;
    });
    OtherUserProfile? otherUserProfile1 =
    await profileService.fetchOtherUserProfile(createdBy);
    setState(() {
      isLoading=false;
      otherUserProfile = otherUserProfile1!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: false,
      ),
      body: isLoading
          ? Loading()
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                truncateToFirstWord(otherUserProfile.fullName) + "'s Profile",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            _userInfo(),
            SizedBox(height: 12),
            _switchBtns(), // No need for extra Column

            Expanded(
              child: filteredItems.isNotEmpty
                  ? ListView.builder( // ✅ Removed `Flexible` & `NeverScrollableScrollPhysics()`
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  var item = filteredItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile(
                      title: Text(item['title']),
                    ),
                  );
                },
              )
                  : isLoading
                  ? Center(
                child: SizedBox(
                  height: 40, // ✅ Larger spinner
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              )
                  : Center(child: Text("No items found")),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );

  }

  late List<dynamic> items = [];
  List<dynamic> filteredItems = [];
  bool isBarter = true;


  void filterItems(String query) {
    setState(() {
      // Filter items where exchangeMethod is 'both' or contains the query
      filteredItems = items.where((item) {
        return item.exchangeMethod.toLowerCase() == "both" ||
            item.exchangeMethod.toLowerCase().contains(query.toLowerCase());
      }).toList();

      // Sort the items so that those with 'both' come first
      filteredItems.sort((a, b) {
        if (a.exchangeMethod.toLowerCase() == query) {
          return -1;
        } else if (b.exchangeMethod.toLowerCase() == query) {
          return 1;
        }
        return 0; // No change in order for other items
      });
    });
  }

  Widget _switchBtns() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
        onPressed: () {
          filterItems('swap');
          setState(() {
            isBarter = true;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isBarter
              ? AppColors.primary
              : AppColors.background, // Use passed background color or fallback
          minimumSize: Size(MediaQuery.of(context).size.width * .4, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10)), // Rounded corners
          ),
        ),
        child: Text(
          "Barter",
          style: TextStyle(
            color: isBarter ? AppColors.background : AppColors.primary,
          ),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          filterItems('donation');
          setState(() {
            isBarter = false;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isBarter
              ? AppColors.background
              : AppColors.primary, // Use passed background color or fallback
          minimumSize: Size(MediaQuery.of(context).size.width * .4, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10)), // Rounded corners
          ),
        ),
        child: Text(
          "Donation",
          style: TextStyle(
            color: isBarter ? AppColors.primary : AppColors.background,
          ),
        ),
      )
    ]);
  }


  Widget _userInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200, // Fallback color
                  ),
                ),
                ClipOval(
                  child: Image.network(
                    otherUserProfile.profilePicUrl.toString(),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return InitialCircle(
                        text: otherUserProfile.fullName.toString(), // Show initials
                        color: AppColors.primary,
                        size: 60.0,
                        textStyle: TextStyle(fontSize: 30, color: Colors.white),
                      );
                    },
                  ),

                ),
              ],
            ),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(otherUserProfile.fullName.toString()),
                Text("Complete Swaps: "+otherUserProfile.completedSwapCount.toString())
              ],
            )
          ],
        ),
      ],
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
