import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../providers/place_provider.dart';
import '../../services/location_service.dart';
import '../../models/place_model.dart';
import '../../widgets/place_details_sheet.dart';
import 'package:geolocator/geolocator.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  GoogleMapController? _mapController;
  final LocationService _locationService = LocationService();
  final TextEditingController _searchController = TextEditingController();
  
  Position? _userLocation;
  Set<Marker> _markers = {};
  Place? _selectedPlace;
  bool _showSearchResults = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    final position = await _locationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        _userLocation = position;
        _markers.add(
          Marker(
            markerId: const MarkerId('user_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'You are here'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
      });
      
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
    }
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _showSearchResults = true;
      });
      Provider.of<PlaceProvider>(context, listen: false).searchPlaces(query);
    } else {
      setState(() {
        _showSearchResults = false;
      });
    }
  }

  void _onPlaceSelected(Place place) {
    setState(() {
      _selectedPlace = place;
      _showSearchResults = false;
      _searchController.text = place.placeName;
    });

    final marker = Marker(
      markerId: MarkerId(place.id),
      position: LatLng(place.latitude, place.longitude),
      infoWindow: InfoWindow(title: place.placeName),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    setState(() {
      _markers.removeWhere((m) => m.markerId.value != 'user_location');
      _markers.add(marker);
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(place.latitude, place.longitude),
        15,
      ),
    );

    _showPlaceDetails(place);
  }

  void _showPlaceDetails(Place place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PlaceDetailsSheet(place: place),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _userLocation != null
                  ? LatLng(_userLocation!.latitude, _userLocation!.longitude)
                  : const LatLng(10.8505, 76.2711), // Default to Kerala
              zoom: 13,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          
          // Search Bar
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search a place...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                  
                  // Search Results
                  if (_showSearchResults)
                    Consumer<PlaceProvider>(
                      builder: (context, placeProvider, child) {
                        if (placeProvider.isLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          );
                        }
                        
                        if (placeProvider.searchedPlaces.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No places found'),
                          );
                        }
                        
                        return Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: placeProvider.searchedPlaces.length,
                            itemBuilder: (context, index) {
                              final place = placeProvider.searchedPlaces[index];
                              return ListTile(
                                title: Text(place.placeName),
                                subtitle: Text('${place.district}, ${place.state}'),
                                onTap: () => _onPlaceSelected(place),
                              );
                            },
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}