class Place {
  final String id;
  final String placeName;
  final String state;
  final String district;
  final String category;
  final String timeToVisit;
  final String description;
  final String highlights;
  final String titleImage;
  final String? optionalImage1;
  final String? optionalImage2;
  final double latitude;
  final double longitude;
  final String? gmap;
  final String? tags;
  final double? distanceKm;
  final int? timeMin;

  Place({
    required this.id,
    required this.placeName,
    required this.state,
    required this.district,
    required this.category,
    required this.timeToVisit,
    required this.description,
    required this.highlights,
    required this.titleImage,
    this.optionalImage1,
    this.optionalImage2,
    required this.latitude,
    required this.longitude,
    this.gmap,
    this.tags,
    this.distanceKm,
    this.timeMin,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['_id'] ?? json['id'] ?? '',
      placeName: json['placeName'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      category: json['category'] ?? '',
      timeToVisit: json['timeToVisit'] ?? '',
      description: json['description'] ?? '',
      highlights: json['highlights'] ?? '',
      titleImage: json['titleImage'] ?? '',
      optionalImage1: json['optionalImage1'],
      optionalImage2: json['optionalImage2'],
      latitude: double.tryParse(json['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0') ?? 0.0,
      gmap: json['gmap'],
      tags: json['tags'],
      distanceKm: double.tryParse(json['distance_km']?.toString() ?? '0'),
      timeMin: int.tryParse(json['time_min']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placeName': placeName,
      'state': state,
      'district': district,
      'category': category,
      'timeToVisit': timeToVisit,
      'description': description,
      'highlights': highlights,
      'titleImage': titleImage,
      'optionalImage1': optionalImage1,
      'optionalImage2': optionalImage2,
      'latitude': latitude,
      'longitude': longitude,
      'gmap': gmap,
      'tags': tags,
      'distance_km': distanceKm,
      'time_min': timeMin,
    };
  }
}