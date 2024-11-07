import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/common/helper/navigator/app_navigator.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_bloc.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_event.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_state.dart';
import 'package:swapifymobile/core/onboading_flow/widgets/page_indicator.dart';
import 'package:swapifymobile/presentation/pages/choose_categories.dart';

import '../../api_client/api_client.dart';
import '../../auth/services/auth_service.dart';
import '../../common/widgets/appbar/app_bar.dart';
import '../../common/widgets/button/basic_app_button.dart';
import '../config/themes/app_colors.dart';
import 'widgets/popup.dart';

class CountdownTimer extends StatefulWidget {
  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  int secondsRemaining = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          timer.cancel();
          // Navigator.pushReplacement(context, HomePage() as Route<Object?>);
        }
      });
    });
  }

  String getFormattedTime() {
    int minutes = secondsRemaining ~/ 60;
    int seconds = secondsRemaining % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Text(
        getFormattedTime(),
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}

class VerifyPage extends StatefulWidget {
  final int currentPage;
  VerifyPage({required this.currentPage});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final int fieldCount = 4;

  final List<TextEditingController> _controllers = [];

  final List<FocusNode> _focusNodes = [];
  String? email;
  @override
  void initState() {
    super.initState();
    _loadEmail();
    for (int i = 0; i < fieldCount; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  String getCode() {
    return _controllers.map((controller) => controller.text).join('');
  }

  bool areAllFieldsFilled() {
    for (var controller in _controllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  _loadEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email'); // Get the email from SharedPreferences
    });
    // BlocProvider.of<RegistrationBloc>(context).add(ResendVerificationEmail(
    //   email!,
    // ));
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move focus to the next field if it exists
      if (index < fieldCount - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      }
    } else if (index > 0) {
      // Move back to the previous field if deleted
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegistrationBloc(AuthService(ApiClient())),
      child: Scaffold(
          appBar: BasicAppbar(
            title: PageIndicator(currentPage: widget.currentPage),
            hideBack: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(child: _fields()),
                BlocConsumer<RegistrationBloc, RegistrationState>(
                  listener: (context, state) {
                    if (state is VerificationComplete) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Verification successful')),
                      );

                      // saveEmail(_emailController.text);

                      AppNavigator.pushReplacement(
                          context,
                          ChooseCategories(
                            currentPage: 4,
                          ));

                      // Dispatch a LoginSubmitted event for auto-login
                      // final loginBloc = BlocProvider.of<LoginBloc>(context);
                      // loginBloc.add(LoginSubmitted(
                      //     _emailController.text,
                      //     _passwordController
                      //         .text)); // Pass `username` and `password`
                      //
                      // // Listen to LoginBloc to handle auto-login success
                      // loginBloc.stream.listen((loginState) {
                      //   if (loginState is LoginSuccess) {
                      //     // Navigate to another page after successful login
                      //     // Navigator.of(context)
                      //     //     .pushReplacementNamed('/home');
                      //     AppNavigator.pushReplacement(
                      //         context,
                      //         VerifyPage(
                      //           currentPage: 2,
                      //         ));
                      //   } else if (loginState is LoginFailure) {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text(loginState.error)),
                      //     );
                      //   }
                      // });
                    } else if (state is RegistrationError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return _buildContinueButton(context, state);
                  },
                ),
              ],
            ),
          )),
    );
  }

  Widget _fields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Verify Your Identity",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "We have sent a code to your Email\n Enter the code to verify your account",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 48,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(fieldCount, (index) {
            return SizedBox(
              width: 60,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: InputDecoration(
                  counterText: "",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: AppColors.textFieldBorder)),
                ),
                // keyboardType: TextInputType.number,
                onChanged: (value) => _onChanged(value, index),
              ),
            );
          }),
        ),
        const SizedBox(
          height: 16,
        ),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              const TextSpan(
                text:
                    "Code will expire in", //"Code will expire in 05:29 \n Din't get the code? ",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              WidgetSpan(
                child: CountdownTimer(), // Countdown timer integrated
              ),
              TextSpan(
                  text: "Resend now",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      BlocProvider.of<RegistrationBloc>(context)
                          .add(ResendVerificationEmail(
                        email!,
                      ));
                      // showToast();
                    },
                  style: TextStyle(color: Colors.blue, fontSize: 16))
            ])),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context, Object? state) {
    return BasicAppButton(
      title: "Continue",
      radius: 24,
      height: 46,
      onPressed: state is VerificationComplete
          ? null
          : () {
              if (areAllFieldsFilled()) {
                BlocProvider.of<RegistrationBloc>(context)
                    .add(CompleteVerification(
                  email!,
                  getCode(),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please fill in all fields")),
                );
              }
            },
      content: state is VerificationLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : null,
    );
  }
}
