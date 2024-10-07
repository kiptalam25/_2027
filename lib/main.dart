import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapifymobile/Global.dart';
import 'package:swapifymobile/presentation/pages/login_page.dart';
import 'package:swapifymobile/presentation/splash/block/splash_cubit.dart';
import 'package:swapifymobile/presentation/splash/pages/splash.dart';
import 'core/config/themes/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..appStarted(),
      child: MaterialApp(
        title: Global.appName,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          // primarySwatch: Color(0xFF50644C),/\
          primarySwatch: AppColors.primarySwatch,
          // textTheme: GoogleFonts.notoSansTextTheme(
          //   Theme.of(context).textTheme,
          // ),
        ),
        home: const SplashPage(), //const MyHomePage(title: 'Swapify Home'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the LoginPage when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text('Go to Login'),
        ),
      ),
    );
  }
}
