import 'package:supabase_flutter/supabase_flutter.dart';

class NotesService {
  final supabase = Supabase.instance.client;
  String get userId => Supabase.instance.client.auth.currentUser!.id;
  Future<void> addNote(
    String title,
    String description,
  ) async {
    await supabase.from('NOTES').insert({
      'title': title,
      'description': description.isEmpty ? null : description,
      'user_id': userId,
    });
  }

  Future<void> editNote(
    String id,
    String? newTitle,
    String? newDescription,
  ) async {
    await supabase
        .from('NOTES')
        .update({'title': newTitle, 'description': newDescription})
        .eq('id', id);
  }

  Future<void> deleteNote(String id) async {
    await supabase.from('NOTES').delete().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final response = await supabase
        .from('NOTES')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return response;
  }
}
