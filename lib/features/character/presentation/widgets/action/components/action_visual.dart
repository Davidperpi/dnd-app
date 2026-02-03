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
    final IconData icon = _getIconForAction();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }

  IconData _getIconForAction() {
    final String nameLower = action.name.toLowerCase();

    switch (action.type) {
      case ActionType.attack:
        if (nameLower.contains('daga') || nameLower.contains('dagger')) {
          return Icons.change_history;
        } else if (nameLower.contains('espada') ||
            nameLower.contains('sable') ||
            nameLower.contains('sword')) {
          return Icons.kebab_dining;
        } else if (nameLower.contains('arco') ||
            nameLower.contains('flecha') ||
            nameLower.contains('bow') ||
            nameLower.contains('arrow')) {
          return Icons.u_turn_left;
        } else {
          return Icons.gavel; // Default for attacks
        }
      case ActionType.spell:
        return Icons.auto_fix_high; // Icon for spells
      case ActionType.utility:
        if (nameLower.contains('correr') || nameLower.contains('dash')) {
          return Icons.directions_run;
        } else if (nameLower.contains('esquivar') || nameLower.contains('dodge')) {
          return Icons.shield;
        } else if (nameLower.contains('destrabarse') ||
            nameLower.contains('disengage')) {
          return Icons.compare_arrows;
        } else {
          return Icons.settings_accessibility; // Default for utility
        }
      case ActionType.feature:
        return Icons.flash_on; // Icon for features
    }
  }
}
