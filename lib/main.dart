import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/Global.dart';
import 'package:swapifymobile/core/list_item_flow/bloc/update_item_bloc.dart';
import 'package:swapifymobile/core/onboading_flow/logout/logout_bloc.dart';
import 'api_client/api_client.dart';
import 'auth/login/login_bloc.dart';
import 'core/services/auth_service.dart';
import 'common/app_colors.dart';
import 'core/list_item_flow/bloc/item_bloc.dart';
import 'core/onboading_flow/registration/registration_bloc.dart';
import 'core/services/network_service.dart';
import 'core/services/no_internet_page.dart';
import 'core/welcome/splash/block/splash_cubit.dart';
import 'core/welcome/splash/pages/splash.dart';
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   final sharedPreferences = await SharedPreferences.getInstance();
//   final apiClient = ApiClient();
//   final authService = AuthService(apiClient);
//
//   runApp(
//     MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => LoginBloc(authService, sharedPreferences)),
//         BlocProvider(create: (context) => RegistrationBloc(authService)),
//         BlocProvider(create: (context) => AddItemBloc(apiClient)),
//         BlocProvider(create: (context) => UpdateItemBloc(apiClient)),
//       ],
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final NetworkService _networkService = NetworkService();
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<bool>(
//       stream: _networkService.connectionStream,
//       initialData: true, // Assume connected initially
//       builder: (context, snapshot) {
//         bool isConnected = snapshot.data ?? true;
//
//         return BlocProvider(
//           create: (context) => SplashCubit()..appStarted(),
//           child: MaterialApp(
//             title: Global.appName,
//             theme: ThemeData(
//               textSelectionTheme: TextSelectionThemeData(
//                 cursorColor: AppColors.primary,
//                 selectionColor: AppColors.successColor,
//                 selectionHandleColor: AppColors.primary,
//               ),
//               primaryColor: AppColors.primary,
//               colorScheme: ColorScheme.fromSwatch(
//                 primarySwatch: createMaterialColor(AppColors.primary),
//                 accentColor: AppColors.primary,
//               ),
//               scaffoldBackgroundColor: AppColors.background,
//               inputDecorationTheme: InputDecorationTheme(
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: AppColors.primary, width: 2.0),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.grey, width: 1.0),
//                 ),
//               ),
//             ),
//             home: isConnected ? SplashPage() : NoInternetPage(),
//           ),
//         );
//       },
//     );
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences =
      await SharedPreferences.getInstance(); // Initialize SharedPreferences
  final apiClient = ApiClient(); // Initialize ApiClient
  final authService = AuthService(apiClient);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => LoginBloc(authService, sharedPreferences),
      ),
      BlocProvider(
        create: (context) => RegistrationBloc(authService),
      ),
      BlocProvider(
        create: (context) => AddItemBloc(apiClient),
      ),
      // BlocProvider(
      //   create: (context) => LogoutBloc(sharedPreferences),
      // ),
      BlocProvider(
        create: (context) => UpdateItemBloc(apiClient),
      ),
    ],
    child: MyApp(),
  ));
  // const MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  final NetworkService _networkService = NetworkService();


  bool _isConnected = true;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _networkService.connectionStream.listen((isConnected) {
      if (!isConnected && _isConnected) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoInternetPage()),
        );
      } else if (isConnected && !_isConnected) {
        Navigator.pop(context);
      }
      _isConnected = isConnected;
    });
  }
  // const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..appStarted(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: Global.appName,
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: AppColors.primary, // Text cursor color
            selectionColor: AppColors.successColor, // Text selection color
            selectionHandleColor: AppColors.primary, // Handle color
          ),
          primaryColor: AppColors.primary, // Main color
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: createMaterialColor(AppColors.primary),
            accentColor: AppColors.primary, // Accent color if needed
          ),
          scaffoldBackgroundColor: AppColors.background,
          // primarySwatch: AppColors.primarySwatch,

          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary, // Set your preferred color
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey, // Color when not focused
                width: 1.0,
              ),
            ),
            // border: OutlineInputBorder(), // Default border if none is specified
          ),
        ),
        home: const SplashPage(), //const MyHomePage(title: 'Swapify Home'),
      ),
    );
  }
}
