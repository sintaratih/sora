import 'package:flutter/material.dart';
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
  List<Map<String, dynamic>>
      filteredNotes = [];

  bool isLoading = true;

  final searchController =
      TextEditingController();

  String selectedSort = "newest";

  @override
  void initState() {
    super.initState();

    fetchNotes();

    searchController.addListener(() {
      applyFilter();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// GET NOTES
  Future<void> fetchNotes() async {

    try {

      final data =
          await noteService.getNotes();

      notes =
          List<Map<String, dynamic>>
              .from(data);

      applyFilter();

      setState(() {
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

  /// SEARCH + SORT
  void applyFilter() {

    List<Map<String, dynamic>>
        result = List.from(notes);

    /// SEARCH
    final keyword =
        searchController.text
            .toLowerCase();

    if (keyword.isNotEmpty) {

      result = result.where((note) {

        final title =
            note['title']
                    ?.toString()
                    .toLowerCase() ??
                '';

        final content =
            note['content']
                    ?.toString()
                    .toLowerCase() ??
                '';

        return title.contains(keyword) ||
            content.contains(keyword);

      }).toList();
    }

    /// SORT
    if (selectedSort == "az") {

      result.sort((a, b) =>
          (a['title'] ?? '')
              .toString()
              .compareTo(
                (b['title'] ?? '')
                    .toString(),
              ));

    } else if (selectedSort ==
        "oldest") {

      result.sort((a, b) =>
          DateTime.parse(
            a['created_at'],
          ).compareTo(
            DateTime.parse(
              b['created_at'],
            ),
          ));

    } else {

      result.sort((a, b) =>
          DateTime.parse(
            b['created_at'],
          ).compareTo(
            DateTime.parse(
              a['created_at'],
            ),
          ));
    }

    setState(() {
      filteredNotes = result;
    });
  }

  /// NOTE CARD
  Widget noteCard(
      Map<String, dynamic> note) {

    return GestureDetector(

      onTap: () async {

        await Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) =>
                NoteDetailPage(
              note: note,
            ),
          ),
        );

        fetchNotes();
      },

      child: Container(
        margin:
            const EdgeInsets.only(
          bottom: 16,
        ),

        padding:
            const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            22,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.05),

              blurRadius: 10,
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(
              children: [

                Container(
                  padding:
                      const EdgeInsets
                          .all(10),

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.deepPurple
                            .withOpacity(
                      0.1,
                    ),

                    borderRadius:
                        BorderRadius
                            .circular(
                      14,
                    ),
                  ),

                  child: const Icon(
                    Icons.notes,
                    color:
                        Colors.deepPurple,
                  ),
                ),

                const SizedBox(
                  width: 14,
                ),

                Expanded(
                  child: Text(
                    note['title'] ?? '',

                    maxLines: 1,

                    overflow:
                        TextOverflow
                            .ellipsis,

                    style:
                        const TextStyle(
                      fontSize: 18,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                const Icon(
                  Icons
                      .arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              note['content'] ?? '',

              maxLines: 3,

              overflow:
                  TextOverflow.ellipsis,

              style: TextStyle(
                color:
                    Colors.grey.shade700,

                height: 1.5,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [

                Icon(
                  Icons.access_time,
                  size: 16,
                  color:
                      Colors.grey.shade500,
                ),

                const SizedBox(width: 6),

                Text(
                  note['created_at']
                      .toString()
                      .substring(
                        0,
                        16,
                      ),

                  style: TextStyle(
                    color:
                        Colors.grey.shade500,

                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(
        0xFFF7F4FB,
      ),

      body: SafeArea(

        child: isLoading

            ? const Center(
                child:
                    CircularProgressIndicator(),
              )

            : Column(
                children: [

                  const SizedBox(
                    height: 24,
                  ),

                  /// TITLE
                  const Center(
                    child: Text(
                      "Catatan",

                      style: TextStyle(
                        fontSize: 30,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  /// SEARCH + FILTER
                  Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                    ),

                    child: Row(
                      children: [

                        /// SEARCH
                        Expanded(
                          child: Container(
                            height: 55,

                            decoration:
                                BoxDecoration(
                              color:
                                  Colors
                                      .white,

                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),
                            ),

                            child: TextField(
                              controller:
                                  searchController,

                              decoration:
                                  InputDecoration(
                                hintText:
                                    "Cari catatan...",

                                prefixIcon:
                                    const Icon(
                                  Icons.search,
                                ),

                                border:
                                    InputBorder
                                        .none,

                                contentPadding:
                                    const EdgeInsets.symmetric(
                                  vertical:
                                      15,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        /// FILTER ICON
                        Container(
                          height: 55,
                          width: 55,

                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white,

                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),

                          child:
                              PopupMenuButton<
                                  String>(

                            icon: const Icon(
                              Icons.tune,
                              color:
                                  Colors.black,
                            ),

                            onSelected:
                                (value) {

                              setState(() {
                                selectedSort =
                                    value;
                              });

                              applyFilter();
                            },

                            itemBuilder:
                                (context) => [

                              const PopupMenuItem(
                                value:
                                    "newest",

                                child: Text(
                                  "Terbaru",
                                ),
                              ),

                              const PopupMenuItem(
                                value:
                                    "oldest",

                                child: Text(
                                  "Terlama",
                                ),
                              ),

                              const PopupMenuItem(
                                value: "az",

                                child: Text(
                                  "A-Z",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  /// TOTAL
                  Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 18,
                    ),

                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .end,

                      children: [

                        Text(
                          "${filteredNotes.length} catatan",

                          style: TextStyle(
                            color:
                                Colors.grey
                                    .shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  /// EMPTY
                  if (filteredNotes
                      .isEmpty)

                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,

                          children: [

                            Icon(
                              Icons
                                  .sticky_note_2_outlined,

                              size: 90,

                              color: Colors
                                  .grey[400],
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            const Text(
                              "Belum ada catatan",

                              style:
                                  TextStyle(
                                fontSize:
                                    20,

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
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
                    ),

                  /// NOTES
                  if (filteredNotes
                      .isNotEmpty)

                    Expanded(
                      child:
                          ListView.builder(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 16,
                        ),

                        itemCount:
                            filteredNotes
                                .length,

                        itemBuilder:
                            (
                          context,
                          index,
                        ) {

                          return noteCard(
                            filteredNotes[
                                index],
                          );
                        },
                      ),
                    ),
                ],
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