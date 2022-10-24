import 'package:flutter/material.dart';
import 'package:notepad/data.dart';

/// A form field that looks like a card.
class NoteFormField extends StatelessWidget {
  const NoteFormField({
    Key? key,
    required this.icon,
    required this.label,
    required this.initialValue,
    this.maxLines,
    required this.onChanged,
  }) : super(key: key);

  final Icon icon;
  final Text label;
  final String initialValue;
  final int? maxLines;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: InputDecoration(
            icon: icon,
            label: label,
            border: InputBorder.none,
            alignLabelWithHint: true,
          ),
          initialValue: initialValue,
          maxLines: maxLines,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// A list item that shows only the title of a note.
class NotesListItem extends StatelessWidget {
  final Note note;
  final bool selected;
  final VoidCallback onTap;

  const NotesListItem({
    Key? key,
    required this.note,
    this.selected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected ? Colors.blue[100] : null,
      child: ListTile(
        title: Text(note.title),
        onTap: onTap,
      ),
    );
  }
}
