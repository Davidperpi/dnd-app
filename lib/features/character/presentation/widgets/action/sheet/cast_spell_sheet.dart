import 'package:dnd_app/core/utils/screen_effects.dart'; // <--- Import del efecto
import 'package:dnd_app/features/character/domain/entities/character.dart';
import 'package:dnd_app/features/character/presentation/bloc/character_bloc.dart';
import 'package:dnd_app/features/spells/domain/entities/spell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CastSpellSheet extends StatelessWidget {
  final Spell spell;
  final CharacterBloc bloc;

  const CastSpellSheet({super.key, required this.spell, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CharacterBloc>.value(
      value: bloc,
      child: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (BuildContext context, CharacterState state) {
          if (state is! CharacterLoaded) return const SizedBox.shrink();
          final Character char = state.character;

          // LOGICA ACTUALIZADA:
          // 1. Obtenemos TODOS los niveles posibles (basado en MAX slots),
          //    no en los actuales. Así mostramos el botón aunque esté vacío.
          final List<int> possibleLevels =
              char.spellSlotsMax.keys
                  .where((int level) => level >= spell.level)
                  .toList()
                ..sort();

          // Check general para el texto de cabecera
          final bool canCastAtAll = possibleLevels.any(
            (int level) => (char.spellSlotsCurrent[level] ?? 0) > 0,
          );

          return Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Icon(
                  Icons.auto_fix_high,
                  size: 40,
                  color: Color(0xFFBA68C8),
                ),
                const SizedBox(height: 16),
                Text(
                  "Lanzar ${spell.name}",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFBA68C8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  canCastAtAll
                      ? "Selecciona el nivel del espacio de conjuro"
                      : "No te quedan espacios de conjuro para este hechizo",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),

                if (possibleLevels.isEmpty)
                  const Center(child: Text("Nivel de lanzador insuficiente."))
                else
                  ...possibleLevels.map((int level) {
                    // Verificamos si este nivel específico tiene huecos
                    final int currentSlots = char.spellSlotsCurrent[level] ?? 0;
                    final bool isAvailable = currentSlots > 0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          // Colores Activo
                          backgroundColor: const Color(
                            0xFFBA68C8,
                          ).withValues(alpha: 0.1),
                          foregroundColor: const Color(0xFFBA68C8),
                          // Colores Deshabilitado (Gris automático o personalizado)
                          disabledBackgroundColor: Colors.grey.withValues(
                            alpha: 0.1,
                          ),
                          disabledForegroundColor: Colors.grey.withValues(
                            alpha: 0.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            // Borde solo si está disponible
                            side: BorderSide(
                              color: isAvailable
                                  ? const Color(0xFFBA68C8)
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        // SI NO HAY SLOTS -> onPressed es null (Deshabilita)
                        onPressed: isAvailable
                            ? () {
                                // 1. Logica
                                bloc.add(
                                  CastSpellEvent(spell, slotLevel: level),
                                );
                                Navigator.pop(context);

                                // 2. Efecto Visual
                                ScreenEffects.showMagicBlast(
                                  context,
                                  const Color(0xFFBA68C8),
                                );

                                // 3. Feedback texto (opcional)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Lanzado a Nivel $level"),
                                    backgroundColor: const Color(0xFFBA68C8),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "NIVEL $level",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black26
                                    : Colors.white54,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                isAvailable
                                    ? "$currentSlots restantes"
                                    : "Agotado",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
