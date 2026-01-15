import 'package:dnd_app/features/character/presentation/bloc/character_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestMenuButton extends StatelessWidget {
  const RestMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.nights_stay), // Icono de Luna/Descanso
      tooltip: "Descansar",
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (String value) => _handleRest(context, value),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        // OPCIÓN 1: DESCANSO CORTO
        const PopupMenuItem<String>(
          value: 'short',
          child: Row(
            children: <Widget>[
              Icon(Icons.coffee, color: Colors.orange, size: 20),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Descanso Corto",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "1 Hora - Recursos de Clase",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        // OPCIÓN 2: DESCANSO LARGO
        const PopupMenuItem<String>(
          value: 'long',
          child: Row(
            children: <Widget>[
              Icon(Icons.bed, color: Colors.indigo, size: 20),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Descanso Largo",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "8 Horas - Restablece TODO",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleRest(BuildContext context, String type) {
    if (type == 'short') {
      // 1. Ejecutar Lógica
      context.read<CharacterBloc>().add(const PerformShortRestEvent());

      // 2. Feedback Visual (Opcional)
      // ScreenEffects.showMagicBlast(context, Colors.orange);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("☕ Te tomas un respiro. Has recuperado tus recursos."),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    } else if (type == 'long') {
      // 1. Confirmación para no darle sin querer
      showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
          title: const Text("¿Dormir 8 horas?"),
          content: const Text(
            "Esto restablecerá tu vida, magia y recursos al máximo.",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancelar"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                // Ejecutar descanso
                context.read<CharacterBloc>().add(const PerformLongRestEvent());

                // Feedback
                // ScreenEffects.showMagicBlast(context, Colors.indigo);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "💤 Has dormido plácidamente. Todo restablecido.",
                    ),
                    backgroundColor: Colors.indigo,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text("Dormir"),
            ),
          ],
        ),
      );
    }
  }
}
