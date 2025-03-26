import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:o_xbese/src/screens/auth/login/login_signup_page.dart';

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
    if (error.response?.statusCode == 403 ||
        error.response?.statusCode == 401) {
      // Access token expired, try to refresh
      final refreshToken = await getRefreshToken();
      log(refreshToken.toString(), name: 'Here I am');
      if (refreshToken != null) {
        try {
          final refreshedTokens = await doRefreshToken(refreshToken);
          if (refreshedTokens != null) {
            // Retry the original request with the new access token
            return handler.resolve(
              await _retry(
                error.requestOptions,
                refreshedTokens['accessToken'],
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
      final response = await dio.post('/api/auth/v1/token/user');
      printResponse(response);
      if (response.statusCode == 200) {
        String? newAccessToken = response.data['data']['accessToken'];
        String? newRefreshToken = refreshTokenExtractor(response);
        log([newAccessToken, newRefreshToken].toString());
        if (newAccessToken != null) {
          await saveTokens(newAccessToken, newRefreshToken ?? refreshToken);
          return response.data;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

Future<void> saveTokens(String accessToken, String refreshToken) async {
  log('Tokens saved', name: 'Tokens Handler');
  final prefs = await Hive.openBox('tokens');
  await prefs.put('access_token', accessToken);
  await prefs.put('refresh_token', refreshToken);
}

Future<void> clearTokens() async {
  final prefs = await Hive.openBox('tokens');
  await prefs.delete('access_token');
  await prefs.delete('refresh_token');
}

String? getAccessToken() {
  final prefs = Hive.box('tokens');
  return prefs.get('access_token');
}

String? getRefreshToken() {
  final prefs = Hive.box('tokens');
  return prefs.get('refresh_token');
}

String? refreshTokenExtractor(Response response) {
  final cookies = response.headers['set-cookie'];
  log(cookies.toString(), name: 'Refresh Token Extractor');
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
  // log(
  //   const JsonEncoder.withIndent('  ').convert(response.headers.map),
  //   name: 'response_headers',
  // );
}
