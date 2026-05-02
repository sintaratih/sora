import 'package:flutter/material.dart';
import 'pages/auth/landing_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/calendar/home_page.dart';
import 'pages/settings/settings_page.dart';

// 🔥 TAMBAH INI (dummy dulu)
class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Riwayat")),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SoraApp());
}

class SoraApp extends StatefulWidget {
  const SoraApp({super.key});

  @override
  State<SoraApp> createState() => _SoraAppState();
}

class _SoraAppState extends State<SoraApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sora',

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,

      initialRoute: '/',

      routes: {
        '/': (context) => LandingPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => MainPage(
              isDark: _themeMode == ThemeMode.dark,
              onToggle: toggleTheme,
            ),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  final bool isDark;
  final Function(bool) onToggle;

  const MainPage({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(),
      HistoryPage(), // 🔥 tambah ini
      SettingsPage(
        isDark: widget.isDark,
        onToggle: widget.onToggle,
      ),
    ];

    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Riwayat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Pengaturan",
          ),
        ],
      ),
    );
  }
}