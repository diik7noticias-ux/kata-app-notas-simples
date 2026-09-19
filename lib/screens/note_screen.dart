import "package:flutter/material.dart";
import "package:uuid/uuid.dart";
import "../models/note_model.dart";
import "../services/note_service.dart";

class NoteScreen extends StatefulWidget {
  final Note? note;
  const NoteScreen({super.key, this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  final _uuid = const Uuid();
  bool _isEditing = false;
  String _selectedCategory = 'geral';

  final List<String> _categories = [
    'geral',
    'trabalho',
    'pessoal',
    'frutas',
  ];

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _contentController = TextEditingController(text: widget.note?.content ?? "");
    _isEditing = widget.note != null;
    _selectedCategory = widget.note?.category ?? 'geral';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final note = Note(
        id: widget.note?.id ?? _uuid.v4(),
        title: _titleController.text,
        content: _contentController.text,
        createdAt: DateTime.now(),
        category: _selectedCategory,
      );
      if (_isEditing) {
        await NoteService.updateNote(note);
      } else {
        await NoteService.addNote(note);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? "Nota atualizada com sucesso!" : "Nota salva com sucesso!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Editar Nota" : "Nova Nota"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Título",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira um título";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>( 
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Categoria",
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>( 
                    value: category,
                    child: Text(category.capitalize()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Por favor, selecione uma categoria";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: "Conteúdo",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}