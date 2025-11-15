import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  String temperatureUnit = 'Celsius';
  bool is24HourTime = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (bool value) {
              setState(() {
                isDarkMode = value;
              });
            },
          ),
          ListTile(
            title: Text('Temperature Unit'),
            trailing: DropdownButton<String>(
              value: temperatureUnit,
              onChanged: (String? newValue) {
                setState(() {
                  temperatureUnit = newValue!;
                });
              },
              items: <String>['Celsius', 'Fahrenheit']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SwitchListTile(
            title: Text('24-hour time format'),
            value: is24HourTime,
            onChanged: (bool value) {
              setState(() {
                is24HourTime = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
