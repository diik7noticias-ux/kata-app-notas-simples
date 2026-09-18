import "package:flutter/material.dart";
import "theme.dart";
import "screens/home_screen.dart";
import "screens/note_screen.dart";

void main() {
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
      },
    );
  }
}