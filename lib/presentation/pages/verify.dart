import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/common/widgets/appbar/app_bar.dart';
import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';
import 'package:swapifymobile/presentation/pages/popup.dart';

import '../../common/helper/navigator/app_navigator.dart';

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
  const VerifyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppbar(
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
                  showCustomPopup(context);
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
          height: 20,
        ),
        Text(
          "We have sent a code to +2547xxxxxx123.\n Enter the code to verify your number",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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
        SizedBox(
          height: 20,
        ),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
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

  Widget _continueButton() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // AppNavigator.push(context, const EnterPasswordPage());
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Color(0xFF50644C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Continue',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // void showToast() {
  //   Fluttertoast.showToast(
  //       msg: "Code Has been Resent!",
  //       toastLength: Toast.LENGTH_SHORT,  // Can be LENGTH_SHORT or LENGTH_LONG
  //       gravity: ToastGravity.BOTTOM,     // Toast position: BOTTOM, TOP, CENTER
  //       timeInSecForIosWeb: 1,            // Duration in seconds for iOS/Web
  //       backgroundColor: Colors.black,    // Background color of the toast
  //       textColor: Colors.white,          // Text color of the toast
  //       fontSize: 16.0                    // Font size of the text
  //   );
  //
  // }
}
