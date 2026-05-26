import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final bool isDark;
  final Function(bool) onToggle;

  const SettingsPage({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  @override
  State<SettingsPage> createState() =>
      _SettingsPageState();
}

class _SettingsPageState
    extends State<SettingsPage> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              /// HEADER
              const Text(
                "Settings",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              /// PROFILE CARD
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(24),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.05),

                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor:
                          Colors.deepPurple,

                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: const [
                          Text(
                            "Xiao Yin",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Manage your account",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.chevron_right,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// GENERAL
              const Text(
                "General",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _menuCard(
                children: [
                  _menuTile(
                    icon: Icons.dark_mode,
                    title: "Dark Mode",

                    trailing: Switch(
                      value: isDarkMode,

                      onChanged: (value) {
                        setState(() {
                          isDarkMode = value;
                        });

                        widget.onToggle(value);
                      },
                    ),
                  ),

                  _divider(),

                  _menuTile(
                    icon: Icons.notifications,
                    title: "Notifications",
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                  ),

                  _divider(),

                  _menuTile(
                    icon: Icons.calendar_today,
                    title: "Calendar",
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// SUPPORT
              const Text(
                "Support",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _menuCard(
                children: [
                  _menuTile(
                    icon: Icons.help_outline,
                    title: "Help Center",
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                  ),

                  _divider(),

                  _menuTile(
                    icon: Icons.info_outline,
                    title: "About App",
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// LOGOUT
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(
                  onPressed: () {},

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                  ),

                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),

                  label: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// CARD
  Widget _menuCard({
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        children: children,
      ),
    );
  }

  /// TILE
  Widget _menuTile({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            Colors.deepPurple.withOpacity(0.1),

        child: Icon(
          icon,
          color: Colors.deepPurple,
        ),
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),

      trailing: trailing,
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      indent: 20,
      endIndent: 20,
    );
  }
}