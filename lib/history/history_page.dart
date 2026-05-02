import 'package:flutter/material.dart';
import '../../services/note_service.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final allNotes = NoteService.notes;

    // flatten semua notes jadi list
    final entries = allNotes.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat"),
        centerTitle: true,
      ),

      body: entries.isEmpty
          ? const Center(child: Text("Belum ada riwayat"))
          : ListView(
              children: entries.map((entry) {
                final date = entry.key;
                final notes = entry.value;

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${date.day}/${date.month}/${date.year}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),

                        ...notes.map((note) => Text("• $note")),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}