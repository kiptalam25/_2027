class AppConstants {
  static RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  static RegExp passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&._+-])[A-Za-z\d@$!%*?&._]{8,}$');

  // final passwordRegEx =
  //     r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&._+-])[A-Za-z\d@$!%*?&._]{8,}$';

  // static String addItem;
}
