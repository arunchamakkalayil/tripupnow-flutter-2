import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/startup_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/email_verification_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/track/track_screen.dart';
import '../screens/planner/planner_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAuthenticated = authProvider.isAuthenticated;
      
      // If not authenticated and trying to access protected routes
      if (!isAuthenticated && state.matchedLocation.startsWith('/main')) {
        return '/login';
      }
      
      // If authenticated and trying to access auth routes
      if (isAuthenticated && (state.matchedLocation == '/login' || state.matchedLocation == '/signup')) {
        return '/main/home';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const StartupScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/verify',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return EmailVerificationScreen(email: email);
        },
      ),
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/main/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/main/explore',
            builder: (context, state) => const ExploreScreen(),
          ),
          GoRoute(
            path: '/main/track',
            builder: (context, state) => const TrackScreen(),
          ),
          GoRoute(
            path: '/main/planner',
            builder: (context, state) => const PlannerScreen(),
          ),
          GoRoute(
            path: '/main/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}