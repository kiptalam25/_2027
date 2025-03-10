// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// class NetworkService {
//   final _controller = StreamController<bool>.broadcast();
//
//   NetworkService() {
//     _init();
//   }
//
//   void _init() {
//     Connectivity().onConnectivityChanged.listen((result) {
//       bool isConnected = result != ConnectivityResult.none;
//       _controller.add(isConnected);
//     });
//   }
//
//   Stream<bool> get connectionStream => _controller.stream;
// }
