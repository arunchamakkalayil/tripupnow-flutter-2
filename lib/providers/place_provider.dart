import 'package:flutter/material.dart';
import '../models/place_model.dart';
import '../services/api_service.dart';

class PlaceProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Place> _places = [];
  List<Place> _trendingPlaces = [];
  List<Place> _searchedPlaces = [];
  List<Place> _nearbyPlaces = [];
  List<dynamic> _plans = [];
  
  bool _isLoading = false;
  String? _error;

  List<Place> get places => _places;
  List<Place> get trendingPlaces => _trendingPlaces;
  List<Place> get searchedPlaces => _searchedPlaces;
  List<Place> get nearbyPlaces => _nearbyPlaces;
  List<dynamic> get plans => _plans;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPlaces() async {
    try {
      _setLoading(true);
      _places = await _apiService.getPlaces();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchTrendingPlaces() async {
    try {
      _setLoading(true);
      _trendingPlaces = await _apiService.getTrendingPlaces();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchPlaces(String query) async {
    try {
      _setLoading(true);
      _searchedPlaces = await _apiService.searchPlaces(query);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchNearbyPlaces(double lat, double lon) async {
    try {
      _setLoading(true);
      _nearbyPlaces = await _apiService.getNearbyPlaces(lat, lon);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> generatePlans() async {
    try {
      _setLoading(true);
      _plans = await _apiService.generatePlans();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void clearSearchResults() {
    _searchedPlaces = [];
    notifyListeners();
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