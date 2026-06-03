import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
        Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("About App"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 20),

            /// LOGO
            CircleAvatar(
              radius: 50,
              backgroundColor:
                  Colors.deepPurple.withOpacity(0.1),

              child: const Icon(
                Icons.auto_stories_rounded,
                size: 50,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 20),

            /// APP NAME
            const Text(
              "Sora",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Version 1.0.0",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: const [
                    Text(
                      "About Sora",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      "Sora adalah aplikasi pencatatan sederhana yang membantu pengguna menyimpan, mengelola, dan mengatur catatan sehari-hari dengan mudah dan cepat.",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: const Padding(
                padding: EdgeInsets.all(20),

                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text(
                        "Tambah Catatan",
                      ),
                    ),

                    ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Colors.orange,
                      ),
                      title: Text(
                        "Edit Catatan",
                      ),
                    ),

                    ListTile(
                      leading: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      title: Text(
                        "Hapus Catatan",
                      ),
                    ),

                    ListTile(
                      leading: Icon(
                        Icons.dark_mode,
                        color: Colors.deepPurple,
                      ),
                      title: Text(
                        "Dark Mode",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: const Padding(
                padding: EdgeInsets.all(20),

                child: Column(
                  children: [
                    Text(
                      "Developed By",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Sinta Ratih Puwandari",
                    ),

                    Text(
                      "Teknik Informatika",
                    ),

                    Text(
                      "Universitas Yudharta Pasuruan",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "© 2026 Sora App",
              style: TextStyle(
                color:
                    isDark
                        ? Colors.grey[400]
                        : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}