import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
                      title: Text(note['title']),
                      subtitle: Text(note['description'] ?? ''),
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
                                  .deleteNote(note['id']);
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
    Map<String, dynamic> note,
  ) {
    final titleC = TextEditingController(text: note['title']);
    final descC = TextEditingController(text: note['description'] ?? '');
    if (titleC.text.isEmpty) return;
    if (descC.text.isEmpty) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
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
          ElevatedButton(
            onPressed: () async {
              if (titleC.text.isEmpty) return;
              if (descC.text.isEmpty) return;
              final title = titleC.text;
              final description = descC.text;
              if (!context.mounted) return;
              await ref
                  .read(notesProvider.notifier)
                  .editNote(note['id'], title, description);
              if (!context.mounted) {
                return;
              }
              context.pop();
              ref.invalidate(notesProvider);
            },
            child: const Text('update note'),
          ),
        ],
      ),
    );
  }
}

void _showAddSheet(BuildContext context, WidgetRef ref) {
  final titleC = TextEditingController();
  final descC = TextEditingController();

  showModalBottomSheet(
    context: context,
    builder: (context) => Column(
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
        ElevatedButton(
          onPressed: () async {
            if (titleC.text.isEmpty) return;
            if (descC.text.isEmpty) return;
            final title = titleC.text;
            final description = descC.text;
            if (!context.mounted) return;
            await ref.read(notesProvider.notifier).addNote(title, description);
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
  );
}
