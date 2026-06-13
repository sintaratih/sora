import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/login_page.dart';
import 'about_page.dart';
import 'help_center_page.dart';


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

class _SettingsPageState
    extends State<SettingsPage> {
  late bool isDarkMode; bool notificationsEnabled = true;

  final supabase = Supabase.instance.client;

  @override
    void initState() {
      super.initState();
      isDarkMode = widget.isDark;
    }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
        Brightness.dark;
    final user =
    Supabase.instance.client.auth.currentUser;

    final userName =
        user?.userMetadata?['name'] ??
        'User';

    final userEmail =
        user?.email ?? '';

    return Scaffold(
      backgroundColor:
          isDark
              ? const Color(0xFF121212)
              : const Color(0xFFF5F0FF),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    /// PROFILE
                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1E1E)
                          : Colors.white,

                      borderRadius:
                          BorderRadius.circular(24),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.deepPurple.withOpacity(0.15),
                          child: const Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.deepPurple,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                userEmail,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                    const SizedBox(
                      height: 30,
                    ),

                    /// GENERAL
                    Text(
                      "General",
                      style: TextStyle(
                        color:
                            isDark
                                ? Colors
                                    .white70
                                : Colors.grey,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    _menuCard(
                      isDark,
                      [
                        _menuTile(
                          isDark,
                          icon:
                              Icons.dark_mode,
                          title:
                              "Dark Mode",

                          trailing: Switch(
                            value:
                                isDarkMode,

                            activeColor:
                                Colors
                                    .deepPurple,

                            onChanged: (
                              value,
                            ) {
                              setState(() {
                                isDarkMode =
                                    value;
                              });

                              widget
                                  .onToggle(
                                    value,
                                  );
                            },
                          ),
                        ),

                        _divider(isDark),

                        _menuTile(
                          isDark,
                          icon: Icons.notifications,
                          title: "Notifications",
                          trailing: Switch(
                            value: notificationsEnabled,
                            activeColor: Colors.deepPurple,
                            onChanged: (value) {
                              setState(() {
                                notificationsEnabled = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    /// SUPPORT
                    Text(
                      "Support",
                      style: TextStyle(
                        color:
                            isDark
                                ? Colors
                                    .white70
                                : Colors.grey,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    _menuCard(
                      isDark,
                      [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HelpCenterPage(),
                            ),
                          );
                        },
                        child: _menuTile(
                          isDark,
                          icon: Icons.help_outline,
                          title: "Help Center",
                          trailing: Icon(
                            Icons.chevron_right,
                            color: isDark
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                      ),

                      _divider(isDark),

                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AboutPage(),
                              ),
                            );
                          },
                          child: _menuTile(
                            isDark,
                            icon: Icons.info_outline,
                            title: "About App",

                            trailing: Icon(
                              Icons.chevron_right,
                              color: isDark
                                  ? Colors.white70
                                  : Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    /// LOGOUT
                    SizedBox(
                      width:
                          double.infinity,
                      height: 55,

                      child:
                          ElevatedButton.icon(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Logout"),
                                    content: const Text(
                                      "Apakah kamu yakin ingin keluar?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: const Text("Batal"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: const Text("Logout"),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm == true) {
                                await Supabase.instance.client.auth.signOut();

                                if (!mounted) return;

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPage(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                            style:
                                ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(
                                        0xFF8E24AA,
                                      ),

                                  shape:
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                              18,
                                            ),
                                      ),
                                ),

                            icon: const Icon(
                              Icons.logout,
                              color:
                                  Colors.white,
                            ),

                            label: const Text(
                              "Logout",
                              style: TextStyle(
                                color:
                                    Colors
                                        .white,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuCard(
    bool isDark,
    List<Widget> children,
  ) {
    return Container(
      decoration: BoxDecoration(
        color:
            isDark
                ? const Color(
                  0xFF1E1E1E,
                )
                : Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        children: children,
      ),
    );
  }

  Widget _menuTile(
    bool isDark, {
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            Colors.deepPurple
                .withOpacity(0.15),

        child: Icon(
          icon,
          color: Colors.deepPurple,
        ),
      ),

      title: Text(
        title,
        style: TextStyle(
          fontWeight:
              FontWeight.w600,
          color:
              isDark
                  ? Colors.white
                  : Colors.black,
        ),
      ),

      trailing: trailing,
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      color:
          isDark
              ? Colors.white12
              : Colors.black12,
      height: 1,
      indent: 20,
      endIndent: 20,
    );
  }
}