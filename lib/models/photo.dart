class Photo {
  final String imagePath;
  final String description;
  final DateTime dateTime;
  final String location;
  final int temperature; // in Celsius
  final String weather;

  Photo({
    required this.imagePath,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.temperature,
    required this.weather,
  });
}
