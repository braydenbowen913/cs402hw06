import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hw06/models/app_settings.dart';
import '../models/photo_entry.dart';
import '../providers/settings_provider.dart';
import 'package:provider/provider.dart';

class PhotoCard extends StatelessWidget {
  final PhotoEntry entry;
  final VoidCallback onTap;

  const PhotoCard({super.key, required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>().settings;

    final time =
        settings.use24Hour ? '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}' :
        TimeOfDay.fromDateTime(entry.timestamp).format(context);
    final date =
        '${entry.timestamp.month}/${entry.timestamp.day}/${entry.timestamp.year}';

    double displayTemp() =>
        settings.tempUnit == TemperatureUnit.celsius
            ? entry.temperatureC
            : (entry.temperatureC * 9 / 5) + 32;

    final tempLabel =
        settings.tempUnit == TemperatureUnit.celsius ? '°C' : '°F';

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Image.file(
                File(entry.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                entry.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '$time  $date',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                '${displayTemp().toStringAsFixed(1)}$tempLabel • ${entry.weatherDescription}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
