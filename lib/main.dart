import "package:flutter/material.dart";
import "theme.dart";
import "screens/home_screen.dart";
import "screens/note_screen.dart";
import "services/note_service.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteService.init();
  runApp(const KataApp());
}

class KataApp extends StatelessWidget {
  const KataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notas Simples",
      debugShowCheckedModeBanner: false,
      theme: buildKataTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/note': (context) => const NoteScreen(),
        '/edit_note/:id': (context) => NoteScreen(note: context.findRootAncestorStateOfType<_HomeScreenState>()?.widget.note),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/edit_note/:id') {
          final id = settings.pathParameters?['id'];
          if (id != null) {
            final notes = NoteService.getAllNotes();
            final note = notes.firstWhere((note) => note.id == id, orElse: () => Note(id: '', title: '', content: '', createdAt: DateTime.now()));
            return MaterialPageRoute(builder: (context) => NoteScreen(note: note));
          }
        }
        return null;
      },
    );
  }
}