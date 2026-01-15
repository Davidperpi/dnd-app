import 'package:dnd_app/features/character/domain/entities/character_action.dart';
// IMPORTANTE: Necesario para diferenciar los tipos de coste (Slot, Item, Feature)
import 'package:dnd_app/features/character/domain/entities/resource_cost.dart';
import 'package:dnd_app/features/character/presentation/bloc/character_bloc.dart';
import 'package:dnd_app/features/character/presentation/widgets/action/sheet/action_detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/action_badges.dart';
import 'components/action_quick_button.dart';
import 'components/action_stats.dart';
import 'components/action_visual.dart';

class ActionCard extends StatelessWidget {
  final CharacterAction action;

  const ActionCard({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    // Colores semánticos según el tipo de acción
    final Color accentColor = switch (action.type) {
      ActionType.attack => const Color(0xFFE57373),
      ActionType.spell => const Color(0xFFBA68C8),
      ActionType.feature => const Color(0xFFFFB74D),
      ActionType.utility => const Color(0xFF90A4AE),
    };

    final bool isFav = action.isFavorite;

    // Estilos de Favorito
    final Color borderColor = isFav
        ? Colors.amber
        : theme.colorScheme.outline.withValues(alpha: 0.1);
    final double borderWidth = isFav ? 2.0 : 1.0;
    final Color cardColor = isFav
        ? Colors.amber.withValues(alpha: 0.05)
        : theme.colorScheme.surface;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onLongPress: () => _handleFavoriteToggle(context),
          onTap: () => _showActionDetails(context, accentColor),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                // 1. VISUAL (Icono o Imagen a la izquierda)
                ActionVisual(action: action, color: accentColor),

                const SizedBox(width: 12),

                // 2. INFORMACIÓN CENTRAL (Nombre y etiquetas)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        action.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: <Widget>[
                          // Badge de Coste (Dinámico: Nivel Magia, Usos Item, etc.)
                          if (_buildResourceBadge(accentColor) != null)
                            _buildResourceBadge(accentColor)!,

                          // Badge de Tipo de Acción (Acción, Bonus, Reacción)
                          ActionBadge(
                            text: translateActionCost(action.cost),
                            backgroundColor: isDark
                                ? Colors.grey[800]!
                                : Colors.grey[200]!,
                            textColor: isDark ? Colors.white70 : Colors.black87,
                          ),

                          // Badge de Tipo de Daño (Fuego, Cortante, etc.)
                          if (action.damageType != null)
                            ActionBadge(
                              text: translateDamageType(action.damageType!),
                              backgroundColor: accentColor.withValues(
                                alpha: 0.1,
                              ),
                              textColor: accentColor,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // 3. ZONA DE ACCIÓN (Derecha)
                // Ataques y Conjuros tienen botón rápido. El resto muestra stats.
                if (action.type == ActionType.attack ||
                    action.type == ActionType.spell ||
                    action.resourceCost != null)
                  ActionQuickButton(action: action, color: accentColor)
                else if (action.diceNotation != null ||
                    action.toHitModifier != null)
                  ActionStatBlock(action: action, color: accentColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construye la etiqueta de coste basándose en el tipo de recurso (Pattern Matching)
  Widget? _buildResourceBadge(Color accentColor) {
    final ResourceCost? cost = action.resourceCost;

    // Si es un item (Consumible), mostramos el stock "x3"
    if (action.resourceCost is ItemCost && action.remainingUses != null) {
      return ActionBadge(
        text: "x${action.remainingUses}",
        backgroundColor: accentColor.withValues(alpha: 0.2),
        textColor: accentColor,
      );
    }

    // Caso Especial: Trucos (Magia sin coste de recurso)
    if (action.type == ActionType.spell && cost == null) {
      return ActionBadge(
        text: "TRUCO",
        backgroundColor: accentColor.withValues(alpha: 0.2),
        textColor: accentColor,
      );
    }

    // Si no tiene coste ni es hechizo, no mostramos nada extra
    if (cost == null) return null;

    // Switch sobre la Sealed Class ResourceCost
    return switch (cost) {
      SpellSlotCost(level: final int lvl) => ActionBadge(
        text: "NVL $lvl",
        backgroundColor: accentColor.withValues(alpha: 0.2),
        textColor: accentColor,
      ),
      ItemCost(amount: final int amt) => ActionBadge(
        text: "$amt ${amt > 1 ? 'USOS' : 'USO'}",
        backgroundColor: accentColor.withValues(alpha: 0.2),
        textColor: accentColor,
      ),
      FeatureResourceCost(amount: final int amt) => ActionBadge(
        text: "$amt REC.",
        backgroundColor: accentColor.withValues(alpha: 0.2),
        textColor: accentColor,
      ),
    };
  }

  void _handleFavoriteToggle(BuildContext context) {
    context.read<CharacterBloc>().add(ToggleFavoriteActionEvent(action.id));

    // Feedback visual simple
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          action.isFavorite
              ? 'Eliminado de favoritos'
              : '⭐ Añadido a favoritos',
        ),
        backgroundColor: action.isFavorite ? null : Colors.amber[700],
        duration: const Duration(milliseconds: 600),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showActionDetails(BuildContext context, Color color) {
    final CharacterBloc characterBloc = context.read<CharacterBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      builder: (BuildContext ctx) {
        // Re-inyectamos el BLoC porque el BottomSheet crea un nuevo árbol de widgets
        return BlocProvider<CharacterBloc>.value(
          value: characterBloc,
          child: ActionDetailSheet(action: action, color: color),
        );
      },
    );
  }
}
