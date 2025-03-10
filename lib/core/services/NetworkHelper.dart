// import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
//
// import '../widgets/notification_popup.dart';
//
// class NetworkHelper {
//   static Future<bool> hasInternetConnection() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//
//     if (connectivityResult == ConnectivityResult.none) {
//       return false;
//     }
//
//     InternetConnectionChecker internetChecker = InternetConnectionChecker.createInstance();
//     return await internetChecker.hasConnection;
//   }
//
//   static Future<void> checkInternetAndShowPopup(BuildContext context) async {
//     bool isConnected = await hasInternetConnection();
//
//     if (!context.mounted) return;
//
//     if (!isConnected) {
//       StatusPopup.show(context,
//           message: "No internet connection", isSuccess: false);
//     }
//   }
// }
