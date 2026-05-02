import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  Map<DateTime, List<Map<String, dynamic>>> notes = {};

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _onDaySelected(DateTime day, DateTime focus) {
    setState(() {
      selectedDay = normalizeDate(day);
      focusedDay = focus;
    });
  }

  /// ADD TASK
  void _addNote() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Tambah Tugas"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Masukkan tugas...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isEmpty) return;

              final key = normalizeDate(selectedDay);

              notes[key] = [
                ...(notes[key] ?? []),
                {
                  "title": controller.text,
                  "isDone": false,
                }
              ];

              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  /// EDIT TASK
  void _editTask(int index, Map<String, dynamic> task) {
    TextEditingController controller =
        TextEditingController(text: task["title"]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Tugas"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              final key = normalizeDate(selectedDay);

              if (notes[key] != null &&
                  notes[key]!.length > index &&
                  controller.text.isNotEmpty) {
                notes[key]![index]["title"] = controller.text;
              }

              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Update"),
          )
        ],
      ),
    );
  }

  /// DELETE TASK
  void _deleteTask(int index) {
    final key = normalizeDate(selectedDay);

    if (notes[key] != null && notes[key]!.length > index) {
      notes[key]!.removeAt(index);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final key = normalizeDate(selectedDay);
    final todayNotes = notes[key] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[100],

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              const Text(
                "Hai, Aulia 👋",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Semangat menjalani harimu!",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              /// CALENDAR
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: TableCalendar(
                  focusedDay: focusedDay,
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),

                  selectedDayPredicate: (day) =>
                      isSameDay(day, selectedDay),

                  onDaySelected: _onDaySelected,

                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },

                  rowHeight: 40,
                  daysOfWeekVisible: true,

                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),

                  calendarStyle: CalendarStyle(
                    defaultTextStyle:
                        const TextStyle(color: Colors.black),
                    weekendTextStyle:
                        const TextStyle(color: Colors.red),

                    todayDecoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                    ),
                  ),

                  /// 🔥 FIX ERROR DI SINI
                  eventLoader: (day) {
                    final key = normalizeDate(day);
                    final list = notes[key] ?? [];

                    return list
                        .map((e) => e["title"] as String)
                        .toList();
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// TITLE
              Text(
                "Agenda Hari Ini - ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              /// LIST TASK
              Expanded(
                child: todayNotes.isEmpty
                    ? Center(
                        child: Text(
                          "Belum ada tugas.\nKlik + untuk menambahkan.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        itemCount: todayNotes.length,
                        itemBuilder: (context, index) {
                          return _taskCard(todayNotes[index], index);
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// TASK CARD
  Widget _taskCard(Map<String, dynamic> task, int index) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Edit"),
                onTap: () {
                  Navigator.pop(context);
                  _editTask(index, task);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Hapus"),
                onTap: () {
                  Navigator.pop(context);
                  _deleteTask(index);
                },
              ),
            ],
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [

            /// DOT
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: (task["isDone"] ?? false)
                    ? Colors.green
                    : Colors.deepPurple,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 12),

            /// TITLE
            Expanded(
              child: Text(
                task["title"] ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  decoration: (task["isDone"] ?? false)
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),

            /// CHECKBOX
            Checkbox(
              value: task["isDone"] ?? false,
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                final key = normalizeDate(selectedDay);

                if (notes[key] != null &&
                    notes[key]!.length > index) {
                  notes[key]![index]["isDone"] = value ?? false;
                }

                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}