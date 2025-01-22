import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/auth/models/response_model.dart';
import 'package:swapifymobile/common/app_colors.dart';
import 'package:swapifymobile/common/widgets/basic_app_button.dart';
import 'package:swapifymobile/core/services/items_service.dart';
import 'package:swapifymobile/core/services/swap_service.dart';
import 'package:swapifymobile/core/usecases/SingleItem.dart';
import 'package:swapifymobile/core/widgets/notification_popup.dart';

import '../../chat/pages/conversations_page.dart';
import '../widgets/animated_dropdown.dart';

class MakeSwapOfferBottomsheet extends StatefulWidget {
  final SingleItem recipientItem;
  final String exchangeMethod;

  const MakeSwapOfferBottomsheet(
      {Key? key, required this.recipientItem, required this.exchangeMethod})
      : super(key: key);
  @override
  State<MakeSwapOfferBottomsheet> createState() =>
      _MakeSwapOfferBottomsheetState();
}

class _MakeSwapOfferBottomsheetState extends State<MakeSwapOfferBottomsheet> {
  List<SingleItem> items = [];
  SingleItem? _selectedItem;
  bool _isChecked = false;
  String conversationId = "none";
  ItemsService itemsService = ItemsService(new ApiClient());
  bool fetchingOwnItems = false;

  Future<void> fetchOwnItems() async {
    setState(() {
      fetchingOwnItems = true;
    });

    try {
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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to fetch items or no items available.'),
            ),
          );
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

  @override
  Widget build(BuildContext context) {
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
              Column(
                children: [
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
                      borderRadius: BorderRadius.circular(
                          8.0), // Rounded corners (optional)
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
                          itemLabel: (item) =>
                              item.title, // Display item directly
                          onItemSelected: (item) {
                            // Handle selection
                            setState(() {
                              _selectedItem = item;
                            });
                            print("Selected: $item" + item!.title);
                          },
                          placeholder: "Select an item",
                        ),
                  SizedBox(
                    height: 16,
                  ),
                  CheckboxListTile(
                    value: _isChecked,
                    // checkColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                    title: Text(
                        'I confirm that my item is in the user’s desired category'),
                    activeColor: AppColors.primary,
                    checkColor: Colors.white,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
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
