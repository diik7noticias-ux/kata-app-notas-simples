import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import '../models/note_model.dart';

class NoteService {
  static const String _notesBoxName = 'notes_box';
  static late Box<Note> _notesBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(NoteAdapter());
    _notesBox = await Hive.openBox<Note>(_notesBoxName);
  }

  static List<Note> getAllNotes() {
    return _notesBox.values.toList();
  }

  static Future<void> addNote(Note note) async {
    await _notesBox.add(note);
  }

  static Future<void> updateNote(Note note) async {
    final noteId = note.id;
    final existingNote = _notesBox.get(noteId);
    if (existingNote != null) {
      await _notesBox.put(noteId, note);
    }
  }

  static Future<void> deleteNote(String noteId) async {
    await _notesBox.delete(noteId);
  }

  static List<String> getCategories() {
    return ['geral', 'trabalho', 'estudo', 'frutas'];
  }
}