import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:flutter/material.dart';

class ActionStatBlock extends StatelessWidget {
  final CharacterAction action;
  final Color color;

  const ActionStatBlock({super.key, required this.action, required this.color});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          if (action.toHitModifier != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'IMP',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '+${action.toHitModifier}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ],
            ),
          if (action.diceNotation != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'DAÑO',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  action.diceNotation!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
