import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/providers/auth_provider.dart';
import 'package:notes_app/providers/notes_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('logout'),
                onTap: () async {
                  await ref.read(authProvider.notifier).signOut();
                },
              ),
            ],
          ),
        ],
      ),
      body: notes.when(
        error: (error, stackTrace) => Text('error $error'),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        data: (notesList) {
          return notesList.isEmpty
              ? const Center(child: Text('No notes yet'))
              : ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    final note = notesList[index];
                    return ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _showEditSheet(context, ref, note),
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () async {
                              await ref
                                  .read(notesProvider.notifier)
                                  .deleteNote(note.id);
                              ref.invalidate(notesProvider);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSheet(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditSheet(
    BuildContext context,
    WidgetRef ref,
    NoteModel note,
  ) {
    final titleC = TextEditingController(text: note.title);
    final descC = TextEditingController(text: note.description);
    XFile? selectedImage;

    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleC,
              decoration: InputDecoration(hintText: 'note title'),
            ),
            TextField(
              controller: descC,
              decoration: InputDecoration(hintText: 'note description'),
            ),
            TextButton(
              onPressed: () async {
                final image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  setSheetState(() {
                    selectedImage = image;
                  });
                }
              },
              child: Text(
                selectedImage == null ? 'Pick Image' : 'Image Selected ✅',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleC.text.isEmpty || descC.text.isEmpty) return;

                String? imageUrl;
                if (selectedImage != null) {
                  imageUrl = await ref
                      .read(notesProvider.notifier)
                      .uploadImage(File(selectedImage!.path));
                }

                await ref
                    .read(notesProvider.notifier)
                    .editNote(note.id, titleC.text, descC.text, imageUrl);

                if (!context.mounted) return;
                context.pop();
                ref.invalidate(notesProvider);
              },
              child: const Text('update note'),
            ),
          ],
        ),
      ),
    );
  }
}

void _showAddSheet(BuildContext context, WidgetRef ref) {
  final titleC = TextEditingController();
  final descC = TextEditingController();
  XFile? selectedImage;

  showModalBottomSheet(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setSheetState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleC,
              decoration: InputDecoration(hintText: 'note title'),
            ),
            TextField(
              controller: descC,
              decoration: InputDecoration(hintText: 'note description'),
            ),
            TextButton(
              onPressed: () async {
                final image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  setSheetState(
                    () {
                      selectedImage = image;
                    },
                  );
                }
              },
              child: selectedImage == null
                  ? Text('enter an image ')
                  : Text('image picked !'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleC.text.isEmpty) return;
                final title = titleC.text;
                final description = descC.text;
                if (!context.mounted) return;
                String? imageUrl;
                if (selectedImage != null) {
                  imageUrl = await ref
                      .read(notesProvider.notifier)
                      .uploadImage(File(selectedImage!.path));
                }
                await ref
                    .read(notesProvider.notifier)
                    .addNote(title, description, imageUrl);
                if (!context.mounted) {
                  return;
                }
                context.pop();
                ref.invalidate(notesProvider);
              },
              child: const Text('add note'),
            ),
          ],
        );
      },
    ),
  );
}
