import 'package:dnd_app/core/utils/screen_effects.dart';
import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/character/presentation/bloc/character_bloc.dart';
import 'package:dnd_app/features/character/presentation/widgets/action/components/action_badges.dart';
import 'package:dnd_app/features/character/presentation/widgets/action/components/action_visual.dart';
import 'package:dnd_app/features/character/presentation/widgets/action/sheet/cast_spell_sheet.dart';
import 'package:dnd_app/features/spells/domain/entities/spell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionDetailSheet extends StatelessWidget {
  final CharacterAction action;
  final Color color;

  const ActionDetailSheet({
    super.key,
    required this.action,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Nota: El BlocProvider ya viene inyectado desde el showModalBottomSheet
    // en el archivo padre (action_card.dart), así que aquí consumimos directamente.

    return Padding(
      // Añadimos padding inferior extra para que el botón respire
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 1. CABECERA
          Row(
            children: <Widget>[
              ActionVisual(action: action, color: color, size: 50),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  action.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _FavoriteButton(action: action),
            ],
          ),

          const Divider(height: 32),

          // 2. STATS DETALLADOS
          // Se muestran solo si existen (null check)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              if (action.toHitModifier != null)
                _DetailStatItem(
                  label: "IMPACTO",
                  value: "+${action.toHitModifier}",
                  color: color,
                ),
              if (action.diceNotation != null)
                _DetailStatItem(
                  label: "DAÑO",
                  value: action.diceNotation!,
                  color: color,
                ),
              _DetailStatItem(
                label: "COSTE",
                value: translateActionCost(action.cost),
                color: Colors.grey,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 3. DESCRIPCIÓN
          const Text(
            "DESCRIPCIÓN",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            action.description,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),

          // 4. INFO TIPO DE DAÑO
          if (action.damageType != null) ...<Widget>[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.info_outline, color: color, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      getDamageTypeDescription(action.damageType!),
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 5. BOTÓN DE ACCIÓN PRINCIPAL (NUEVO)
          const SizedBox(height: 40),
          _buildActionButton(context),
        ],
      ),
    );
  }

  // --- LÓGICA DEL BOTÓN DE ACCIÓN ---

  Widget _buildActionButton(BuildContext context) {
    if (action.type == ActionType.feature ||
        action.type == ActionType.utility) {
      if (action.diceNotation == null) {
        return const SizedBox.shrink();
      }
    }

    final bool isSpell = action.type == ActionType.spell;
    final String label = isSpell ? "LANZAR CONJURO" : "REALIZAR ACCIÓN";
    final IconData icon = isSpell ? Icons.auto_fix_high : Icons.flash_on;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onPressed: () => _handleAction(context),
      ),
    );
  }

  void _handleAction(BuildContext context) {
    if (action.type == ActionType.spell) {
      _castSpell(context);
    } else {
      Navigator.pop(context);
      ScreenEffects.showSlash(context, color);
      HapticFeedback.heavyImpact();
    }
  }

  void _castSpell(BuildContext context) {
    final CharacterState state = context.read<CharacterBloc>().state;
    if (state is CharacterLoaded) {
      try {
        final Spell spell = state.character.knownSpells.firstWhere(
          (Spell s) => s.id == action.id,
        );

        Navigator.pop(context);

        if (spell.level == 0) {
          ScreenEffects.showMagicBlast(context, color);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✨ Truco lanzado: ${spell.name}"),
              backgroundColor: color,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          showModalBottomSheet(
            context: context,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            isScrollControlled: true,
            builder: (_) => CastSpellSheet(
              spell: spell,
              bloc: context.read<CharacterBloc>(),
            ),
          );
        }
      } catch (e) {
        debugPrint("Error: No se encontró el hechizo original: $e");
      }
    }
  }
}

// Widget auxiliar privado (solo para el sheet)
class _DetailStatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _DetailStatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final CharacterAction action;

  const _FavoriteButton({required this.action});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterBloc, CharacterState>(
      builder: (BuildContext context, CharacterState state) {
        bool isFav = action.isFavorite;
        if (state is CharacterLoaded) {
          isFav = state.character.favoriteActionIds.contains(action.id);
        }

        return IconButton(
          onPressed: () {
            context.read<CharacterBloc>().add(
              ToggleFavoriteActionEvent(action.id),
            );
          },
          icon: Icon(
            isFav ? Icons.star : Icons.star_border,
            color: isFav ? Colors.amber : Colors.grey,
            size: 32,
          ),
        );
      },
    );
  }
}
