import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/Global.dart';
import 'package:swapifymobile/core/onboading_flow/logout/logout_bloc.dart';
import 'api_client/api_client.dart';
import 'auth/login/login_bloc.dart';
import 'auth/services/auth_service.dart';
import 'core/config/themes/app_colors.dart';
import 'core/list_item_flow/item_bloc.dart';
import 'core/onboading_flow/registration/registration_bloc.dart';
import 'core/welcome/splash/block/splash_cubit.dart';
import 'core/welcome/splash/pages/splash.dart';

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
      BlocProvider(
        create: (context) => LogoutBloc(sharedPreferences),
      ),
    ],
    child: MyApp(),
  ));
  // const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..appStarted(),
      child: MaterialApp(
        // initialRoute: '/',
        // routes: {
        //   '/': (context) => HomePage(),
        //   '/login': (context) => LoginPage(
        //         currentPage: 3,
        //       ),
        //   '/register': (context) => ProfilePage(currentPage: 2),
        // },
        title: Global.appName,
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.blue, // Text cursor color
            selectionColor: Colors.blue.shade200, // Text selection color
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
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Navigate to the LoginPage when the button is pressed
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => Registration(currentPage: 0)),
//             );
//           },
//           child: Text('Go to Login'),
//         ),
//       ),
//     );
//   }
// }
