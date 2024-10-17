import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/common/helper/navigator/app_navigator.dart';
import 'package:swapifymobile/core/onboading_flow/widgets/page_indicator.dart';
import 'package:swapifymobile/presentation/pages/choose_categories.dart';

import '../../common/widgets/appbar/app_bar.dart';
import '../../common/widgets/button/basic_app_button.dart';
import '../../presentation/pages/popup.dart';

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

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
      padding: const EdgeInsets.only(left: 8, right: 8),
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

class VerifyPage extends StatelessWidget {
  final int currentPage;
  VerifyPage({required this.currentPage});
  // const VerifyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppbar(
          title: PageIndicator(currentPage: currentPage),
          hideBack: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(child: _fields()),
              BasicAppButton(
                title: "Continue",
                radius: 24,
                height: 38,
                onPressed: () {
                  AppNavigator.pushReplacement(
                      context,
                      const ChooseCategories(
                        currentPage: 3,
                      ));
                },
              )
            ],
          ),
        ));
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
          "We have sent a code to +2547xxxxxx123.\n Enter the code to verify your number",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 48,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            SizedBox(
              height: 70,
              width: 60,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10)),
              ),
            ),
            SizedBox(
              height: 70,
              width: 60,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10)),
              ),
            ),
            SizedBox(
              height: 70,
              width: 60,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10)),
              ),
            ),
            SizedBox(
              height: 70,
              width: 60,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10)),
              ),
            ),
          ],
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
                      // showToast();
                    },
                  style: TextStyle(color: Colors.blue, fontSize: 16))
            ])),
      ],
    );
  }
}
