import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:windowpane/models/photo.dart';

class ListViewScreen extends StatelessWidget {
  final List<Photo> photos;

  ListViewScreen({required this.photos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photos')),
      body: ListView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return ListTile(
            title: Text(photo.description),
            subtitle: Text('${photo.dateTime} - ${photo.location}'),
            onTap: () {
              // Navigate to Home screen with the selected photo
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(currentPhoto: photo)),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Delete the photo with confirmation
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Delete Photo'),
                      content: Text('Are you sure you want to delete this photo?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Delete action
                          },
                          child: Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}