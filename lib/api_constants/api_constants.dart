// lib/api/api_constants.dart

class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://swapify-api-c2ey.onrender.com/api/v1';

  static const String policy = '/legal/policies';
  // Auth endpoints
  static const String login = '/users/auth/login';
  static const String loginGoogle = '/users/auth/mobile/google';

  static const String register = '/users/auth/register';
  static const String logout = '/auth/logout';
  static const String checkemail = '/users/auth/check-email';
  static const String initiateVerification = '/users/auth/verification'; //post
  static const String completeVerification = '/users/auth/verification'; //put
  static const String checkEmail = '/users/availability/email';
  static const String checkUsername = '/users/availability/username';
  static const String editPassword = '/users/auth/password-change';
  static const String deleteProfile = '/users/profile';

  static const String updateSwapInterests = '/users/profile/categories';
  static const String categories = baseUrl + '/categories';
  static const String subcategories = baseUrl + '/subcategories/category';

  // User endpoints
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String updateUser = '/users/update';
  static const String deleteUser = '/users/delete';

  //Trades
  static const String swaps = '/swaps';
  static const String donation = '/donations/requests';

  //chats
  static const String conversations = '/messages/conversations';
  static const String messages = '/messages';
  static const String chatUsers = '/messages/chat-users';
  static const String sendMessage = messages + '/send';

  // Item endpoints (example for another feature)
  static const String items = '/items';
  static const String searchItems = '/items/search';
  static const String itemDetails = '/items/details';
  static const String addItem = '/items';
  static const String deleteItem = '/items/delete';

  //Cloudinary api
  static const cloudinaryApiKey = '281153428746455';
  static const cloudinarySecret = 'Dp-e090DBNr0i1jhqe0L-k-JRSA';
  static const cloudName = "dqjv3o9zi";
  static const profileUploadPreset = "l9sim6rm";
  static const itemUploadPreset = "l9sim6rm";
  static const String imageUploadUrl =
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
  static const String imageDeleteUrl =
      'https://api.cloudinary.com/v1_1/$cloudName/image/destroy';

  //Google Auth
  static const String loginWithGoogle = baseUrl + 'users/auth/mobile/google';
  static const String googleServerClientId =
      '114477559991-6m6biub2pm915e6j6fjjo5fev2jdsql8.apps.googleusercontent.com';

  static const cities="/cities";
}
