import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hw06/models/app_settings.dart' show TemperatureUnit;
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';
import '../providers/settings_provider.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<PhotoProvider>();
    _pageController = PageController(initialPage: provider.currentIndex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<PhotoProvider>().loadPhotos();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _editDescription(BuildContext context) async {
    final photoProvider = context.read<PhotoProvider>();
    final photo = photoProvider.currentPhoto;
    if (photo == null) return;

    final controller = TextEditingController(text: photo.description);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit description'),
        content: TextField(
          controller: controller,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      await photoProvider.updateDescription(photo, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoProvider = context.watch<PhotoProvider>();
    final settings = context.watch<SettingsProvider>().settings;

    final photos = photoProvider.filteredPhotos;
    //final current = photoProvider.currentPhoto;

    String formatTime(DateTime dt) {
      if (settings.use24Hour) {
        final h = dt.hour.toString().padLeft(2, '0');
        final m = dt.minute.toString().padLeft(2, '0');
        return '$h:$m';
      }
      return TimeOfDay.fromDateTime(dt).format(context);
    }

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
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
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
          ? const Center(child: Text('No photos yet. Tap + to add one.'))
          : Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: photos.length,
                    onPageChanged: (index) {
                      context.read<PhotoProvider>().setCurrentIndex(index);
                    },
                    itemBuilder: (context, index) {
                      final entry = photos[index];
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 300,
                              child: Image.file(
                                File(entry.imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () => _editDescription(context),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    Text(
                                      entry.description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${formatTime(entry.timestamp)} '
                                      '${entry.timestamp.month}/${entry.timestamp.day}/${entry.timestamp.year}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: const Icon(Icons.location_pin),
                              title: Text(entry.locationName),
                            ),
                            ListTile(
                              leading: const Icon(Icons.cloud),
                              title: Text(
                                  '${displayTemp(entry.temperatureC).toStringAsFixed(1)}$tempLabel ${entry.weatherDescription}'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.read<PhotoProvider>().addNewPhoto();
          _pageController.jumpToPage(0);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
