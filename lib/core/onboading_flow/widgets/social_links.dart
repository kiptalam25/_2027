import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLinks extends StatefulWidget {
  final Function(String) onSocialClicked;
  final String page;
  // final Function(List<String>) onItemRemoved;

  const SocialLinks(
      {Key? key, required this.onSocialClicked, required this.page})
      : super(key: key);

  @override
  State<SocialLinks> createState() => _SocialLinksState();
}

class _SocialLinksState extends State<SocialLinks> {
  void onClicked(String social) {
    widget.onSocialClicked(social);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 374,
          height: 46, // Set the desired width
          child: ElevatedButton(
            onPressed: () {
              onClicked("google");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF13C00),
              // Custom button background color
              side: BorderSide(
                color: Color(0xFFF13C00),
                // Custom border color
                width: 2, // Border width
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24), // Custom border radius
              ),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the icon and text
              children: [
                const FaIcon(
                  FontAwesomeIcons.google, // Font Awesome Google icon
                  color: Color(0xFFFFFFFF), // Icon color
                ),
                const SizedBox(width: 8),
                // Space between icon and text

                Text(
                  widget.page == "login"
                      ? 'Continue with Google'
                      : 'Sign up with Google',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFFFFFF), // Text color
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 374,
          height: 46, // Set the desired width
          child: ElevatedButton(
            onPressed: () {
              onClicked("facebook");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D5A98),
              // Custom button background color
              side: const BorderSide(
                color: Color(0xFF3D5A98),
                // Custom border color
                width: 2, // Border width
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24), // Custom border radius
              ),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the icon and text
              children: [
                const FaIcon(
                  FontAwesomeIcons.facebook, // Font Awesome Google icon
                  color: Color(0xFFFFFFFF), // Icon color
                ),
                const SizedBox(width: 10), // Space between icon and text
                Text(
                  widget.page == "login"
                      ? 'Continue with Facebook'
                      : "Sign up with facebook",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFFFFFF), // Text color
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        SizedBox(
          width: 374,
          height: 46, // Set the desired width
          child: ElevatedButton(
            onPressed: () {
              onClicked("x");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF000000),
              // Custom button background color
              side: BorderSide(
                color: Color(0xFF000000),
                // Custom border color
                width: 2, // Border width
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24), // Custom border radius
              ),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the icon and text
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset("images/x.png"),
                ),
                SizedBox(width: 0),
                // Space between icon and text
                Text(
                  widget.page == "login" ? 'Continue with X' : 'Sign up with X',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFFFFFF), // Text color
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
