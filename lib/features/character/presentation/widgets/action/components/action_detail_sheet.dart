import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/character/presentation/bloc/character_bloc.dart';
import 'package:dnd_app/features/character/presentation/widgets/action/components/action_badges.dart';
import 'package:dnd_app/features/character/presentation/widgets/action/components/action_visual.dart';
import 'package:flutter/material.dart';
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
    // en el archivo padre, así que aquí consumimos directamente.

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // CABECERA
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

          // STATS DETALLADOS
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

          // DESCRIPCIÓN
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

          // INFO DAÑO
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
        ],
      ),
    );
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
