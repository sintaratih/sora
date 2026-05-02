import 'package:flutter/material.dart';

class CalendarSettingsPage extends StatefulWidget {
  final Map<String, bool> calendars;

  const CalendarSettingsPage({
    super.key,
    required this.calendars,
  });

  @override
  State<CalendarSettingsPage> createState() => _CalendarSettingsPageState();
}

class _CalendarSettingsPageState extends State<CalendarSettingsPage> {
  late Map<String, bool> _calendars;

  @override
  void initState() {
    super.initState();
    _calendars = Map.from(widget.calendars);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan Kalender"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Pilih Kalender",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          ..._calendars.keys.map((key) {
            return SwitchListTile(
              title: Text(key),
              value: _calendars[key]!,
              onChanged: (value) {
                setState(() {
                  _calendars[key] = value;
                });
              },
            );
          }).toList(),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _calendars);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}