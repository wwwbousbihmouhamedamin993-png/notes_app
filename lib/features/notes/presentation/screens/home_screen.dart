import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/features/notes/domain/models/note_model.dart';
import 'package:notes_app/features/auth/application/auth_provider.dart';
import 'package:notes_app/features/notes/application/notes_provider.dart';

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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: notes.when(
          error: (error, stackTrace) => Center(
            key: Key('error'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error),
                SizedBox(
                  height: 5,
                ),
                Text('error ${error.toString()}'),
              ],
            ),
          ),
          loading: () => const Center(
            key: Key('loading'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 5,
                ),
                Text('loading ...'),
              ],
            ),
          ),
          data: (notesList) {
            return notesList.isEmpty
                ? Center(
                    key: Key('empty'),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.note_add),
                        SizedBox(
                          height: 5,
                        ),
                        Text('no notes yet , click + to add note'),
                      ],
                    ),
                  )
                : ListView.builder(
                    key: Key('has data'),
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
                              onPressed: () =>
                                  _showEditSheet(context, ref, note),
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
        builder: (context, setSheetState) => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleC,
                    decoration: InputDecoration(
                      hintText: 'note ttle',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
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
                    child: AnimatedOpacity(
                      opacity: selectedImage == null ? 0.1 : 1.0,
                      duration: Duration(milliseconds: 500),
                      child: Text(
                        selectedImage == null ? 'add image' : 'image uploaded!',
                      ),
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
          ),
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
    isScrollControlled: true,
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setSheetState) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleC,
                    decoration: InputDecoration(
                      hintText: 'note title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: descC,
                    decoration: InputDecoration(
                      hintText: 'note description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
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
                    child: AnimatedOpacity(
                      opacity: selectedImage == null ? 1 : 0.5,
                      duration: Duration(milliseconds: 500),
                      child: Text(
                        selectedImage == null ? 'add image' : 'image added !',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (titleC.text.isEmpty) return;
                      if (descC.text.isEmpty) return;
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
              ),
            ),
          ),
        );
      },
    ),
  );
}
