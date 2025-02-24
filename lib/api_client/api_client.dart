import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_constants/api_constants.dart';

class ApiClient {
  final Dio _dio;

  ApiClient()
      : _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        print('Request[${options.method}] => PATH: ${options.path}');
        String? token = await _getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response[${response.statusCode}] => DATA: ${response.data}');
        handler.next(response);
      },
      onError: (DioException e, handler) {
        print('Error[${e.response?.statusCode}] => MESSAGE: ${e.message}');
        // Forward the error as a "response-like" object
        handler.resolve(
          Response(
            requestOptions: e.requestOptions,
            statusCode: e.response?.statusCode ?? 500,
            data: {
              'success': false,
              'message': e.message,
              'data': e.response?.data,
            },
          ),
        );
      },
    ));
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> put(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.put(path, data: data, queryParameters: queryParameters);
  }
  Future<Response> patch(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.patch(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> delete(String path,
      {Map<String, dynamic>? queryParameters}) async {
    return await _dio.delete(path, queryParameters: queryParameters);
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Optional method for setting auth tokens
  void setAuthToken(String token) {
    _dio.options.headers["Authorization"] = "Bearer $token";
  }
}



// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../api_constants/api_constants.dart';
//
// class ApiClient {
//   final Dio _dio;
//
//   ApiClient()
//       : _dio = Dio(
//           BaseOptions(
//             baseUrl: ApiConstants.baseUrl,
//             connectTimeout: const Duration(seconds: 60),
//             receiveTimeout: const Duration(seconds: 60),
//             headers: {
//               'Accept': 'application/json',
//               'Content-Type': 'application/json',
//             },
//           ),
//         ) {
//     _dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) async {
//         print('Request[${options.method}] => PATH: ${options.path}');
//         String? token = await _getToken();
//         if (token != null) {
//           options.headers['Authorization'] = 'Bearer $token';
//         }
//         // print("Token.............." + token!);
//         handler.next(options);
//       },
//       onResponse: (response, handler) {
//         print('Response[${response.statusCode}] => DATA: ${response.data}');
//         handler.next(response);
//       },
//       onError: (DioException e, handler) {
//         print('Error[${e.response?.statusCode}] => MESSAGE: ${e.message}');
//         handler.next(e);
//       },
//     ));
//   }
//
//   Future<Response> get(String path,
//       {Map<String, dynamic>? queryParameters}) async {
//     try {
//       return await _dio.get(path, queryParameters: queryParameters);
//     } on DioException catch (e) {
//       _handleError(e);
//       rethrow;
//     }
//   }
//
//   Future<Response> post(String path,
//       {dynamic data, Map<String, dynamic>? queryParameters}) async {
//     try {
//       return await _dio.post(path,
//           data: data, queryParameters: queryParameters);
//     } on DioException catch (e) {
//       _handleError(e);
//       rethrow;
//     }
//   }
//
//   Future<Response> put(String path,
//       {dynamic data, Map<String, dynamic>? queryParameters}) async {
//     try {
//       return await _dio.put(path, data: data, queryParameters: queryParameters);
//     } on DioException catch (e) {
//       _handleError(e);
//       rethrow;
//     }
//   }
//
//   Future<Response> delete(String path,
//       {Map<String, dynamic>? queryParameters}) async {
//     try {
//       return await _dio.delete(path, queryParameters: queryParameters);
//     } on DioException catch (e) {
//       _handleError(e);
//       rethrow;
//     }
//   }
//
//   void _handleError(DioException error) {
//     String message;
//     if (error.response != null) {
//       switch (error.response?.statusCode) {
//         case 400:
//           message = '${error.response?.data}';
//           break;
//         case 401:
//           message = '${error.response?.data}';
//           break;
//         case 403:
//           message = '${error.response?.data}';
//           break;
//         case 500:
//           message = '${error.response?.data}';
//           break;
//         default:
//           message = '${error.response?.data}';
//       }
//     } else {
//       message = '${error.message}';
//     }
//
//     // Throw the ApiException with the specific error message
//     throw ApiException(message);
//   }
//

//
//   Future<String?> _getToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }
// }
//
// class ApiException implements Exception {
//   final String message;
//   ApiException(this.message);
//
//   @override
//   String toString() => message;
// }
