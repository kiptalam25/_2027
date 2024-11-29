import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swapifymobile/common/widgets/appbar/app_bar.dart';
import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';
import 'package:swapifymobile/extensions/string_casing_extension.dart';
import '../../../api_client/api_client.dart';
import '../../config/themes/app_colors.dart';
import '../../services/items_service.dart';
import '../../usecases/item.dart';
import '../../widgets/custom_dropdown.dart';
import '../widgets/images_display.dart';

class ProductDescription extends StatefulWidget {
  final String itemId;
  const ProductDescription({Key? key, required this.itemId}) : super(key: key);

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  final PageController _pageController = PageController();
  final ItemsService itemsService = ItemsService(new ApiClient());

  Item? item;
  bool isLoading = true;

  List<Map<String, String>> preferredItems = [
    {'id': 'estonia', 'name': 'Estonia'},
    {'id': 'finland', 'name': 'Finland'},
  ];

  int _currentPage = 0;
  late List<String> _images = [
    'https://via.placeholder.com/300x200.png?text=Image+1',
  ];

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
    _fetchItem(widget.itemId);
    super.initState();
  }

  Future<void> _fetchItem(String itemId) async {
    try {
      Item item1 = await itemsService.fetchItem(itemId);
      setState(() {
        item = item1;
        isLoading = false;
        _images = item!.imageUrls;
      });
      // print('Item Title: ${item?.title}');
      // print('Item ID: ${item?.id}');
      // print('Tags: ${item?.tags}');
      // print('Images: ${item?.imageUrls}');
    } catch (e) {
      isLoading = false;
      print('Error fetching item: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: BasicAppbar(),
        body: Scaffold(
            body: SingleChildScrollView(
          child: isLoading
              ? Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                )
              : item == null
                  ? Center(
                      child: Text("No item to show"),
                    )
                  : Container(
                      width: double.infinity,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item!.title.toTitleCase,
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
                                          color: AppColors.smallBtnBackground,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Text(
                                          item!.exchangeMethod == 'both'
                                              ? 'Barter & Donation'
                                              : item!
                                                  .exchangeMethod.toTitleCase,
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
                                      Text(
                                        "3km",
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
                                      images: _images,
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
                                    item!.description.toCapitalized,
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
                                    item!.condition.toTitleCase,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: screenHeight * 0.009),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      // Expanded(
                                      SizedBox(
                                          child:
                                              Image.asset("images/sticky.png")),
                                      SizedBox(height: screenHeight * 0.02),
                                      GestureDetector(
                                        onTap: () {
                                          // Handle click event here
                                          print('Firetruck clicked!');
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: const Text(
                                            "Baby things",
                                            style: TextStyle(
                                              color: Colors
                                                  .white, // Change text color as needed
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      // Expanded(
                                      //     flex: 1,
                                      GestureDetector(
                                        onTap: () {
                                          // Handle click event here
                                          print('Firetruck clicked!');
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: const Text(
                                            "Kids toys",
                                            style: TextStyle(
                                              color: Colors
                                                  .white, // Change text color as needed
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      // Expanded(
                                      //     flex: 1,
                                      GestureDetector(
                                        onTap: () {
                                          // Handle click event here
                                          print('Firetruck clicked!');
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: const Text(
                                            "Firetruck",
                                            style: TextStyle(
                                              color: Colors
                                                  .white, // Change text color as needed
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  SizedBox(height: screenHeight * 0.02),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Preferred item to swap",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      getInterestsWidgets(),
                                      SizedBox(height: screenHeight * 0.02),
                                      Text(
                                        "Price range",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "100Eur - 250 Eur",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: screenHeight * 0.02),

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
    var strings = item!.swapInterests;

    if (item?.swapInterests == null) {
      return const SizedBox.shrink();
    }

    List<Widget> list = [];
    for (var i = 0; i < strings.length; i++) {
      list.add(Text(strings[i].toTitleCase));
    }

    return Row(
      children: list,
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }

  Widget _addToWishlistBtn() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BasicAppButton(
          onPressed: () {},
          backgroundColor: AppColors.primary,
          title: "Make Swap Offer",
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

  Widget _continueButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          // padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Color(0xFF50644C),
          side: BorderSide(
            color: Color(0xFF50644C), // Custom border color
            width: 1, // Border width
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white),
      child: Text(
        'Add to Wishlist',
        style: TextStyle(fontSize: 18, color: AppColors.primary),
      ),
    );
  }

  Widget _imagesDisplay() {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: screenHeight * 0.25,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  _images[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_images.length, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 8 : 6,
              height: _currentPage == index ? 8 : 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? AppColors.primary : Colors.grey,
              ),
            );
          }),
        ),
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
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary,
                child: Text(
                  'W',
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 20, // Font size
                    // fontWeight: FontWeight.bold, // Text weight
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Willium Johnson",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      "View profile",
                      style: TextStyle(fontSize: 14, color: AppColors.primary),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.primary,
                      size: 14,
                      weight: 700,
                    )
                  ],
                ),
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
}
