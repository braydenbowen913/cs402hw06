import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/photo_entry.dart';
import '../services/db_service.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import '../services/photo_service.dart';

class PhotoProvider extends ChangeNotifier {
  final List<PhotoEntry> _photos = [];
  int _currentIndex = 0;
  String _searchQuery = '';

  final _locationService = LocationService();
  final _weatherService = WeatherService();
  final _photoService = PhotoService();

  List<PhotoEntry> get photos => _photos;
  int get currentIndex => _currentIndex;
  String get searchQuery => _searchQuery;

  List<PhotoEntry> get filteredPhotos {
    if (_searchQuery.isEmpty) return List.unmodifiable(_photos);
    final q = _searchQuery.toLowerCase();
    return _photos
        .where((p) => p.description.toLowerCase().contains(q))
        .toList(growable: false);
  }

  PhotoEntry? get currentPhoto =>
      _photos.isEmpty ? null : _photos[_currentIndex];

  Future<void> loadPhotos() async {
    final db = await DBService().database;
    final rows = await db.query('photos', orderBy: 'timestamp DESC');
    _photos
      ..clear()
      ..addAll(rows.map((e) => PhotoEntry.fromMap(e)));
    if (_currentIndex >= _photos.length) _currentIndex = 0;
    notifyListeners();
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void setCurrentIndex(int idx) {
    if (idx >= 0 && idx < _photos.length) {
      _currentIndex = idx;
      notifyListeners();
    }
  }

  Future<PhotoEntry?> addNewPhoto() async {
    try {
      // 1. Take the photo
      final imagePath = await _photoService.takePhoto();
    if (imagePath == null) return null; // user cancelled

      final now = DateTime.now();

      // 2. Default metadata (in case services fail)
      double latitude = 0;
      double longitude = 0;
      String locationName = 'Unknown location';
      String weatherDescription = 'Unknown weather';
      double temperatureC = 0;

      // 3. Try to get GPS
      try {
        final position = await _locationService.getCurrentPosition();
        latitude = position.latitude;
        longitude = position.longitude;
        locationName =
            '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
      } catch (_) {}

      // 4. Try to get weather (only if we have some coords)
      try {
        final weather = await _weatherService.getWeather(latitude, longitude);
        weatherDescription = weather.description;
        temperatureC = weather.tempC;
      } catch (e) {
        debugPrint('Weather error: $e');
      }

      // 5. Build entry
      final newEntry = PhotoEntry(
        imagePath: imagePath,
        description: 'New photo',
        timestamp: now,
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
        weatherDescription: weatherDescription,
        temperatureC: temperatureC,
      );

      // 6. Save to DB
      final db = await DBService().database;
      final id = await db.insert('photos', newEntry.toMap());
      final entryWithId = newEntry.copyWith(id: id);

      // 7. Update in-memory list & clear any search filter
      _searchQuery = '';
      _photos.insert(0, entryWithId);
      _currentIndex = 0;
      notifyListeners();

      return entryWithId;
      debugPrint('Photo saved with id: $id');
    } catch (e, st) {
      debugPrint('addNewPhoto failed: $e\n$st');
      return null;
    }
  }

  Future<void> deletePhoto(PhotoEntry entry) async {
    final db = await DBService().database;
    await db.delete('photos', where: 'id = ?', whereArgs: [entry.id]);
    final idx = _photos.indexWhere((e) => e.id == entry.id);
    if (idx != -1) {
      _photos.removeAt(idx);
      if (_currentIndex >= _photos.length) {
        _currentIndex = _photos.isEmpty ? 0 : _photos.length - 1;
      }
      notifyListeners();
    }
  }

  Future<void> updateDescription(PhotoEntry entry, String description) async {
    final updated = entry.copyWith(description: description);
    final db = await DBService().database;
    await db.update(
      'photos',
      updated.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
    final idx = _photos.indexWhere((e) => e.id == entry.id);
    if (idx != -1) {
      _photos[idx] = updated;
      notifyListeners();
    }
  }
}
