import "package:flutter/material.dart";
import "note_screen.dart";
import "../models/note_model.dart";
import "../services/note_service.dart";
import "../widgets/note_list_item.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];
  final List<String> _categories = ['geral', 'trabalho', 'estudo', 'frutas'];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = NoteService.getAllNotes();
    setState(() {
      _notes = notes;
    });
  }

  void _addNote() {
    Navigator.pushNamed(context, '/note').then((_) => _loadNotes());
  }

  void _deleteNote(String noteId) {
    NoteService.deleteNote(noteId).then((_) => _loadNotes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notas Simples"),
        actions: [
          PopupMenuButton<String>( 
            onSelected: (category) {
              setState(() {
                // Implementar lógica para filtrar notas por categoria
              });
            }, 
            itemBuilder: (BuildContext context) {
              return _categories.map((String category) {
                return PopupMenuItem<String>( 
                  value: category,
                  child: Text(category.capitalize()),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.note_add, size: 64, color: Color(0xFF1BB9BE)),
            const SizedBox(height: 16),
            const Text(
              "Adicione suas notas",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Clique no botão abaixo para criar uma nota",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: NoteListItem(
                      note: note,
                      onDelete: () => _deleteNote(note.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}