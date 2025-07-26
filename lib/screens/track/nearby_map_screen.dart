import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/place_model.dart';

class NearbyMapScreen extends StatefulWidget {
  final List<Place> places;
  final Position? userLocation;

  const NearbyMapScreen({
    super.key,
    required this.places,
    this.userLocation,
  });

  @override
  State<NearbyMapScreen> createState() => _NearbyMapScreenState();
}

class _NearbyMapScreenState extends State<NearbyMapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setupMarkers();
  }

  void _setupMarkers() {
    final markers = <Marker>{};

    // Add user location marker
    if (widget.userLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(
            widget.userLocation!.latitude,
            widget.userLocation!.longitude,
          ),
          infoWindow: const InfoWindow(title: 'You are here'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    // Add place markers
    for (final place in widget.places) {
      markers.add(
        Marker(
          markerId: MarkerId(place.id),
          position: LatLng(place.latitude, place.longitude),
          infoWindow: InfoWindow(
            title: place.placeName,
            snippet: place.description,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = widget.userLocation != null
        ? LatLng(widget.userLocation!.latitude, widget.userLocation!.longitude)
        : widget.places.isNotEmpty
            ? LatLng(widget.places.first.latitude, widget.places.first.longitude)
            : const LatLng(10.8505, 76.2711); // Default to Kerala

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Places Map'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 13,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}