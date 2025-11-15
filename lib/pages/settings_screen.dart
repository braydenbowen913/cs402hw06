import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../models/app_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();
    final settings = provider.settings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            value: settings.isDarkMode,
            onChanged: (val) => provider.toggleTheme(val),
          ),
          const Divider(),
          ListTile(
            title: const Text('Temperature units'),
            subtitle: Text(settings.tempUnit == TemperatureUnit.celsius
                ? 'Celsius'
                : 'Fahrenheit'),
          ),
          RadioListTile<TemperatureUnit>(
            title: const Text('Celsius'),
            value: TemperatureUnit.celsius,
            groupValue: settings.tempUnit,
            onChanged: (val) {
              if (val != null) provider.setTempUnit(val);
            },
          ),
          RadioListTile<TemperatureUnit>(
            title: const Text('Fahrenheit'),
            value: TemperatureUnit.fahrenheit,
            groupValue: settings.tempUnit,
            onChanged: (val) {
              if (val != null) provider.setTempUnit(val);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('24-hour time'),
            value: settings.use24Hour,
            onChanged: (val) => provider.setUse24Hour(val),
          ),
        ],
      ),
    );
  }
}
