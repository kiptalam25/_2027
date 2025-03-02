import 'dart:convert';

import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/auth/models/response_model.dart';
import 'package:swapifymobile/common/app_colors.dart';
import 'package:swapifymobile/common/widgets/basic_app_button.dart';
import 'package:swapifymobile/core/chat/pages/chat_users_page.dart';
import 'package:swapifymobile/core/main/pages/home_page.dart';
import 'package:swapifymobile/core/main/widgets/loading.dart';
import 'package:swapifymobile/core/services/items_service.dart';
import 'package:swapifymobile/core/services/trade_service.dart';
import 'package:swapifymobile/core/usecases/SingleItem.dart';
import 'package:swapifymobile/core/usecases/chat_user.dart';
import 'package:swapifymobile/core/widgets/notification_popup.dart';

import '../../chat/pages/conversations_page.dart';
import '../../usecases/item.dart';
import '../../widgets/custom_textfield.dart';
import '../widgets/animated_dropdown.dart';

class MakeSwapOfferBottomsheet extends StatefulWidget {
  final Item recipientItem;
  // final SingleItem recipientItem;
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
  final TextEditingController justificationController = TextEditingController();
  bool isSending=false;

  Future<void> fetchOwnItems() async {
    print("Exchange method");
    print(widget.exchangeMethod);
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
    if(widget.exchangeMethod!="donation") {
      fetchOwnItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponseModel response;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 8.0,
          bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                widget.exchangeMethod == "swap"
                    ? Column(
                        children: [
                          Text(
                            "This user wants",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
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
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
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
                              : items.isEmpty ?
                          Column(children: [
                            Text("You Have No Items To Offer"),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomePage(autoClick: true)),
                                );
                              },
                              child: Text("Add Items"),
                            )
                          ],)

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
                      )
                    : Column(
                        children: [
                          Center(child: Text("Donation Request Justification")),
                          InputSection(
                            label: "",
                            hintText:
                                "Enter reasons why this item should be donated to you",
                            controller: justificationController,
                            maxCharacters: 2000, // Optional
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
                    backgroundColor: hasItems()  ?
                        AppColors.fadedButton
                        : AppColors.primary,
                    content: isSending ? Loading():null,
                    onPressed: hasItems() ?  (){} : isSending ? null: () async => {
                      if(widget.exchangeMethod=="swap"){
                          response = await makeSwapOffer(),
                          if (response.success)
                            {
                              StatusPopup.show(context,
                                  message: "Offer is Sent", isSuccess: true),
                              Navigator.pop(context),
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatUsersPage(
                                          )))
                            }
                          else
                            {
                              StatusPopup.show(context,
                                  message: response.message, isSuccess: false),
                              setState(() {
                                isSending=false;
                              })
                            }}
                      else if(widget.exchangeMethod=="donation"){
                        response = await makeDonationRequest(),
                        if (response.success)
                          {

                            StatusPopup.show(context,
                                message: response.message, isSuccess: true),
                            Navigator.pop(context),
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatUsersPage()
                                    //   builder: (context) => ConversationsPage(
                                    //   conversationId: conversationId,
                                    // )
                                ))
                          }
                        else
                          {
                            StatusPopup.show(context,
                                message: response.message, isSuccess: false),
                            // StatusPopup.show(context,
                            //     message: response, isSuccess: false),
                            // if(response.message.contains("Missing required fields")){
                            //   StatusPopup.show(context,
                            //       message: "Missing required fields", isSuccess: false)
                            // }else if(response.message.contains("already exists")){
                            //   StatusPopup.show(context,
                            //       message: "Donation request already exists", isSuccess: false)
                            // }else
                            //   {
                            //     StatusPopup.show(context,
                            //         message: response.message, isSuccess: false)
                            //   }
                          }
                      } else{
                        StatusPopup.show(context,
                            message: "Failed! \n no exchange method:"+widget.exchangeMethod, isSuccess: false)
                      }
                        },
                        // content: items.isEmpty && widget.exchangeMethod=="swap" ? null :Text("Send Request")
                        ),
                SizedBox(
                  height: 16,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  TradeService tradeService = TradeService(new ApiClient());

  Future<ResponseModel> makeSwapOffer() async {
    setState(() {
      isSending=true;
    });
    String? initiatorItem = _selectedItem?.id;
    String? recipientId = widget.recipientItem.userId?.id;
    String recipientItemId = widget.recipientItem.id;//item belonging to the recipient of the request message
    Map<String, dynamic> jsonMap = {
      'initiatorItemId': initiatorItem,
      'recipientId': recipientId,
      'recipientItemId': recipientItemId,
    };

// Convert the map to a JSON string
    if (initiatorItem == "" ) {
      return ResponseModel(message: "There is no Item", success: false);
    }
    if (recipientId == "" ) {
      return ResponseModel(message: "There is no Recipient", success: false);
    }
      String jsonString = jsonEncode(jsonMap);
      print(jsonString);
      final response = await tradeService.createSwapOffer(jsonString);
      final data =response?.data;
      if(data['success']) {
        setState(() {
          setState(() {
            isSending = false;
          });
        });
        return ResponseModel(success: true, message: data['message']);
      }

      print(data.toString());
      return ResponseModel(success: false, message: data['data']['error']);

  }

  Future<ResponseModel> makeDonationRequest() async {
    String? itemId = widget.recipientItem.id;//item belonging to the recipient of the request message
    String letterOfIntent = justificationController.text;
    Map<String, dynamic> jsonMap = {
      'itemId': itemId,
      'letterOfIntent': letterOfIntent,
    };


      String jsonString = jsonEncode(jsonMap);
      print(jsonString);
      final response = await tradeService.createDonationRequest(jsonString);
      if(response!=null){
        final data=response.data;
        if(data['success']) {
          setState(() {
            setState(() {
              isSending = false;
            });
          });
          return ResponseModel(success: true, message: data['message']);
        }

        print(data.toString());
        return ResponseModel(success: false, message: data['data']['error']);

      }
    return ResponseModel(success: false, message: "No Response From Server");



  }

  hasItems() {
    bool hasItems=false;
    if(items.isEmpty && widget.exchangeMethod=="swap"){
      return hasItems=true;
    }
    return hasItems;
  }
}
