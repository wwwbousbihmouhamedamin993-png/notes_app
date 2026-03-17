import 'dart:io';

import 'package:notes_app/models/note_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesService {
  final supabase = Supabase.instance.client;
  String get userId => Supabase.instance.client.auth.currentUser!.id;
  Future<void> addNote(
    String title,
    String description,
    String? imageUrl,
  ) async {
    await supabase.from('NOTES').insert({
      'title': title,
      'description': description.isEmpty ? null : description,
      'user_id': userId,
      'image_url': imageUrl,
    });
  }

  Future<void> editNote(
    String id,
    String? newTitle,
    String? newDescription,
    String? imageUrl,
  ) async {
    await supabase
        .from('NOTES')
        .update({
          'title': newTitle,
          'description': newDescription,
          'image_url': imageUrl,
        })
        .eq('id', id);
  }

  Future<void> deleteNote(String id) async {
    await supabase.from('NOTES').delete().eq('id', id);
  }

  Future<List<NoteModel>> getNotes() async {
    final response = await supabase
        .from('NOTES')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return response.map((e) => NoteModel.fromJson(e)).toList();
  }

  Future<String?> uploadImage(File imageFile) async {
    final fileName =
        '${NotesService().userId}_${DateTime.now().microsecondsSinceEpoch}.jpg';
    await supabase.storage.from('NOTE_IMAGES1').upload(fileName, imageFile);
    return supabase.storage.from('NOTE_IMAGES1').getPublicUrl(fileName);
  }
}
