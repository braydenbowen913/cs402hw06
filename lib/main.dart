import 'package:flutter/material.dart';
import 'package:pages/home_screen.dart';
import 'package:pages/list_view_screen.dart';
import 'package:pages/grid_view_screen.dart';
import 'package:pagessettings_screen.dart';
import 'package:models/photo.dart';

void main() {
  runApp(WindowPaneApp());
}

class WindowPaneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WindowPane',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Photo> _photos = [
    Photo(
      imagePath: 'assets/sunrise.jpg',
      description: 'Sunrise over the valley',
      dateTime: DateTime(2024, 10, 12, 7, 35),
      location: '123 Main Street, Boise, Idaho',
      temperature: 12,
      weather: 'Clear skies',
    ),
    Photo(
      imagePath: 'assets/alexander.jpg',
      description: 'Alexander home from the groomer',
      dateTime: DateTime(2024, 7, 18, 14, 37),
      location: '123 Main Street, Boise, Idaho',
      temperature: 22,
      weather: 'Sunny',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WindowPane'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: _getScreenForIndex(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_on),
            label: 'Grid',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Trigger the camera functionality
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _getScreenForIndex() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(currentPhoto: _photos[0]); // Pass the first photo for example
      case 1:
        return ListViewScreen(photos: _photos);
      case 2:
        return GridViewScreen(photos: _photos);
      default:
        return HomeScreen(currentPhoto: _photos[0]);
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
