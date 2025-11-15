import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date formatting
import 'package:windowpane/models/photo.dart'; // Model for photo data

class HomeScreen extends StatelessWidget {
  final Photo currentPhoto;

  HomeScreen({required this.currentPhoto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WindowPane'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings screen
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(currentPhoto.imagePath), // Display photo
            Text(currentPhoto.description), // Show description
            Text(DateFormat('yyyy-MM-dd HH:mm').format(currentPhoto.dateTime)),
            Text(currentPhoto.location),
            Text('${currentPhoto.temperature}° ${currentPhoto.weather}'),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Show modal to edit description
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Trigger photo capture
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}