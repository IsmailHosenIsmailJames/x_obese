import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:o_xbese/src/screens/auth/login/login_signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio dio = Dio();
  final String baseUrl;

  DioClient(this.baseUrl) {
    dio.options.baseUrl = baseUrl;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    String? refreshToken = await getRefreshToken();
    if (refreshToken != null) {
      options.headers['Cookie'] = 'refreshToken=$refreshToken';
    }
    return handler.next(options);
  }

  Future<void> _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    return handler.next(response);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 401) {
      // Access token expired, try to refresh
      final refreshToken = await getRefreshToken();
      if (refreshToken != null) {
        try {
          final refreshedTokens = await doRefreshToken(refreshToken);
          if (refreshedTokens != null) {
            // Retry the original request with the new access token
            return handler.resolve(
              await _retry(
                error.requestOptions,
                refreshedTokens['access_token'],
              ),
            );
          } else {
            // Refresh failed, logout or redirect to login
            await clearTokens();
            getx.Get.offAll(() => const LoginSignupPage());
          }
        } catch (refreshError) {
          //Refresh token is also invalid. logout or redirect to login.
          await clearTokens();
          getx.Get.offAll(() => const LoginSignupPage());
        }
      } else {
        // No refresh token, logout or redirect to login
        await clearTokens();
        getx.Get.offAll(() => const LoginSignupPage());
      }
    }
    return handler.next(error);
  }

  Future<Response> _retry(
    RequestOptions requestOptions,
    String accessToken,
  ) async {
    final options = Options(
      method: requestOptions.method,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    String? refreshToken = await getRefreshToken();
    if (refreshToken != null) {
      dio.options.headers['Cookie'] = 'refreshToken=$refreshToken';
    }
    return dio.request(
      requestOptions.path,
      options: options,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
  }

  Future<Map<String, dynamic>?> doRefreshToken(String refreshToken) async {
    try {
      final response = await dio.get('/api/auth/v1/token/user');
      if (response.statusCode == 200) {
        String? newAccessToken = response.data['access_token'];
        String? newRefreshToken = refreshTokenExtractor(response);
        if (newAccessToken != null && newRefreshToken != null) {
          await saveTokens(newAccessToken, newRefreshToken);
        }
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

Future<void> saveTokens(String accessToken, String refreshToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('access_token', accessToken);
  await prefs.setString('refresh_token', refreshToken);
}

Future<void> clearTokens() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('access_token');
  await prefs.remove('refresh_token');
}

Future<String?> getAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token');
}

Future<String?> getRefreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('refresh_token');
}

String? refreshTokenExtractor(Response response) {
  final cookies = response.headers['set-cookie'];
  log(cookies.toString(), name: 'Refresh Token Extractor');
  if (cookies != null && cookies.isNotEmpty) {
    for (final cookie in cookies) {
      if (cookie.contains('refreshToken=')) {
        final refreshToken = cookie.split('refreshToken=')[1].split(';')[0];
        return refreshToken;
      }
    }
  }
  return null;
}

void printResponse(Response response) {
  log(response.requestOptions.path, name: 'request_path');
  log(response.requestOptions.method, name: 'request_method');
  log(
    const JsonEncoder.withIndent('  ').convert(response.data),
    name: 'response_body',
  );
  log(response.statusCode.toString(), name: 'response_status');
  log(
    const JsonEncoder.withIndent('  ').convert(response.headers.map),
    name: 'response_headers',
  );
}
