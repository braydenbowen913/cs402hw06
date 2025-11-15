import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:windowpane/models/photo.dart';

class GridViewScreen extends StatelessWidget {
  final List<Photo> photos;

  GridViewScreen({required this.photos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photos')),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return GestureDetector(
            onTap: () {
              // Navigate to Home screen with the selected photo
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(currentPhoto: photo)),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Image.asset(photo.imagePath),
                  Text(photo.description),
                  Text(photo.dateTime.toString()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
