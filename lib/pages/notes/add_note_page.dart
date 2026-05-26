import 'package:flutter/material.dart';
import 'package:sora/services/note_service.dart';

class AddNotePage extends StatefulWidget {
  final Map<String, dynamic>? note;

  const AddNotePage({
    super.key,
    this.note,
  });

  @override
  State<AddNotePage> createState() =>
      _AddNotePageState();
}

class _AddNotePageState
    extends State<AddNotePage> {
  final noteService = NoteService();

  final titleController =
      TextEditingController();

  final contentController =
      TextEditingController();

  bool get isEdit =>
      widget.note != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      titleController.text =
          widget.note!['title'] ?? '';

      contentController.text =
          widget.note!['content'] ?? '';
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  /// SAVE NOTE
  Future<void> saveNote() async {
    final title =
        titleController.text.trim();

    final content =
        contentController.text.trim();

    if (title.isEmpty ||
        content.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Isi semua field"),
        ),
      );

      return;
    }

    try {
      /// EDIT NOTE
      if (isEdit) {
        await noteService.updateNote(
          id:
              widget.note!['id']
                  .toString(),

          title: title,
          content: content,
        );
      }

      /// ADD NOTE
      else {
        await noteService.addNote(
          title: title,
          content: content,
        );
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
          ),
        ),
      );
    }
  }

  /// DELETE NOTE
  Future<void> deleteNote() async {
    final confirm =
        await showDialog(
      context: context,

      builder: (context) =>
          AlertDialog(
        title: const Text(
          "Hapus Catatan",
        ),

        content: const Text(
          "Yakin mau hapus catatan ini?",
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                false,
              );
            },

            child: const Text(
              "Batal",
            ),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                true,
              );
            },

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.red,
            ),

            child: const Text(
              "Hapus",
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await noteService.deleteNote(
        widget.note!['id']
            .toString(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xfff5f5f5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          isEdit
              ? "Edit Catatan"
              : "Tambah Catatan",

          style: const TextStyle(
            color: Colors.black,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            /// TITLE
            const Text(
              "Judul",

              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller:
                  titleController,

              decoration:
                  InputDecoration(
                hintText:
                    "Masukkan judul",

                filled: true,
                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(16),

                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// CONTENT
            const Text(
              "Isi Catatan",

              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller:
                  contentController,

              maxLines: 8,

              decoration:
                  InputDecoration(
                hintText:
                    "Tulis sesuatu...",

                filled: true,
                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(16),

                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// SAVE / UPDATE BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: saveNote,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.deepPurple,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(16),
                  ),
                ),

                child: Text(
                  isEdit
                      ? "Update"
                      : "Simpan",

                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            /// DELETE BUTTON
            if (isEdit) ...[
              const SizedBox(
                height: 12,
              ),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed:
                      deleteNote,

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        16,
                      ),
                    ),
                  ),

                  child: const Text(
                    "Hapus Catatan",

                    style: TextStyle(
                      color:
                          Colors.white,
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}