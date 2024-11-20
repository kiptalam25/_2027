// lib/api/api_constants.dart

class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://swapify-api-c2ey.onrender.com/api/v1';

  // Auth endpoints
  static const String login = '/users/auth/login';
  static const String register = '/users/auth/register';
  static const String logout = '/auth/logout';
  static const String checkemail = '/users/auth/check-email';
  static const String initiateVerification = '/users/auth/verification'; //post
  static const String completeVerification = '/users/auth/verification'; //put
  static const String checkusername = '/users/auth/check_username';
  static const String categories = baseUrl + '/categories';

  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateUser = '/user/update';
  static const String deleteUser = '/user/delete';

  // Item endpoints (example for another feature)
  static const String items = '/items';
  static const String itemDetails = '/items/details';
  static const String addItem = '/items';
  static const String deleteItem = '/items/delete';
}
