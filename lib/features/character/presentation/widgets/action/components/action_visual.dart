import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:flutter/material.dart';

class ActionVisual extends StatelessWidget {
  final CharacterAction action;
  final Color color;
  final double size;

  const ActionVisual({
    super.key,
    required this.action,
    required this.color,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.flash_on;
    final String nameLower = action.name.toLowerCase();

    if (action.type == ActionType.attack) {
      if (nameLower.contains('daga') || nameLower.contains('dagger')) {
        icon = Icons.change_history;
      } else if (nameLower.contains('espada') || nameLower.contains('sable')) {
        icon = Icons.kebab_dining;
      } else if (nameLower.contains('arco') || nameLower.contains('flecha')) {
        icon = Icons.u_turn_left;
      } else {
        icon = Icons.gavel;
      }
    } else if (action.type == ActionType.utility) {
      if (nameLower.contains('correr')) icon = Icons.directions_run;
      if (nameLower.contains('esquivar')) icon = Icons.shield;
      if (nameLower.contains('destrabarse')) icon = Icons.compare_arrows;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}
