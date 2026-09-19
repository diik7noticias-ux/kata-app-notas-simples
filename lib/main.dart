import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hive_flutter/hive_flutter.dart";
import "theme.dart";
import "screens/home_screen.dart";
import "screens/note_screen.dart";
import "services/note_service.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await NoteService.init();
  runApp(const KataApp());
}

class KataApp extends StatelessWidget {
  const KataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Notas Simples",
      debugShowCheckedModeBanner: false,
      theme: buildKataTheme(),
      routerConfig: _buildRouter(),
    );
  }

  GoRouter _buildRouter() {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/note',
          builder: (context, state) => const NoteScreen(),
        ),
        GoRoute(
          path: '/edit_note/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'];
            if (id != null) {
              final notes = NoteService.getAllNotes();
              final note = notes.firstWhere((note) => note.id == id, orElse: () => Note(id: '', title: '', content: '', createdAt: DateTime.now(), category: 'geral'));
              return NoteScreen(note: note);
            }
            return const NoteScreen();
          },
        )
      ],
    );
  }
}