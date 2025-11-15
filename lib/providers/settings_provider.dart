import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../services/db_service.dart';
import 'package:sqflite/sqflite.dart';

class SettingsProvider extends ChangeNotifier {
  AppSettings _settings = const AppSettings();
  bool _loaded = false;

  AppSettings get settings => _settings;
  bool get isLoaded => _loaded;

  Future<void> loadSettings() async {
    final db = await DBService().database;
    final rows = await db.query('settings', where: 'id = ?', whereArgs: [0]);
    if (rows.isNotEmpty) {
      _settings = AppSettings.fromMap(rows.first);
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final db = await DBService().database;
    await db.update(
      'settings',
      _settings.toMap(),
      where: 'id = ?',
      whereArgs: [0],
    );
  }

  void toggleTheme(bool dark) {
    _settings = _settings.copyWith(isDarkMode: dark);
    _save();
    notifyListeners();
  }

  void setTempUnit(TemperatureUnit unit) {
    _settings = _settings.copyWith(tempUnit: unit);
    _save();
    notifyListeners();
  }

  void setUse24Hour(bool value) {
    _settings = _settings.copyWith(use24Hour: value);
    _save();
    notifyListeners();
  }
}
