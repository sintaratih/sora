import 'package:flutter/material.dart';
import 'package:sora/pages/notes/add_note_page.dart';
import 'package:sora/services/note_service.dart';

class NoteDetailPage extends StatelessWidget {

  final Map<String, dynamic> note;

  const NoteDetailPage({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xfff5f5f5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),

        actions: [

          IconButton(
            onPressed: () {},

            icon: const Icon(
              Icons.more_horiz,
              color: Colors.black,
            ),
          ),
        ],
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            /// CATEGORY
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),

              decoration:
                  BoxDecoration(
                color: Colors.deepPurple
                    .withOpacity(0.1),

                borderRadius:
                    BorderRadius.circular(
                  30,
                ),
              ),

              child: const Text(
                "Ide",

                style: TextStyle(
                  color:
                      Colors.deepPurple,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TITLE
            Text(
              note['title'] ?? '',

              style: const TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            /// DATE
            Text(
              "14 Mei 2026 • 10.30",

              style: TextStyle(
                color:
                    Colors.grey.shade600,

                fontSize: 14,
              ),
            ),

            const SizedBox(height: 30),

            /// CONTENT
            Text(
              note['content'] ?? '',

              style: TextStyle(
                fontSize: 16,

                color:
                    Colors.grey.shade800,

                height: 1.7,
              ),
            ),

            const Spacer(),

            /// BOTTOM ACTION
            Container(
              padding:
                  const EdgeInsets.symmetric(
                vertical: 18,
              ),

              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        Colors.grey.shade200,
                  ),
                ),
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceAround,

                children: [

                  /// EDIT
                  GestureDetector(
                    onTap: () async {

                      await Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              AddNotePage(
                            note: note,
                          ),
                        ),
                      );
                    },

                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min,

                      children: [

                        Icon(
                          Icons.edit_outlined,

                          color: Colors
                              .grey
                              .shade700,
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        Text(
                          "Edit",

                          style: TextStyle(
                            color: Colors
                                .grey
                                .shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// DELETE
                  GestureDetector(
                    onTap: () async {

                      await NoteService()
                          .deleteNote(
                        note['id']
                            .toString(),
                      );

                      if (context.mounted) {
                        Navigator.pop(
                          context,
                        );
                      }
                    },

                    child: const Column(
                      mainAxisSize:
                          MainAxisSize.min,

                      children: [

                        Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),

                        SizedBox(height: 6),

                        Text(
                          "Hapus",

                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}