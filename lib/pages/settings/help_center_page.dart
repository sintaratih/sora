import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
        Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F0FF),

      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDark
              ? Colors.white
              : Colors.black,
        ),
        title: Text(
          "Pusat Bantuan",
          style: TextStyle(
            color: isDark
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            _sectionTitle(
              "Pertanyaan Umum",
              isDark,
            ),

            const SizedBox(height: 12),

            _faqTile(
              isDark,
              "Bagaimana cara membuat catatan?",
              "Buka menu Notes lalu tekan tombol tambah (+) untuk membuat catatan baru.",
            ),

            _faqTile(
              isDark,
              "Bagaimana cara mengedit catatan?",
              "Buka detail catatan lalu tekan tombol Edit di bagian bawah.",
            ),

            _faqTile(
              isDark,
              "Bagaimana cara menghapus catatan?",
              "Buka detail catatan lalu tekan tombol Hapus. Akan muncul konfirmasi sebelum catatan dihapus.",
            ),

            _faqTile(
              isDark,
              "Bagaimana cara mengaktifkan Dark Mode?",
              "Masuk ke halaman Settings lalu aktifkan tombol Dark Mode.",
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(
    String title,
    bool isDark,
  ) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDark
            ? Colors.white
            : Colors.black,
      ),
    );
  }

  Widget _faqTile(
    bool isDark,
    String question,
    String answer,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E1E1E)
            : Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),

      child: ExpansionTile(
        iconColor: Colors.deepPurple,
        collapsedIconColor:
            Colors.deepPurple,

        title: Text(
          question,
          style: TextStyle(
            fontWeight:
                FontWeight.w600,
            color: isDark
                ? Colors.white
                : Colors.black,
          ),
        ),

        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              0,
              16,
              16,
            ),

            child: Text(
              answer,
              style: TextStyle(
                color: isDark
                    ? Colors.white70
                    : Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}