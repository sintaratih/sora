import 'package:flutter/material.dart';
import '../calendar/calendar_settings_page.dart';

class SettingsPage extends StatefulWidget {
  final bool isDark;
  final Function(bool) onToggle;

  const SettingsPage({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, bool> calendars = {
    "Masehi": true,
    "Hijriyah": true,
    "China": false,
  };

  late String themeMode;

  @override
  void initState() {
    super.initState();
    themeMode = widget.isDark ? "Dark" : "Light";
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Yakin mau keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            /// 🔥 HEADER SORA STYLE
            const Text(
              "Pengaturan",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// ===== AKUN =====
            _sectionTitle("Akun"),
            _card([
              _item(Icons.person, "Ganti Akun"),
            ]),

            const SizedBox(height: 16),

            /// ===== PENGATURAN =====
            _sectionTitle("Pengaturan Aplikasi"),
            _card([
              _themeSelector(),
              _switchItem(Icons.notifications, "Pengingat", true, (v) {}),
              _navItem(
                Icons.calendar_today,
                "Kalender lainnya",
                subtitle: calendars.entries
                    .where((e) => e.value)
                    .map((e) => e.key)
                    .join(", "),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CalendarSettingsPage(calendars: calendars),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      calendars = result;
                    });
                  }
                },
              ),
            ]),

            const SizedBox(height: 16),

            /// ===== LAINNYA =====
            _sectionTitle("Lainnya"),
            _card([
              _item(Icons.info, "Tentang kami"),
              _item(Icons.help_outline, "Bantuan & FAQ"),
            ]),

            const SizedBox(height: 16),

            /// LOGOUT
            _card([
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => _showLogoutDialog(context),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  /// 🔥 THEME SELECTOR (INI YANG PENTING)
  Widget _themeSelector() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tema"),
          const SizedBox(height: 10),
          Row(
            children: [
              _themeOption("Light"),
              const SizedBox(width: 10),
              _themeOption("Dark"),
            ],
          )
        ],
      ),
    );
  }

  Widget _themeOption(String mode) {
    final isSelected = themeMode == mode;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            themeMode = mode;
          });

          widget.onToggle(mode == "Dark");
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.deepPurple
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            mode,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ),
    );
  }

  /// ===== UI COMPONENT =====

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _item(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _navItem(
    IconData icon,
    String title, {
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _switchItem(
    IconData icon,
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}