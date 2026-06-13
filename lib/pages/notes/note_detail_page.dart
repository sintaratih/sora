import 'package:flutter/material.dart';
import 'package:sora/pages/notes/add_note_page.dart';
import 'package:sora/services/note_service.dart';

class NoteDetailPage extends StatelessWidget {

  final Map<String, dynamic> note;

  const NoteDetailPage({
    super.key,required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
    Theme.of(context).brightness ==
    Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: Icon(
            Icons.arrow_back,
            color: isDark
                  ? Colors.white
                  : Colors.black,
          ),
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(
              note['title'] ?? '',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white
                    : Colors.black,
              ),
            ),

            const SizedBox(height: 12),

            /// DATE
            Text(
              "14 Mei 2026 • 10.30",
              style: TextStyle(
                color:Colors.grey.shade600,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 30),

            /// CONTENT
            Text(
              note['content'] ?? '',
              style: TextStyle(
                fontSize: 16,
                color: isDark
                    ? Colors.white
                    : Colors.black,
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
                   color: isDark
                      ? Colors.white12
                      : Colors.grey.shade200,
                  ),
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /// EDIT
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => AddNotePage( note: note,
                          ),
                        ),
                      );
                    },

                    child: Column(
                      mainAxisSize:MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_outlined,
                            color: isDark
                          ? Colors.white70
                          : Colors.grey.shade700,
                          ),

                        const SizedBox(height: 6,),

                        Text(
                          "Edit",
                          style: TextStyle(
                             color: isDark
                                    ? Colors.white70
                                    : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// DELETE
                  GestureDetector(
                    onTap: () async {
                      await NoteService().deleteNote(
                        note['id'] .toString(),
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