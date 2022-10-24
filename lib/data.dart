import 'package:flutter/widgets.dart';

/// Our initial data
List<Note> initialNotes = [
  Note('Flutter Vikings',
      'I hope you are having fun at the conference.\nUse the chat to say hi!'),
  Note('Display Features',
      'Display features are rectangles on your screen. They have a type, which tells you how they behave.'),
  Note('MediaQuery.displayFeatures',
      'MediaQuery contains a list of display features. You can use them directly but you can also rely on higher level widgets like TwoPane instead.'),
  Note('TwoPane widget',
      'TwoPane helps with large screen form factors like tablets and desktop. It also automatically snaps to the hinge on dual-screen devices.'),
];

/// A note has a title and a body.
class Note {
  final String title;
  final String body;

  Note(this.title, this.body);

  Note copyWith({String? title, String? body}){
    return Note(
      title ?? this.title,
      body ?? this.body,
    );
  }
}

/// Inherited Widget setup for propagating state across the app.
class NoteData extends StatefulWidget {
  final Widget child;

  const NoteData({Key? key, required this.child}) : super(key: key);

  static NoteDataInheritedWidget of(BuildContext context) {
    final NoteDataInheritedWidget? result =
        context.dependOnInheritedWidgetOfExactType<NoteDataInheritedWidget>();
    assert(result != null, 'No NoteData found in context');
    return result!;
  }

  @override
  _NoteDataState createState() => _NoteDataState();
}

class _NoteDataState extends State<NoteData> {
  List<Note> notes = initialNotes;

  @override
  Widget build(BuildContext context) {
    return NoteDataInheritedWidget(
      notes: notes,
      onNotesChanged: (updatedNotes) {
        setState(() {
          notes = updatedNotes;
        });
      },
      child: widget.child,
    );
  }
}

class NoteDataInheritedWidget extends InheritedWidget {
  final List<Note> notes;
  final ValueSetter<List<Note>> _onNotesChanged;

  const NoteDataInheritedWidget({
    Key? key,
    required this.notes,
    required ValueSetter<List<Note>> onNotesChanged,
    required Widget child,
  })  : _onNotesChanged = onNotesChanged,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(NoteDataInheritedWidget old) {
    return notes != old.notes;
  }

  // C R U D

  int addNote(Note note){
    _onNotesChanged(List.of(notes)..add(note));
    return notes.length;
  }

  Note getNote(int index){
    return notes[index];
  }

  void updateNote(int index, Note note){
    _onNotesChanged(List.of(notes)..[index] = note);
  }

  void deleteNote(int index){
    _onNotesChanged(List.of(notes)..removeAt(index));
  }

  void replaceNotes(List<Note> updatedNotes) {
    _onNotesChanged(List.of(updatedNotes));
  }
}
