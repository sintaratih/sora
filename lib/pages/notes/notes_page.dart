import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sora/pages/notes/add_note_page.dart';
import 'package:sora/pages/notes/note_detail_page.dart';
import 'package:sora/services/note_service.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() =>
      _NotesPageState();
}

class _NotesPageState
    extends State<NotesPage> {

  final noteService = NoteService();

  List<Map<String, dynamic>> notes = [];

  bool isLoading = true;

  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  /// GET NOTES
  Future<void> fetchNotes() async {

    try {

      final data =
          await noteService.getNotes();

      setState(() {
        notes = data;
        isLoading = false;
      });

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text("Error: $e"),
        ),
      );
    }
  }

  /// FILTER NOTES
  List<Map<String, dynamic>> get filteredNotes {

    return notes.where((note) {

      final rawDate =
          note['created_at']
              ?.toString();

      if (rawDate == null) {
        return false;
      }

      final d =
          DateTime.tryParse(
        rawDate,
      );

      if (d == null) {
        return false;
      }

      return d.year ==
              selectedDay.year &&
          d.month ==
              selectedDay.month &&
          d.day ==
              selectedDay.day;

    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    final todayNotes =
        filteredNotes;

    return Scaffold(
      backgroundColor:
          const Color(
        0xFFF7F4FB,
      ),

      appBar: AppBar(
        backgroundColor:
            const Color(
          0xFFF7F4FB,
        ),

        elevation: 0,

        centerTitle: false,

        title: const Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,

          children: [

            Text(
              "Kalender Catatan",

              style: TextStyle(
                color: Colors.black,
                fontWeight:
                    FontWeight.bold,
                fontSize: 24,
              ),
            ),

            SizedBox(height: 4),

            Text(
              "Kelola semua catatanmu ✨",

              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : SafeArea(
              child:
                  SingleChildScrollView(

                child: Padding(
                  padding:
                      const EdgeInsets
                          .all(16),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      /// CALENDAR
                      Container(
                        padding:
                            const EdgeInsets
                                .all(12),

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            22,
                          ),

                          boxShadow: [
                            BoxShadow(
                              blurRadius:
                                  12,

                              color: Colors
                                  .black
                                  .withOpacity(
                                0.04,
                              ),
                            )
                          ],
                        ),

                        child:
                            TableCalendar(

                          focusedDay:
                              focusedDay,

                          firstDay:
                              DateTime(
                                  2020),

                          lastDay:
                              DateTime(
                                  2030),

                          calendarFormat:
                              CalendarFormat
                                  .month,

                          selectedDayPredicate:
                              (day) =>
                                  isSameDay(
                            day,
                            selectedDay,
                          ),

                          /// MARKER
                          eventLoader:
                              (day) {

                            return notes
                                .where(
                              (note) {

                                final rawDate =
                                    note['created_at']
                                        ?.toString();

                                if (rawDate ==
                                    null) {
                                  return false;
                                }

                                final d =
                                    DateTime.tryParse(
                                  rawDate,
                                );

                                if (d ==
                                    null) {
                                  return false;
                                }

                                return isSameDay(
                                  d,
                                  day,
                                );
                              },
                            ).toList();
                          },

                          onDaySelected:
                              (
                            day,
                            focus,
                          ) {

                            setState(() {
                              selectedDay =
                                  day;

                              focusedDay =
                                  focus;
                            });
                          },

                          headerStyle:
                              const HeaderStyle(

                            formatButtonVisible:
                                false,

                            titleCentered:
                                true,

                            leftChevronIcon:
                                Icon(
                              Icons
                                  .chevron_left,
                            ),

                            rightChevronIcon:
                                Icon(
                              Icons
                                  .chevron_right,
                            ),

                            titleTextStyle:
                                TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,

                              fontSize:
                                  16,
                            ),
                          ),

                          calendarStyle:
                              CalendarStyle(

                            outsideDaysVisible:
                                false,

                            todayDecoration:
                                BoxDecoration(
                              color: Colors
                                  .deepPurple
                                  .shade200,

                              shape:
                                  BoxShape
                                      .circle,
                            ),

                            selectedDecoration:
                                const BoxDecoration(
                              color: Colors
                                  .deepPurple,

                              shape:
                                  BoxShape
                                      .circle,
                            ),

                            markerDecoration:
                                const BoxDecoration(
                              color: Colors
                                  .orange,

                              shape:
                                  BoxShape
                                      .circle,
                            ),

                            todayTextStyle:
                                const TextStyle(
                              color: Colors
                                  .white,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),

                            selectedTextStyle:
                                const TextStyle(
                              color: Colors
                                  .white,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          daysOfWeekStyle:
                              DaysOfWeekStyle(

                            weekdayStyle:
                                TextStyle(
                              color: Colors
                                  .grey[600],

                              fontWeight:
                                  FontWeight
                                      .w500,
                            ),

                            weekendStyle:
                                const TextStyle(
                              color: Colors
                                  .redAccent,

                              fontWeight:
                                  FontWeight
                                      .w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      /// TITLE
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children: [

                          const Text(
                            "Catatan Hari Ini",

                            style:
                                TextStyle(
                              fontSize:
                                  18,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          Text(
                            "${todayNotes.length} catatan",

                            style:
                                const TextStyle(
                              color:
                                  Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      /// EMPTY
                      if (todayNotes
                          .isEmpty)

                        Center(
                          child: Column(
                            children: [

                              const SizedBox(
                                height:
                                    40,
                              ),

                              Icon(
                                Icons
                                    .sticky_note_2_outlined,

                                size: 80,

                                color: Colors
                                    .grey[400],
                              ),

                              const SizedBox(
                                height:
                                    14,
                              ),

                              const Text(
                                "Belum ada catatan",

                                style:
                                    TextStyle(
                                  fontSize:
                                      18,

                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                height:
                                    6,
                              ),

                              Text(
                                "Tambahkan catatan baru ✨",

                                style:
                                    TextStyle(
                                  color: Colors
                                      .grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                      /// NOTES
                      if (todayNotes
                          .isNotEmpty)

                        ListView.builder(

                          shrinkWrap:
                              true,

                          physics:
                              const NeverScrollableScrollPhysics(),

                          itemCount:
                              todayNotes
                                  .length,

                          itemBuilder:
                              (
                            context,
                            index,
                          ) {

                            final note =
                                todayNotes[
                                    index];

                            return GestureDetector(

                              onTap:
                                  () async {

                                await Navigator
                                    .push(
                                  context,

                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            NoteDetailPage(
                                      note:
                                          note,
                                    ),
                                  ),
                                );

                                fetchNotes();
                              },

                              child:
                                  Container(

                                margin:
                                    const EdgeInsets
                                        .only(
                                  bottom:
                                      16,
                                ),

                                padding:
                                    const EdgeInsets
                                        .all(
                                  16,
                                ),

                                decoration:
                                    BoxDecoration(

                                  color:
                                      Colors.white,

                                  borderRadius:
                                      BorderRadius.circular(
                                    20,
                                  ),

                                  border:
                                      const Border(
                                    left:
                                        BorderSide(
                                      color:
                                          Colors.deepPurple,

                                      width:
                                          5,
                                    ),
                                  ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors
                                          .black
                                          .withOpacity(
                                        0.05,
                                      ),

                                      blurRadius:
                                          10,
                                    ),
                                  ],
                                ),

                                child:
                                    Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,

                                      children: [

                                        Expanded(
                                          child:
                                              Text(
                                            note['title'] ??
                                                '',

                                            style:
                                                const TextStyle(
                                              fontSize:
                                                  18,

                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        const Icon(
                                          Icons
                                              .arrow_forward_ios,

                                          size:
                                              18,

                                          color:
                                              Colors.grey,
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height:
                                          10,
                                    ),

                                    Text(
                                      note['content'] ??
                                          '',

                                      maxLines:
                                          2,

                                      overflow:
                                          TextOverflow
                                              .ellipsis,

                                      style:
                                          TextStyle(
                                        color: Colors
                                            .grey
                                            .shade700,

                                        height:
                                            1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),

      floatingActionButton:
          FloatingActionButton(

        backgroundColor:
            Colors.deepPurple,

        onPressed: () async {

          await Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) =>
                  const AddNotePage(),
            ),
          );

          fetchNotes();
        },

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}