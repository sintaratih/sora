import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  List<Map<String, dynamic>> allTasks = [];
  List<Map<String, dynamic>> allNotes = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
    loadNotes();
  }

  /// LOAD TASKS
  Future<void> loadTasks() async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    final data = await supabase
        .from('task')
        .select()
        .eq('user_id', user.id)
        .order('date');

    setState(() {
      allTasks = List<Map<String, dynamic>>.from(data);
    });
  }

  /// LOAD NOTES
  Future<void> loadNotes() async {
    final data = await supabase
        .from('notes')
        .select()
        .order(
          'created_at',
          ascending: false,
        );

    setState(() {
      allNotes = List<Map<String, dynamic>>.from(data);
    });
  }

  /// USER NAME
  String get userName {
    final user = supabase.auth.currentUser;

    if (user == null) return "User";

    final name = user.userMetadata?['name'];

    if (name != null && name != "") return name;

    return user.email?.split('@')[0] ?? "User";
  }

  /// GREETING
  String get greeting {
    final hour = DateTime.now().hour;

    if (hour < 10) return "Selamat pagi";
    if (hour < 14) return "Selamat siang";
    if (hour < 19) return "Selamat sore";
    return "Selamat malam";
  }

    String get dayLabel {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day,
    );

    final diff = selected.difference(today).inDays;

    if (diff == 0) return "Hari Ini";
    if (diff == 1) return "Besok";
    if (diff == -1) return "Kemarin";

    // hari yang lebih jauh
    return "${selectedDay.day}/${selectedDay.month}/${selectedDay.year}";
  }

  /// FILTER TASK
  List<Map<String, dynamic>> get todayTasks {
    return allTasks.where((task) {
      final rawDate = task['date'];

      if (rawDate == null) return false;

      final d = DateTime.tryParse(rawDate);

      if (d == null) return false;

      return d.year == selectedDay.year &&
          d.month == selectedDay.month &&
          d.day == selectedDay.day;
    }).toList();
  }

  /// TODAY NOTES
  List<Map<String, dynamic>> get todayNotes {
    return allNotes.where((note) {
      final rawDate =
          note['created_at']?.toString();

      if (rawDate == null) return false;

      final d = DateTime.tryParse(rawDate);

      if (d == null) return false;

      return d.year == selectedDay.year &&
          d.month == selectedDay.month &&
          d.day == selectedDay.day;
    }).toList();
  }

  /// ADD TASK
  void _addTask() {
    final titleController =
        TextEditingController();

    final descController =
        TextEditingController();

    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder:
            (ctx, setStateDialog) =>
                AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(24),
          ),

          title: const Text(
            "Tambah Agenda",
          ),

          content: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              TextField(
                controller:
                    titleController,

                decoration:
                    const InputDecoration(
                  labelText:
                      "Nama Agenda",
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              TextField(
                controller:
                    descController,

                decoration:
                    const InputDecoration(
                  labelText:
                      "Deskripsi",
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                children: [
                  Text(
                    selectedTime ==
                            null
                        ? "Pilih Jam"
                        : selectedTime!
                            .format(
                            context,
                          ),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed:
                        () async {
                      final time =
                          await showTimePicker(
                        context:
                            context,

                        initialTime:
                            TimeOfDay
                                .now(),
                      );

                      if (time !=
                          null) {
                        setStateDialog(
                          () {
                            selectedTime =
                                time;
                          },
                        );
                      }
                    },

                    child:
                        const Text(
                      "Set",
                    ),
                  )
                ],
              )
            ],
          ),

          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                ctx,
              ),

              child: const Text(
                "Batal",
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                if (titleController
                    .text
                    .trim()
                    .isEmpty) {
                  return;
                }

                final user =
                    supabase
                        .auth
                        .currentUser;

                await supabase
                    .from('task')
                    .insert({
                  'user_id':
                      user!.id,

                  'title':
                      titleController
                          .text
                          .trim(),

                  'description':
                      descController
                          .text
                          .trim(),

                  'is_done':
                      false,

                  'date': DateTime(
                    selectedDay.year,
                    selectedDay.month,
                    selectedDay.day,
                  ).toIso8601String(),

                  'time':
                      selectedTime
                          ?.format(
                    context,
                  ),
                });

                /// HISTORY
                await supabase
                    .from('history')
                    .insert({
                  'user_id':
                      user.id,

                  'title':
                      titleController
                          .text
                          .trim(),

                  'description':
                      'Agenda baru ditambahkan',

                  'type':
                      'note',
                });

                await loadTasks();

                Navigator.pop(
                  ctx,
                );
              },

              child: const Text(
                "Simpan",
              ),
            )
          ],
        ),
      ),
    );
  }

  /// DELETE TASK
  void _deleteTask(String id) {
    showDialog(
      context: context,

      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(24),
        ),

        title: const Text("Hapus"),

        content: const Text(
          "Yakin mau hapus agenda ini?",
        ),

        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(ctx),

            child: const Text(
              "Batal",
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              await supabase
                  .from('task')
                  .delete()
                  .eq('id', id);

              await loadTasks();

              Navigator.pop(ctx);
            },

            child: const Text(
              "Hapus",
            ),
          )
        ],
      ),
    );
  }

  /// TASK CARD
  Widget _taskCard(Map task) {
    final isDone =
        task['is_done'] ?? false;

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border(
          left: BorderSide(
            color: isDone
                ? Colors.green
                : Colors.deepPurple,

            width: 5,
          ),
        ),

        boxShadow: [
          BoxShadow(
            blurRadius: 10,

            color: Colors.black
                .withOpacity(0.05),

            offset: const Offset(
              0,
              4,
            ),
          )
        ],
      ),

      child: Row(
        children: [
          Checkbox(
            value: isDone,

            activeColor:
                Colors.deepPurple,

            onChanged: (val) async {
              await supabase
                  .from('task')
                  .update({
                    'is_done':
                        val ?? false,
                  })
                  .eq(
                    'id',
                    task['id'],
                  );

              if (val == true) {
                await supabase
                    .from('history')
                    .insert({
                  'user_id': supabase
                      .auth
                      .currentUser!
                      .id,

                  'title':
                      task['title'],

                  'description':
                      'Agenda selesai',

                  'type':
                      'done_task',
                });
              }

              await loadTasks();
            },
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  task['title'],

                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,

                    fontSize: 16,

                    decoration: isDone
                        ? TextDecoration
                            .lineThrough
                        : null,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                if (task['description'] !=
                        null &&
                    task['description'] !=
                        '')
                  Text(
                    task['description'],

                    style: TextStyle(
                      color:
                          Colors.grey[600],

                      decoration: isDone
                          ? TextDecoration
                              .lineThrough
                          : null,
                    ),
                  ),

                const SizedBox(
                  height: 10,
                ),

                if (task['time'] != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color:
                            Colors.deepPurple,
                      ),

                      const SizedBox(
                        width: 5,
                      ),

                      Text(
                        task['time'],
                      ),
                    ],
                  ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),

            onPressed: () =>
                _deleteTask(
              task['id'],
            ),
          )
        ],
      ),
    );
  }

  /// NOTE CARD
  Widget _noteCard(Map note) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: const Border(
          left: BorderSide(
            color: Colors.orange,
            width: 5,
          ),
        ),

        boxShadow: [
          BoxShadow(
            blurRadius: 10,

            color: Colors.black
                .withOpacity(0.05),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              const Icon(
                Icons.sticky_note_2,
                color: Colors.orange,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  note['title'] ?? '',

                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            note['content'] ?? '',

            maxLines: 2,

            overflow:
                TextOverflow.ellipsis,

            style: TextStyle(
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = todayTasks;
    final notes = todayNotes;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F4FB),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: _addTask,

        backgroundColor:
            Colors.deepPurple,

        icon: const Icon(Icons.add),

        label: const Text(
          "Tambah",
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              /// GREETING
              Text(
                "$greeting, $userName 👋",

                style: const TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "Semangat menjalani harimu ✨",

                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 20),

              /// CALENDAR
              Container(
                padding:
                    const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    22,
                  ),

                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,

                      color: Colors.black
                          .withOpacity(
                        0.04,
                      ),
                    )
                  ],
                ),

                child: TableCalendar(
                  focusedDay: focusedDay,

                  firstDay:
                      DateTime(2020),

                  lastDay:
                      DateTime(2030),

                  calendarFormat:
                      CalendarFormat.week,

                  selectedDayPredicate:
                      (day) => isSameDay(
                            day,
                            selectedDay,
                          ),

                  onDaySelected:
                      (day, focus) {
                    setState(() {
                      selectedDay = day;
                      focusedDay = focus;
                    });
                  },

                  headerStyle:
                      const HeaderStyle(
                    formatButtonVisible:
                        false,

                    titleCentered: true,
                  ),

                  calendarStyle:
                      CalendarStyle(
                    todayDecoration:
                        BoxDecoration(
                      color: Colors
                          .deepPurple
                          .shade200,

                      shape:
                          BoxShape.circle,
                    ),

                    selectedDecoration:
                        const BoxDecoration(
                      color:
                          Colors.deepPurple,

                      shape:
                          BoxShape.circle,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [
                    /// AGENDA
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        Text(
                           "Agenda $dayLabel",

                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "${tasks.length} agenda",

                          style: TextStyle(
                            color:
                                Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    if (tasks.isEmpty)
                      Container(
                        padding:
                            const EdgeInsets
                                .all(20),

                        decoration:
                            BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            20,
                          ),
                        ),

                        child: Column(
                          children: [
                            Icon(
                              Icons.event_note,
                              size: 60,
                              color: Colors
                                  .grey[400],
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            const Text(
                              "Belum ada agenda",
                            ),
                          ],
                        ),
                      ),

                    if (tasks.isNotEmpty)
                      ...tasks.map(
                        (task) =>
                            _taskCard(task),
                      ),

                    const SizedBox(
                      height: 24,
                    ),

                    /// NOTES
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        Text(
                           "Catatan $dayLabel",
                           
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "${notes.length} catatan",

                          style: TextStyle(
                            color:
                                Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    if (notes.isEmpty)
                      Container(
                        padding:
                            const EdgeInsets
                                .all(20),

                        decoration:
                            BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            20,
                          ),
                        ),

                        child: Column(
                          children: [
                            Icon(
                              Icons.note_alt,
                              size: 60,
                              color: Colors
                                  .grey[400],
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            const Text(
                              "Belum ada catatan",
                            ),
                          ],
                        ),
                      ),

                    if (notes.isNotEmpty)
                      ...notes.map(
                        (note) =>
                            _noteCard(note),
                      ),

                    const SizedBox(
                      height: 100,
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
}