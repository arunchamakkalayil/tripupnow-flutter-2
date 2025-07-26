import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/place_provider.dart';
import '../../services/location_service.dart';
import '../../widgets/place_card.dart';
import 'nearby_map_screen.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final LocationService _locationService = LocationService();
  Position? _userLocation;
  bool _showScanButton = true;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final position = await _locationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        _userLocation = position;
      });
    }
  }

  Future<void> _scanNearbyPlaces() async {
    if (_userLocation == null) return;

    setState(() {
      _isScanning = true;
    });

    try {
      final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
      await placeProvider.fetchNearbyPlaces(
        _userLocation!.latitude,
        _userLocation!.longitude,
      );
      
      setState(() {
        _showScanButton = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch nearby places: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  void _showMapView() {
    final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NearbyMapScreen(
          places: placeProvider.nearbyPlaces,
          userLocation: _userLocation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showScanButton
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_searching,
                    size: 64,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Discover nearby places',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Find interesting places around you',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isScanning ? null : _scanNearbyPlaces,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: _isScanning
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Scanning...'),
                            ],
                          )
                        : const Text('Scan Nearby Places'),
                  ),
                ],
              ),
            )
          : Consumer<PlaceProvider>(
              builder: (context, placeProvider, child) {
                return Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nearby Places',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: _isScanning ? null : _scanNearbyPlaces,
                                icon: _isScanning
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.refresh),
                              ),
                              IconButton(
                                onPressed: _showMapView,
                                icon: const Icon(Icons.map),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Places List
                    Expanded(
                      child: placeProvider.nearbyPlaces.isEmpty
                          ? const Center(
                              child: Text(
                                'No nearby places found',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: placeProvider.nearbyPlaces.length,
                              itemBuilder: (context, index) {
                                final place = placeProvider.nearbyPlaces[index];
                                return PlaceCard(
                                  place: place,
                                  showDistance: true,
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}