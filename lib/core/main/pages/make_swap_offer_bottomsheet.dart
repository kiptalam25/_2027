import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/auth/models/response_model.dart';
import 'package:swapifymobile/common/app_colors.dart';
import 'package:swapifymobile/common/widgets/basic_app_button.dart';
import 'package:swapifymobile/core/services/items_service.dart';
import 'package:swapifymobile/core/services/swap_service.dart';
import 'package:swapifymobile/core/usecases/SingleItem.dart';
import 'package:swapifymobile/core/widgets/notification_popup.dart';

import '../../chat/pages/conversations_page.dart';
import '../../usecases/item.dart';
import 'animated_dropdown.dart';

class MakeSwapOfferBottomsheet extends StatefulWidget {
  final SingleItem recipientItem;

  const MakeSwapOfferBottomsheet({Key? key, required this.recipientItem})
      : super(key: key);
  @override
  State<MakeSwapOfferBottomsheet> createState() =>
      _MakeSwapOfferBottomsheetState();
}

class _MakeSwapOfferBottomsheetState extends State<MakeSwapOfferBottomsheet> {
  final List<String> _items = ["Shoes", "Handbag", "Clothing"];
  List<SingleItem> items = [];
  SingleItem? _selectedItem;
  bool _isChecked = false;
  bool _isLoading = false;
  String conversationId = "none";
  ItemsService itemsService = ItemsService(new ApiClient());
  bool fetchingOwnItems = false;

  Future<void> fetchOwnItems() async {
    setState(() {
      fetchingOwnItems = true;
    });

    try {
      // Simulate an API call delay
      await Future.delayed(Duration(seconds: 2));

      final response = await itemsService.fetchOwnItems("");

      if (response != null && response.data != null) {
        final data = response.data;

        if (data['success'] == true && data['items'] != null) {
          // Map the list of JSON items to a list of Item objects
          final List<SingleItem> fetchedItems = (data['items'] as List<dynamic>)
              .map((item) => SingleItem.fromJson(item))
              .toList();

          setState(() {
            items = fetchedItems; // Assuming `items` is a List<Item>
          });
          print("Items--------------" + items.toString());
        } else {
          print("Failed to fetch items or no items available.");
        }
      }
      // // Parse the response
      // final Map<String, dynamic> jsonResponse =
      //     json.decode(res) as Map<String, dynamic>;
      //
      // if (jsonResponse['success'] == true) {
      //   // Extract items and convert to Dart objects
      //   final List<dynamic> itemsJson = jsonResponse['items'];
      //   final List<Item> fetchedItems =
      //       itemsJson.map((json) => Item.fromJson(json)).toList();
      //
      //   setState(() {
      //     items = fetchedItems;
      //   });
      // }
    } catch (e) {
      print('Error fetching items: $e');
    } finally {
      setState(() {
        fetchingOwnItems = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOwnItems();
  }

  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    bool created;
    ResponseModel response;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Text(
                "This user wants",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                padding: EdgeInsets.all(4.0), // Text padding
                decoration: BoxDecoration(
                  color: AppColors.hintColor, // Background color
                  border: Border.all(
                    // Border
                    color: AppColors.primary,
                    width: 1.0,
                  ),
                  borderRadius:
                      BorderRadius.circular(8.0), // Rounded corners (optional)
                ),
                child: Text(
                  "Any article of clothing, a new pair of shoes or a hand bag",
                  style: TextStyle(
                    fontSize: 14.0, // Adjust text size
                    color: AppColors.primary, // Text color
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "What are you offering",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 4,
              ),
              fetchingOwnItems
                  ? Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : AnimatedDropdown<SingleItem>(
                      items: items,
                      selectedItem: _selectedItem,
                      itemLabel: (item) => item.title, // Display item directly
                      onItemSelected: (item) {
                        // Handle selection
                        _selectedItem = item;
                        print("Selected: $item");
                      },
                      placeholder: "Select an item",
                    ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "I confirm that my item is in the user’s desired category",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              BasicAppButton(
                  height: 38,
                  title: "Make offer",
                  radius: 24,
                  onPressed: () async => {
                        response = await makeOffer(),
                        if (response.success)
                          {
                            StatusPopup.show(context,
                                message: "Offer is Sent", isSuccess: true),
                            Navigator.pop(context),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ConversationsPage(
                                          conversationId: conversationId,
                                        )))
                          }
                        else
                          {
                            StatusPopup.show(context,
                                message: response.message, isSuccess: false)
                          }
                      }),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ],
      ),
    );
  }

  SwapService swapService = SwapService(new ApiClient());

  Future<ResponseModel> makeOffer() async {
    String? initiatorItem = _selectedItem?.id;
    String recipientId = widget.recipientItem.userId;
    String recipientItemId = widget.recipientItem.id;
    Map<String, dynamic> jsonMap = {
      'initiatorItemId': initiatorItem,
      'recipientId': recipientId,
      'recipientItemId': recipientItemId,
    };

// Convert the map to a JSON string
    if (initiatorItem == "" || recipientId == "") {
      return ResponseModel(message: "There is no Recipient", success: false);
    } else {
      String jsonString = jsonEncode(jsonMap);
      print(jsonString);
      ResponseModel response = await swapService.createSwapOffer(jsonString);
      return response;
    }
    // {
    //   "initiatorItemId":_selectedItem!.id,
    //   "recipientId":"6744c4144bf8097f279f1f80",
    //   "recipientItemId":"672ccc240ce34ff92e84c1a8"
    // }
  }
}
