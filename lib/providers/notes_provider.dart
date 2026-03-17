import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/services/notes_service.dart';

final notesServiceProvider = Provider(
  (ref) => NotesService(),
);

class NotesProvider extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    return await ref.read(notesServiceProvider).getNotes();
  }

  Future<void> addNote(
    String title,
    String description,
  ) async {
    await ref.read(notesServiceProvider).addNote(title, description);
  }

  Future<void> editNote(
    String id,
    String? newTitle,
    String? newDescription,
  ) async {
    await ref.read(notesServiceProvider).editNote(id, newTitle, newDescription);
  }

  Future<void> deleteNote(String id) async {
    await ref.read(notesServiceProvider).deleteNote(id);
  }
}

final notesProvider =
    AsyncNotifierProvider<NotesProvider, List<Map<String, dynamic>>>(
      () => NotesProvider(),
    );
