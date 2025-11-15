import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_settings.dart';
import 'providers/photo_provider.dart';
import 'providers/settings_provider.dart';
import 'pages/home_screen.dart';
import 'pages/list_screen.dart';
import 'pages/grid_screen.dart';
import 'pages/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>.value(
          value: settingsProvider,
        ),
        ChangeNotifierProvider(create: (_) => PhotoProvider()..loadPhotos()),
      ],
      child: const WindowPaneApp(),
    ),
  );
}

class WindowPaneApp extends StatelessWidget {
  const WindowPaneApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>().settings;

    return MaterialApp(
      title: 'WindowPane',
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorSchemeSeed: Colors.cyan,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.cyan,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      routes: {
        '/': (_) => const MainScaffold(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    ListScreen(),
    GridScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
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
    );
  }
}
