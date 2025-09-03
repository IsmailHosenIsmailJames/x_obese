import "dart:convert";
import "dart:developer";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:x_obese/app.dart";
import "package:x_obese/src/screens/auth/login/login_signup_page.dart";

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
      options.headers["Authorization"] = "Bearer $accessToken";
    }
    String? refreshToken = await getRefreshToken();
    if (refreshToken != null) {
      options.headers["Cookie"] = "refreshToken=$refreshToken";
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
      String? refreshToken = await getRefreshToken();
      if (refreshToken != null) {
        try {
          final newAccessToken = await doRefreshToken(refreshToken);
          if (newAccessToken != null) {
            return handler.resolve(
              await _retry(error.requestOptions, newAccessToken),
            );
          }
        } catch (e) {
          log("An error occurred during token refresh: $e");
        }
      }

      // If refresh token is null, or if refreshing fails, logout
      await clearTokens();
      Navigator.pushAndRemoveUntil(
        App.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => const LoginSignupPage()),
        (route) => false,
      );
    }
    return handler.next(error);
  }

  Future<Response> _retry(
    RequestOptions requestOptions,
    String accessToken,
  ) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    options.headers?["Authorization"] = "Bearer $accessToken";

    return dio.request(
      requestOptions.path,
      options: options,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
  }

  Future<String?> doRefreshToken(String refreshToken) async {
    try {
      final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
      refreshDio.options.headers["Cookie"] = "refreshToken=$refreshToken";
      final response = await refreshDio.post("/api/auth/v1/token/user");

      log("/api/auth/v1/token/user response status: ${response.statusCode}");
      printResponse(response);

      if (response.statusCode == 200) {
        String? newAccessToken = response.data["data"]["accessToken"];
        String? newRefreshToken = refreshTokenExtractor(response);
        log("New Tokens - Access: $newAccessToken, Refresh: $newRefreshToken");

        if (newAccessToken != null) {
          await saveTokens(newAccessToken, newRefreshToken ?? refreshToken);
          return newAccessToken;
        }
      } else if (response.statusCode == 403) {
        await clearTokens();
        Navigator.pushAndRemoveUntil(
          App.navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => const LoginSignupPage()),
          (route) => false,
        );
      }
    } catch (e) {
      log("Error during token refresh: $e");
    }
    return null;
  }
}

Future<void> saveTokens(String accessToken, String refreshToken) async {
  log("Tokens saved", name: "Tokens Handler");
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("access_token", accessToken);
  await prefs.setString("refresh_token", refreshToken);
}

Future<void> clearTokens() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("access_token");
  await prefs.remove("refresh_token");
}

Future<String?> getAccessToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("access_token");
}

Future<String?> getRefreshToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("refresh_token");
}

String? refreshTokenExtractor(Response response) {
  final cookies = response.headers["set-cookie"];
  log(cookies.toString(), name: "Refresh Token Extractor");
  log(cookies.toString(), name: "Refresh Token Extractor");
  if (cookies != null && cookies.isNotEmpty) {
    for (final cookie in cookies) {
      if (cookie.contains("refreshToken=")) {
        final refreshToken = cookie.split("refreshToken=")[1].split(";")[0];
        return refreshToken;
      }
    }
  }
  return null;
}

void printResponse(Response response) {
  log(response.requestOptions.path, name: "request_path");
  log(response.requestOptions.method, name: "request_method");
  log(
    const JsonEncoder.withIndent("  ").convert(response.data),
    name: "response_body",
  );
  log(response.statusCode.toString(), name: "response_status");

  try {
    log(
      const JsonEncoder.withIndent("  ").convert(response.requestOptions.data),
      name: "Request_body",
    );
  } catch (e) {
    log(e.toString());
  }
  // log(
  //   const JsonEncoder.withIndent('  ').convert(response.headers.map),
  //   name: 'response_headers',
  // );
}
