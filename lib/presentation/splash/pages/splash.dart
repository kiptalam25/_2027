import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapifymobile/core/onboading_flow/create_account.dart';
import 'package:swapifymobile/core/onboading_flow/verification.dart';
import 'package:swapifymobile/main/pages/home.dart';
import 'package:swapifymobile/presentation/splash/block/splash_cubit.dart';
import 'package:swapifymobile/presentation/splash/block/splash_state.dart';
import 'package:swapifymobile/presentation/pages/welcome.dart';
import 'package:swapifymobile/presentation/splash/pages/widgets/animating_photo.dart';
import 'package:swapifymobile/presentation/splash/pages/widgets/sequential_animations.dart';
import 'dart:math' as math;

import '../../../auth/bloc/auth_state.dart';
import '../../../core/config/themes/app_colors.dart';
import '../../../core/onboading_flow/registration/registration_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        // if (state is UnAuthenticated) {
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(builder: (context) => WelcomePage()));
        // }
        //
        // if (state is Authenticated) {
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(builder: (context) => HomePage()));
        // }
        if (state is UnAuthenticated) {
          // final registrationState =
          //     (state as IncompleteRegistration).registrationState;
          //
          // if (registrationState is RegistrationSuccess) {
          //   if (registrationState is VerificationComplete) {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(builder: (context) => HomePage() ),
          //     );
          //   } else {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => VerifyPage(currentPage: 3)),
          //     );
          //   }
          // } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => WelcomePage()),
          );
          // }
        } else if (state is Authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else if (state is Unregistered) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Registration(currentPage: 0)),
          );
        } else if (state is IncompleteRegistration) {}
      },
      child: Scaffold(
        // backgroundColor: AppColors.primary, body: SequentialAnimations()
        body: Container(
            // height: 100,
            // width: 100,
            color: AppColors.primary,
            child: Center(
                child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset("images/swapify_splash.png")))),
        // ),
      ),
    );
  }
}

class RotatingExplodingRectangle extends StatefulWidget {
  @override
  _RotatingExplodingRectangleState createState() =>
      _RotatingExplodingRectangleState();
}

class _RotatingExplodingRectangleState extends State<RotatingExplodingRectangle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false);

    _sizeAnimation = Tween<double>(begin: 0.0, end: 1000.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rotating Exploding Rectangle'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: _sizeAnimation.value,
                height: _sizeAnimation.value,
                color: Colors.blue,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
