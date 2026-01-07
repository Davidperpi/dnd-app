import 'package:flutter/material.dart';

import 'app/theme/app_theme.dart';
import 'features/character/presentation/pages/character_page.dart';
import 'injection_container.dart' as di; // Importamos el inyector

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necesario para Async
  await di.init(); // Inicializamos dependencias
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const CharacterPage(),
    );
  }
}
