import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/material.dart';
import 'package:notepad/data.dart';
import 'package:notepad/utils.dart';
import 'package:notepad/widgets.dart';

/// Step 4: Replace navigation with a selected state
class NoteNavigation extends StatefulWidget {
  const NoteNavigation({Key? key}) : super(key: key);

  @override
  State<NoteNavigation> createState() => _NoteNavigationState();
}

class _NoteNavigationState extends State<NoteNavigation> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    bool bothPanes = displayHasHinge(context);
    return TwoPane(
      startPane: NoteList(
        onNoteSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
          if (!bothPanes) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NoteEditor(noteIndex: index),
              ),
            );
          }
        },
      ),
      endPane: NoteEditor(
        noteIndex: selectedIndex ?? 0,
      ),
      panePriority: bothPanes ? TwoPanePriority.both : TwoPanePriority.start,
    );
  }
}

class NoteList extends StatelessWidget {
  final ValueChanged<int> onNoteSelected;

  const NoteList({Key? key, required this.onNoteSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Note> notes = NoteData.of(context).notes;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notepad'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (_, index) => NotesListItem(
          note: notes[index],
          onTap: () {
            onNoteSelected(index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int index = NoteData.of(context).addNote(
            Note('', ''),
          );
          onNoteSelected(index);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteEditor extends StatelessWidget {
  final int noteIndex;

  const NoteEditor({Key? key, required this.noteIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Note note = NoteData.of(context).getNote(noteIndex);
    return Scaffold(
      key: ValueKey('editor-$noteIndex'),
      appBar: AppBar(
        title: const Text('Edit note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NoteFormField(
              icon: const Icon(Icons.title),
              label: const Text('Title'),
              initialValue: note.title,
              onChanged: (String? value) {
                NoteData.of(context)
                    .updateNote(noteIndex, note.copyWith(title: value ?? ''));
              },
            ),
            Flexible(
              child: NoteFormField(
                icon: const Icon(Icons.text_snippet),
                label: const Text('Note content'),
                initialValue: note.body,
                maxLines: 10,
                onChanged: (String? value) {
                  NoteData.of(context)
                      .updateNote(noteIndex, note.copyWith(body: value ?? ''));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
