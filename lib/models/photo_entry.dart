class PhotoEntry {
  final int? id;
  final String imagePath;
  final String description;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String locationName;
  final String weatherDescription;
  final double temperatureC; // store in Celsius in DB

  PhotoEntry({
    this.id,
    required this.imagePath,
    required this.description,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.weatherDescription,
    required this.temperatureC,
  });

  PhotoEntry copyWith({
    int? id,
    String? imagePath,
    String? description,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    String? locationName,
    String? weatherDescription,
    double? temperatureC,
  }) {
    return PhotoEntry(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      weatherDescription: weatherDescription ?? this.weatherDescription,
      temperatureC: temperatureC ?? this.temperatureC,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'description': description,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'latitude': latitude,
      'longitude': longitude,
      'locationName': locationName,
      'weatherDescription': weatherDescription,
      'temperatureC': temperatureC,
    };
  }

  factory PhotoEntry.fromMap(Map<String, dynamic> map) {
    return PhotoEntry(
      id: map['id'] as int?,
      imagePath: map['imagePath'] as String,
      description: map['description'] as String,
      timestamp:
          DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      locationName: map['locationName'] as String,
      weatherDescription: map['weatherDescription'] as String,
      temperatureC: map['temperatureC'] as double,
    );
  }
}
