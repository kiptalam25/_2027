import 'package:flutter/material.dart';
import 'package:swapifymobile/common/widgets/app_bar.dart';
import 'package:swapifymobile/common/widgets/app_navigator.dart';
import 'package:swapifymobile/common/widgets/basic_app_button.dart';
import 'package:swapifymobile/core/main/pages/make_swap_offer_bottomsheet.dart';
import 'package:swapifymobile/core/profile/view_other_user_profile.dart';
import 'package:swapifymobile/core/services/profile_service.dart';
import 'package:swapifymobile/core/usecases/item.dart';
import 'package:swapifymobile/core/usecases/other_user_profile.dart';
import 'package:swapifymobile/extensions/string_casing_extension.dart';
import '../../../api_client/api_client.dart';
import '../../../common/app_colors.dart';
import '../../services/items_service.dart';
import '../../usecases/SingleItem.dart';
import '../../widgets/initial_circle.dart';
import '../widgets/images_display.dart';

class ProductDescription extends StatefulWidget {
  // final String itemId;
  final Item item;
  const ProductDescription({Key? key, required this.item}) : super(key: key);

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  final PageController _pageController = PageController();
  final ItemsService itemsService = ItemsService(new ApiClient());
  OtherUserProfile? otherUserProfile;

  // SingleItem? item;
  bool isLoading = true;
  bool isSwap = false;
  String exchangeMethod="";
  bool isDonation = false;

