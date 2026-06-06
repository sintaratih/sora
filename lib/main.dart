import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_preview/device_preview.dart';

/// PAGES
import 'pages/auth/login_page.dart';
import 'pages/home/home_page.dart';
import 'pages/history/history_page.dart';
import 'pages/notes/notes_page.dart';
import 'pages/settings/settings_page.dart';
import 'package:device_preview/device_preview.dart';
/// MAIN
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tchpgvkehtkjobultzge.supabase.co',
    anonKey: 'sb_publishable_qX5G5mF7-ZFaI_oh6esoUA_P_NP_-bc',
  );

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const SoraApp(),
    ),
  );
}

/// APP
class SoraApp extends StatefulWidget {
  const SoraApp({super.key});

  @override
  State<SoraApp> createState() => _SoraAppState();
}

class _SoraAppState extends State<SoraApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode =
          isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sora',

      /// DEVICE PREVIEW
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      /// LIGHT THEME
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,

        scaffoldBackgroundColor: const Color(0xFFF7F4FB),

        cardColor: Colors.white,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          foregroundColor: Colors.black,
        ),

        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
        ),
      ),

      /// DARK THEME
      darkTheme: ThemeData(
        brightness: Brightness.dark,

        scaffoldBackgroundColor:
            const Color(0xFF121212),

        cardColor:
            const Color(0xFF1E1E1E),

        appBarTheme: const AppBarTheme(
          backgroundColor:
              Color(0xFF1E1E1E),
          elevation: 0,
          centerTitle: true,
          foregroundColor: Colors.white,
        ),

        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(
          backgroundColor:
              Color(0xFF1E1E1E),
          selectedItemColor:
              Colors.deepPurple,
          unselectedItemColor:
              Colors.grey,
        ),
      ),

      themeMode: _themeMode,

      /// AUTH CHECK
      home: StreamBuilder<AuthState>(
        stream:
            Supabase.instance.client.auth.onAuthStateChange,

        builder: (context, snapshot) {
          final session =
              Supabase.instance.client.auth.currentSession;

          if (session == null) {
            return const LoginPage();
          } else {
            return MainPage(
              isDark:
                  _themeMode == ThemeMode.dark,

              onToggle: toggleTheme,
            );
          }
        },
      ),
    );
  }
}

/// MAIN PAGE
class MainPage extends StatefulWidget {
  final bool isDark;
  final Function(bool) onToggle;

  const MainPage({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  @override
  State<MainPage> createState() =>
      _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      NotesPage(),
      const HistoryPage(),

      SettingsPage(
        isDark: widget.isDark,
        onToggle: widget.onToggle,
      ),
    ];

    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        type: BottomNavigationBarType.fixed,

        selectedItemColor:
            Theme.of(context)
                .bottomNavigationBarTheme
                .selectedItemColor,

        unselectedItemColor:
            Theme.of(context)
                .bottomNavigationBarTheme
                .unselectedItemColor,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_outlined),
            label: "Notes",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}