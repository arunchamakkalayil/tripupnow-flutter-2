class AppConfig {
  static const String appName = 'TripUpNow';
  static const String baseUrl = 'YOUR_BACKEND_URL'; // Replace with your actual backend URL
  static const String olaMapApiKey = 'YOUR_OLA_MAP_API_KEY'; // Replace with your actual API key
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; // Replace with your actual API key
  
  // API Endpoints
  static const String loginEndpoint = '/api/auth/login';
  static const String signupEndpoint = '/api/auth/signup';
  static const String refreshEndpoint = '/api/auth/refresh';
  static const String logoutEndpoint = '/api/auth/logout';
  static const String sendOtpEndpoint = '/api/auth/send-otp';
  static const String verifyOtpEndpoint = '/api/auth/verify-otp';
  static const String placesEndpoint = '/api/places';
  static const String trendingEndpoint = '/api/trending';
  static const String searchEndpoint = '/api/places/search';
  static const String nearbyEndpoint = '/api/places/nearby';
  static const String plansEndpoint = '/api/places/plans';
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
}