import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/material.dart';
import 'package:notepad/data.dart';
import 'package:notepad/utils.dart';
import 'package:notepad/widgets.dart';

/// Step 7: Remove invalid navigation state
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
        selectedIndex: selectedIndex,
        onNoteSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
          if (!bothPanes) {
            Navigator.of(context).push(
              SingleScreenExclusiveRoute(
                builder: (context) => NoteEditor(noteIndex: index),
              ),
            );
          }
        },
      ),
      endPane: selectedIndex == null
          ? const EmptyState()
          : NoteEditor(noteIndex: selectedIndex!),
      panePriority: bothPanes ? TwoPanePriority.both : TwoPanePriority.start,
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Select a note from the list or create a new one'),
      ),
    );
  }
}

class NoteList extends StatelessWidget {
  final ValueChanged<int> onNoteSelected;
  final int? selectedIndex;

  const NoteList({
    Key? key,
    this.selectedIndex,
    required this.onNoteSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Note> notes = NoteData.of(context).notes;
    bool dualScreen = displayHasHinge(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notepad'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (_, index) => NotesListItem(
          note: notes[index],
          selected: dualScreen && index == selectedIndex,
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

/// Route that auto-removes itself if the app spanned horizontally.
class SingleScreenExclusiveRoute<T> extends MaterialPageRoute<T> {
  SingleScreenExclusiveRoute({
    required WidgetBuilder builder,
  }) : super(builder: builder);

  @override
  Widget buildContent(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (displayHasHinge(context)) {
        navigator?.removeRoute(this);
      }
    });
    return super.buildContent(context);
  }
}