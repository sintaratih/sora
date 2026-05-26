import 'package:supabase_flutter/supabase_flutter.dart';

class NoteService {
  final supabase = Supabase.instance.client;

  /// GET NOTES
  Future<List<Map<String, dynamic>>> getNotes() async {
    final response = await supabase
        .from('notes')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(
      response,
    );
  }

  /// ADD NOTE
  Future addNote({
    required String title,
    required String content,
  }) async {
    await supabase.from('notes').insert({
      'title': title,
      'content': content,
    });
  }

  /// DELETE NOTE
  Future deleteNote(String id) async {
    await supabase
        .from('notes')
        .delete()
        .eq('id', id);
  }
  /// UPDATE NOTE
Future updateNote({
  required String id,
  required String title,
  required String content,
}) async {
  await supabase
      .from('notes')
      .update({
        'title': title,
        'content': content,
      })
      .eq('id', id);
}
}