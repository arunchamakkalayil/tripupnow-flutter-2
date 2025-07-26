import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/place_provider.dart';
import '../../widgets/hero_carousel.dart';
import '../../widgets/recommended_section.dart';
import '../../widgets/packages_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
      placeProvider.fetchTrendingPlaces();
      placeProvider.fetchPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          HeroCarousel(),
          SizedBox(height: 16),
          RecommendedSection(),
          SizedBox(height: 16),
          PackagesSection(),
          SizedBox(height: 100), // Bottom padding for navigation bar
        ],
      ),
    );
  }
}