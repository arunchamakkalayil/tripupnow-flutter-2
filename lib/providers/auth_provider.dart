import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/app_config.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final token = await _storage.read(key: AppConfig.accessTokenKey);
      final userJson = await _storage.read(key: AppConfig.userDataKey);
      
      if (token != null && userJson != null) {
        _user = User.fromJson(json.decode(userJson));
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      print('Error checking auth status: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _error = null;
      
      final response = await _apiService.login(email, password);
      
      if (response['user'] != null) {
        _user = User.fromJson(response['user']);
        _isAuthenticated = true;
        
        // Store user data
        await _storage.write(
          key: AppConfig.userDataKey,
          value: json.encode(_user!.toJson()),
        );
        
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    try {
      _setLoading(true);
      _error = null;
      
      await _apiService.signup(name, email, password);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> sendOtp(String email) async {
    try {
      _setLoading(true);
      _error = null;
      
      await _apiService.sendOtp(email);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    try {
      _setLoading(true);
      _error = null;
      
      await _apiService.verifyOtp(email, otp);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _user = null;
      _isAuthenticated = false;
      _error = null;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}