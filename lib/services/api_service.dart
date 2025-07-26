import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/app_config.dart';
import '../models/user_model.dart';
import '../models/place_model.dart';

class ApiService {
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final CookieJar _cookieJar = CookieJar();

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(CookieManager(_cookieJar));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: AppConfig.accessTokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Try to refresh token
          try {
            await refreshToken();
            // Retry the original request
            final token = await _storage.read(key: AppConfig.accessTokenKey);
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            final response = await _dio.fetch(error.requestOptions);
            handler.resolve(response);
            return;
          } catch (e) {
            // Refresh failed, logout user
            await _storage.delete(key: AppConfig.accessTokenKey);
            await _storage.delete(key: AppConfig.userDataKey);
          }
        }
        handler.next(error);
      },
    ));
  }

  // Auth Methods
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        AppConfig.loginEndpoint,
        data: {'email': email, 'password': password},
      );
      
      if (response.data['accessToken'] != null) {
        await _storage.write(
          key: AppConfig.accessTokenKey,
          value: response.data['accessToken'],
        );
      }
      
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> signup(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        AppConfig.signupEndpoint,
        data: {'name': name, 'email': email, 'password': password},
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> sendOtp(String email) async {
    try {
      await _dio.post(
        AppConfig.sendOtpEndpoint,
        data: {'email': email},
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await _dio.post(
        AppConfig.verifyOtpEndpoint,
        data: {'email': email, 'otp': otp},
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<String> refreshToken() async {
    try {
      final response = await _dio.post(AppConfig.refreshEndpoint);
      final newToken = response.data['accessToken'];
      await _storage.write(key: AppConfig.accessTokenKey, value: newToken);
      return newToken;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post(AppConfig.logoutEndpoint);
    } catch (e) {
      // Continue with logout even if API call fails
    } finally {
      await _storage.delete(key: AppConfig.accessTokenKey);
      await _storage.delete(key: AppConfig.userDataKey);
    }
  }

  // Places Methods
  Future<List<Place>> getPlaces() async {
    try {
      final response = await _dio.get(AppConfig.placesEndpoint);
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => Place.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Place>> getTrendingPlaces() async {
    try {
      final response = await _dio.get(AppConfig.trendingEndpoint);
      final List<dynamic> data = response.data;
      return data.map((json) => Place.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Place>> searchPlaces(String query) async {
    try {
      final response = await _dio.get(
        '${AppConfig.searchEndpoint}?query=$query',
      );
      final List<dynamic> data = response.data;
      return data.map((json) => Place.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Place>> getNearbyPlaces(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '${AppConfig.nearbyEndpoint}?lat=$lat&lon=$lon',
      );
      final List<dynamic> data = response.data;
      return data.map((json) => Place.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> generatePlans() async {
    try {
      final response = await _dio.get(AppConfig.plansEndpoint);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response?.data != null) {
        return error.response!.data['message'] ?? 'An error occurred';
      }
      return error.message ?? 'Network error occurred';
    }
    return error.toString();
  }
}