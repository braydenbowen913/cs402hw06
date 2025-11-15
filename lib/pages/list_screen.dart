import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hw06/models/app_settings.dart' show TemperatureUnit;
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';
import '../providers/settings_provider.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final photos = context.watch<PhotoProvider>().filteredPhotos;
    final settings = context.watch<SettingsProvider>().settings;

    double displayTemp(double c) => settings.tempUnit == TemperatureUnit.celsius
        ? c
        : (c * 9 / 5) + 32;
    final tempLabel =
        settings.tempUnit == TemperatureUnit.celsius ? '°C' : '°F';

    return Scaffold(
      appBar: AppBar(
        title: const Text('WindowPane'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) =>
                  context.read<PhotoProvider>().setSearchQuery(value),
            ),
          ),
        ),
      ),
      body: photos.isEmpty
          ? const Center(child: Text('No photos'))
          : ListView.builder(
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final entry = photos[index];
                return Dismissible(
                  key: ValueKey(entry.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete photo'),
                        content: const Text(
                            'Are you sure you want to delete this entry?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    return confirm ?? false;
                  },
                  onDismissed: (direction) =>
                      context.read<PhotoProvider>().deletePhoto(entry),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    leading: SizedBox(
                      width: 56,
                      height: 56,
                      child: Image.file(
                        File(entry.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(entry.description),
                    subtitle: Text(
                      '${entry.timestamp.month}/${entry.timestamp.day}/${entry.timestamp.year} '
                      '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}'
                      ' • ${displayTemp(entry.temperatureC).toStringAsFixed(1)}$tempLabel',
                    ),
                    onTap: () {
                      // set this as current and pop to home
                      final provider = context.read<PhotoProvider>();
                      final idx = provider.photos.indexWhere(
                          (p) => p.id == entry.id); // index in full list
                      if (idx != -1) {
                        provider.setCurrentIndex(idx);
                      }
                      // navigation handled in main bottom nav; just switch tab:
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<PhotoProvider>().addNewPhoto(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
