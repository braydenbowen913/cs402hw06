enum TemperatureUnit { celsius, fahrenheit }

class AppSettings {
  final bool isDarkMode;
  final TemperatureUnit tempUnit;
  final bool use24Hour;

  const AppSettings({
    this.isDarkMode = false,
    this.tempUnit = TemperatureUnit.celsius,
    this.use24Hour = true,
  });

  AppSettings copyWith({
    bool? isDarkMode,
    TemperatureUnit? tempUnit,
    bool? use24Hour,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      tempUnit: tempUnit ?? this.tempUnit,
      use24Hour: use24Hour ?? this.use24Hour,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isDarkMode': isDarkMode ? 1 : 0,
      'tempUnit': tempUnit.index,
      'use24Hour': use24Hour ? 1 : 0,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      isDarkMode: (map['isDarkMode'] ?? 0) == 1,
      tempUnit: TemperatureUnit.values[map['tempUnit'] ?? 0],
      use24Hour: (map['use24Hour'] ?? 1) == 1,
    );
  }
}
