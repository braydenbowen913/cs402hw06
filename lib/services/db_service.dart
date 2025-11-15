import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, 'window_pane.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE photos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagePath TEXT NOT NULL,
            description TEXT NOT NULL,
            timestamp INTEGER NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            locationName TEXT NOT NULL,
            weatherDescription TEXT NOT NULL,
            temperatureC REAL NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE settings(
            id INTEGER PRIMARY KEY,
            isDarkMode INTEGER NOT NULL,
            tempUnit INTEGER NOT NULL,
            use24Hour INTEGER NOT NULL
          );
        ''');

        await db.insert('settings', {
          'id': 0,
          'isDarkMode': 0,
          'tempUnit': 0,
          'use24Hour': 1,
        });
      },
    );
  }
}
