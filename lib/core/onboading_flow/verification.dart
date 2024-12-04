import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/auth/login/login.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_bloc.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_event.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_state.dart';
import 'package:swapifymobile/core/onboading_flow/widgets/page_indicator.dart';
import 'package:swapifymobile/core/onboading_flow/choose_categories.dart';

import '../../api_client/api_client.dart';
import '../services/auth_service.dart';
import '../../common/widgets/app_bar.dart';
import '../../common/widgets/basic_app_button.dart';

class CountdownTimer extends StatefulWidget {
  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  int secondsRemaining = 1000;
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
  String? password;
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
    setState(() async {
      email = await prefs
          .getString('email'); // Get the email from SharedPreferences
      password = await prefs
          .getString('password'); // Get the pass from SharedPreferences
    });
    print("Credentials Loaded................................................");
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
      } else {
        // Optionally, close the keyboard after the last field
        _focusNodes[index].unfocus();
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
                  listener: (context, state) async {
                    if (state is VerificationComplete) {
                      bool isLoggedIn = await _autoLogin(context);

                      if (isLoggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Verification successful')),
                        );
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseCategories(
                                currentPage: 4,
                              ),
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Autologin Failed!\n Account is Verified')),
                        );
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                      }
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

  Future<bool> _autoLogin(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? email = await sharedPreferences
        .getString("email"); // Example, replace with actual value
    String? password = await sharedPreferences
        .getString("password"); // Example, replace with actual value
    print(
        "Autologin begun using................................................");
    // Perform login using AuthService
    final authService = AuthService(ApiClient());
    try {
      // Call login method and store token in SharedPreferences
      final response = await authService.login(email!, password!);

      String token = response.token ?? '';
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', token); // Store token
      ApiClient().setAuthToken(token);

      // Optionally, store any other user data like name, userId, etc.
      await prefs.setString('userId', response.userId.toString());

      return true;
    } catch (e) {
      // Handle login failure
      return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(fieldCount, (index) {
            return Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: TextFormField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  counterText: "", // Hides the character counter
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
          text: TextSpan(
            children: [
              const TextSpan(
                text: "Code will expire in ",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              WidgetSpan(
                child: CountdownTimer(), // Countdown timer integrated
              ),
              WidgetSpan(
                child: BlocBuilder<RegistrationBloc, RegistrationState>(
                  builder: (context, state) {
                    if (state is ResendingVerificationEmail) {
                      // Display a loading indicator instead of "Resend now" text
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CircularProgressIndicator(strokeWidth: 1),
                      );
                    }
                    // Show "Resend now" text if not in loading state
                    return GestureDetector(
                      onTap: () {
                        if (email!.isNotEmpty) {
                          BlocProvider.of<RegistrationBloc>(context).add(
                            ResendVerificationEmail(email!),
                          );
                        }
                      },
                      child: Text(
                        " Resend now",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
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
              email ??= "";
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
