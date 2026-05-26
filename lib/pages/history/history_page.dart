import 'package:flutter/material.dart';
import 'package:sora/services/note_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() =>
      _HistoryPageState();
}

class _HistoryPageState
    extends State<HistoryPage> {

  final noteService = NoteService();

  List<Map<String, dynamic>> notes = [];

  bool isLoading = true;

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xfff5f5f5),

      appBar: AppBar(
        backgroundColor:
            Colors.white,

        elevation: 0,

        title: const Text(
          "Riwayat",

          style: TextStyle(
            color: Colors.black,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : notes.isEmpty

              ? const Center(
                  child: Text(
                    "Belum ada riwayat",
                  ),
                )

              : ListView.builder(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),

                  itemCount:
                      notes.length,

                  itemBuilder:
                      (context, index) {

                    final note =
                        notes[index];

                    return Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 16,
                      ),

                      padding:
                          const EdgeInsets.all(
                        16,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius
                                .circular(20),

                        boxShadow: [
                          BoxShadow(
                            color: Colors
                                .black
                                .withOpacity(
                              0.05,
                            ),

                            blurRadius: 10,
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Text(
                            note['title'] ?? '',

                            style:
                                const TextStyle(
                              fontSize: 18,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            note['content'] ?? '',

                            style: TextStyle(
                              color: Colors
                                  .grey
                                  .shade700,

                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}