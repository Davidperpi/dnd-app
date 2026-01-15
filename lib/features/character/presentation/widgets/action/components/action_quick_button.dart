import 'package:dnd_app/core/utils/screen_effects.dart';
import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/character/presentation/bloc/character_bloc.dart';
import 'package:dnd_app/features/character/presentation/widgets/action/sheet/cast_spell_sheet.dart';
import 'package:dnd_app/features/spells/domain/entities/spell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionQuickButton extends StatelessWidget {
  final CharacterAction action;
  final Color color;

  const ActionQuickButton({
    super.key,
    required this.action,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSpell = action.type == ActionType.spell;
    final IconData icon = isSpell ? Icons.auto_fix_high : Icons.casino;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleQuickAction(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: color, size: 24),
              // Si tiene modificador o dados, los mostramos debajo del icono
              if (action.toHitModifier != null ||
                  action.diceNotation != null) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  // Priorizamos mostrar el daño (diceNotation), si no, el ataque (+Hit)
                  action.diceNotation ?? "+${action.toHitModifier}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleQuickAction(BuildContext context) {
    if (action.type == ActionType.spell) {
      _quickCastSpell(context);
    } else {
      ScreenEffects.showSlash(context, color);
    }
  }

  void _quickCastSpell(BuildContext context) {
    final CharacterState state = context.read<CharacterBloc>().state;
    if (state is CharacterLoaded) {
      try {
        final Spell spell = state.character.knownSpells.firstWhere(
          (Spell s) => s.id == action.id,
        );

        if (spell.level == 0) {
          ScreenEffects.showMagicBlast(context, color);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✨ Truco lanzado: ${spell.name}"),
              backgroundColor: color,
            ),
          );
        } else {
          // Conjuro Nivel 1+: Abrimos el selector directamente
          showModalBottomSheet(
            context: context,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            // Importante: isScrollControlled para que se adapte al contenido
            isScrollControlled: true,
            builder: (_) => CastSpellSheet(
              spell: spell,
              bloc: context.read<CharacterBloc>(),
            ),
          );
        }
      } catch (e) {
        debugPrint("Error buscando spell: $e");
      }
    }
  }
}