  List<Map<String, String>> preferredItems = [
    {'id': 'estonia', 'name': 'Estonia'},
    {'id': 'finland', 'name': 'Finland'},
  ];
  void showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an Option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the popup
                  isSwap = true;
                  setState(() {
                    exchangeMethod = "swap";
                  });
                  showBottomSheet();
                },
                child: Text("Swap"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the popup
                  isDonation = true;
                  setState(() {
                    exchangeMethod = "donation";
                  });
                  print("Donation selected");
                  showBottomSheet();
                },
                child: Text("Donation"),
              ),
            ],
          ),
        );
      },
    );
  }

  int _currentPage = 0;
  // late List<String> _images = [
  //   'https://via.placeholder.com/300x200.png?text=Image+1',
  // ];

  @override
  void initState() {
    print("------------------------------------------------------------");
    print(widget.item.swapInterests);
    print(widget.item.imageUrls);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
        // _images=widget.item.imageUrls;
      });

    });
    // _fetchItem(widget.itemId);
    super.initState();
  }



  // Future<void> _fetchItem(String itemId) async {
  //   try {
  //     SingleItem item1 = await itemsService.fetchItem(itemId);
  //
  //     setState(() {
  //       item = item1;
  //       isLoading = false;
  //       _images = item!.imageUrls!;
  //       exchangeMethod==item1.exchangeMethod;
  //     });
  //     _fetchPostersProfile(item1.createdBy);
  //     // print('Item ID: ${item?.id}');
  //     // print('Tags: ${item?.tags}');
  //     // print('Images: ${item?.imageUrls}');
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error fetching item: $e'),
  //       ),
  //     );
  //     print('Error fetching item: $e');
  //   }
  // }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: BasicAppbar(),
        body: Scaffold(
            body:
            // isLoading
            //     ? Center(
            //         child: SizedBox(
            //           height: 20,
            //           width: 20,
            //           child: CircularProgressIndicator(),
            //         ),
            //       )
            //     : widget.item == null
            //         ? Center(
            //             child: Text("No item to show"),
            //           )
            //         :
            SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.item!.title.toTitleCase,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Text("Item listed for:"),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.0,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors.primary),
                                              color:
                                                  AppColors.smallBtnBackground,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Text(
                                              widget.item!.exchangeMethod == 'both'
                                                  ? 'Barter & Donation'
                                                  : widget.item!.exchangeMethod
                                                      .toTitleCase,
                                              style: TextStyle(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.pin_drop_outlined,
                                            color: AppColors.primary,
                                          ),
                                          Text(widget.item.location.city!.toCapitalized,
                                            style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          color: AppColors.dashColor,
                                          height: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ImagesDisplay(
                                          images: widget.item.imageUrls.isNotEmpty ? widget.item.imageUrls : ['https://via.placeholder.com/300x200.png?text=Image+1'],
                                          showRemoveButton: false,
                                        ),
                                        // _imagesDisplay(),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Product description",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: screenHeight * 0.001),
                                      Text(
                                        widget.item!.description.toCapitalized,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Product condition",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget.item!.condition.toTitleCase,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        "Category",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget.item!.categoryId.name,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        "Sub Category",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget.item!.subCategoryId.name,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: screenHeight * 0.009),
                                      Text(
                                        "Preferred item to swap",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                     getInterestsWidgets(),
                                      SizedBox(height: screenHeight * 0.02),
                                      SizedBox(height: screenHeight * 0.02),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Text(
                                          //   "Preferred item to swap",
                                          //   style: TextStyle(
                                          //       fontSize: 16.0,
                                          //       fontWeight: FontWeight.bold),
                                          // ),
                                          // getInterestsWidgets(),
                                          SizedBox(height: screenHeight * 0.02),
                                          // SizedBox(height: screenHeight * 0.02),
                                          _addToWishlistBtn(),
                                          _postersInformation("posterId")
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      )));
  }

  Widget getInterestsWidgets() {
    var strings = widget.item!.swapInterests;

    if (widget.item?.swapInterests == null) {
      return const SizedBox.shrink();
    }

    List<Widget> list = [];
    for (var i = 0; i < strings!.length; i++) {
      list.add(
      //     Text(
      //   strings[i].toTitleCase,
      //   // softWrap: true,
      // )
      GestureDetector(
        onTap: () {},
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 10.0,
                                                          vertical: 4.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius.circular(12.0),
                                                      ),
                                                      child:  Text(
                                                          strings[i].toTitleCase,
                                                        style: TextStyle(
                                                          color: Colors
                                                              .white, // Change text color as needed
                                                        ),
                                                      ),
                                                    ),
                                                  )

      );
    }

    return Row(
      children: list,
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }

  showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(
              // bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
          child: SingleChildScrollView(
              child: MakeSwapOfferBottomsheet(
                  recipientItem: widget.item, exchangeMethod: exchangeMethod)),
        );
      },
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      // borderRadius: BorderRadius.zero),
      isScrollControlled: true,
    );
  }

  Widget _addToWishlistBtn() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BasicAppButton(
          onPressed: () {
            if (widget.item!.exchangeMethod == "both") {
              showPopup(context);
            } else {
              exchangeMethod = widget.item!.exchangeMethod;
              showBottomSheet();
            }

            // }
          },
          backgroundColor: AppColors.primary,
          title: widget.item?.exchangeMethod=="swap" ? "Make Swap Offer" : widget.item?.exchangeMethod=="both" ? "Make Request":"Make Donation Request",
          radius: 24,
          textColor: AppColors.background,
        ),
        SizedBox(
          height: 10,
        ),
        BasicAppButton(
          onPressed: () {},
          backgroundColor: AppColors.background,
          radius: 24,
          title: "Add to Wishlist",
          textColor: AppColors.primary,
        ),
        // _continueButton(context),
        // ElevatedButton(
        //   onPressed: () {
        //     // AppNavigator.push(context, const EnterPasswordPage());
        //   },
        //   style: ElevatedButton.styleFrom(
        //     // padding: EdgeInsets.symmetric(vertical: 16),
        //     backgroundColor: Color(0xFF50644C),
        //
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //   ),
        //   child: Text(
        //     'Make swap offer',
        //     style: TextStyle(fontSize: 18, color: Colors.white),
        //   ),
        // )
      ],
    );
  }

  Widget _postersInformation(String posterId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 16,
        ),
        const Text(
          "Poster's information",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Padding(
                padding: EdgeInsets.all(2.0),
                // child:
                // CircleAvatar(
                // radius: 20,
                // backgroundColor: AppColors.primary,
                child: widget.item.userId!.profile!.fullName != "empty"
                    ? InitialCircle(
                        text: widget.item.userId!.profile!.fullName
                            .toString(), // Pass the full text here
                        color: AppColors.primary,
                        size: 50.0,
                        textStyle: TextStyle(fontSize: 30, color: Colors.white),
                      )
                    : Text("Profile not found")
                // Text(
                //               'W',
                //               style: TextStyle(
                //                 color: Colors.white, // Text color
                //                 fontSize: 20, // Font size
                //                 // fontWeight: FontWeight.bold, // Text weight
                //               ),
                //             ),
                // ),
                ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.item.userId!.profile!.fullName != "empty") ...[
                  Text(
                    widget.item.userId!.profile!.fullName.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ],
                if (widget.item.userId!.profile!.fullName != "empty") ...[
                  GestureDetector(
                    onTap: () {
                      viewOtherUserProfile();
                    },
                    child: Row(
                      children: [
                        Text(
                          "View profile",
                          style:
                              TextStyle(fontSize: 14, color: AppColors.primary),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: AppColors.primary,
                          size: 14,
                          weight: 700,
                        )
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  void viewOtherUserProfile() {
    AppNavigator.pushReplacement(
        context, ViewOtherUserProfile(userId: widget.item.userId!.id!));
  }
}
