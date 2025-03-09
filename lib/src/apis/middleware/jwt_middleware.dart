import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio _dio = Dio();
  final String baseUrl;

  DioClient(this.baseUrl) {
    _dio.options.baseUrl = baseUrl;
    _dio.interceptors.add(
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
    final accessToken = await _getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
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
      final refreshToken = await _getRefreshToken();
      if (refreshToken != null) {
        try {
          final refreshedTokens = await _refreshToken(refreshToken);
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
            await _clearTokens();
            // Handle redirect to login or show logout message.
            return handler.next(error); // or handler.reject(error);
          }
        } catch (refreshError) {
          //Refresh token is also invalid. logout or redirect to login.
          await _clearTokens();
          return handler.next(error); // or handler.reject(error);
        }
      } else {
        // No refresh token, logout or redirect to login
        await _clearTokens();
        return handler.next(error); // or handler.reject(error);
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
    return _dio.request(
      requestOptions.path,
      options: options,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
  }

  Future<Map<String, dynamic>?> _refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/refresh', // Your refresh token endpoint
        data: {'refresh_token': refreshToken},
      );
      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];
        await _saveTokens(newAccessToken, newRefreshToken);
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return _dio.post(path, data: data);
  }

  Future<void> signup(String username, String password) async {
    try {
      final response = await _dio.post(
        '/signup', // Your signup endpoint
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 201 for created
        final accessToken = response.data['access_token'];
        final refreshToken = response.data['refresh_token'];
        await _saveTokens(accessToken, refreshToken);
        // Optionally, navigate to the home screen or show a success message.
      } else {
        // Handle signup error (e.g., show an error message)
        print('Signup failed: ${response.statusCode}, ${response.data}');
        // Example: throw Exception('Signup failed');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Signup error: $e');
      // Example: throw Exception('Signup error');
    }
  }

  // ... (rest of the DioClient class as before)
}
