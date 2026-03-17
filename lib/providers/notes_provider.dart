import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/services/notes_service.dart';

final notesServiceProvider = Provider(
  (ref) => NotesService(),
);

class NotesProvider extends AsyncNotifier<List<NoteModel>> {
  @override
  Future<List<NoteModel>> build() async {
    return await ref.read(notesServiceProvider).getNotes();
  }

  Future<void> addNote(
    String title,
    String description,
    String? imageUrl,
  ) async {
    await ref.read(notesServiceProvider).addNote(title, description, imageUrl);
  }

  Future<void> editNote(
    String id,
    String? newTitle,
    String? newDescription,
    String? newImageUrl,
  ) async {
    await ref
        .read(notesServiceProvider)
        .editNote(id, newTitle, newDescription, newImageUrl);
  }

  Future<void> deleteNote(String id) async {
    await ref.read(notesServiceProvider).deleteNote(id);
  }

  Future<String?> uploadImage(File imageFile) async {
    return await ref.read(notesProvider.notifier).uploadImage(imageFile);
  }
}

final notesProvider = AsyncNotifierProvider<NotesProvider, List<NoteModel>>(
  () => NotesProvider(),
);
