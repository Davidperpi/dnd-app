import 'package:dnd_app/core/utils/screen_effects.dart';
import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/character/domain/entities/resource_cost.dart';
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
    // 1. LÓGICA DE DISPONIBILIDAD
    // Si remainingUses es null (ej: Ataque básico), está disponible.
    // Si tiene número, debe ser mayor que 0.
    final bool isAvailable =
        action.remainingUses == null || action.remainingUses! > 0;

    // 2. LÓGICA DE COLOR (Gris si está deshabilitado)
    final Color effectiveColor = isAvailable
        ? color
        : Theme.of(context).disabledColor;

    // 3. Iconografía semántica
    final IconData icon = switch (action.type) {
      ActionType.spell => Icons.auto_fix_high,
      ActionType.attack => Icons.casino,
      ActionType.utility => Icons.local_drink, // Pociones/Items
      ActionType.feature => Icons.flash_on, // Rasgos
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        // BLOQUEO DE INTERACCIÓN: Si no está disponible, onTap es null
        onTap: isAvailable ? () => _handleQuickAction(context) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              // Borde más sutil si está deshabilitado
              color: effectiveColor.withValues(alpha: isAvailable ? 0.3 : 0.1),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: effectiveColor, size: 24),

              // Si tiene modificador o dados, los mostramos debajo
              if (action.toHitModifier != null ||
                  action.diceNotation != null) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  action.diceNotation ?? "+${action.toHitModifier}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: effectiveColor,
                  ),
                ),
              ],

              // INDICADOR DE AGOTADO
              if (!isAvailable) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  "0",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: effectiveColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // --- LÓGICA DE DISPATCHER ---

  void _handleQuickAction(BuildContext context) {
    switch (action.type) {
      case ActionType.spell:
        _quickCastSpell(context);
        break;
      case ActionType.attack:
        ScreenEffects.showSlash(context, color);
        break;
      case ActionType.utility:
        _handleConsumable(context);
        break;
      case ActionType.feature:
        _handleFeature(context);
        break;
    }
  }

  void _handleConsumable(BuildContext context) {
    final ResourceCost? cost = action.resourceCost;

    if (cost is ItemCost) {
      // 1. Efecto Visual
      ScreenEffects.showMagicBlast(context, color);

      // 2. Disparar Evento BLoC
      context.read<CharacterBloc>().add(ConsumeItemEvent(itemId: cost.itemId));

      // 3. Feedback Snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("🧪 Usaste ${action.name}"),
          backgroundColor: color,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _handleFeature(BuildContext context) {
    final ResourceCost? cost = action.resourceCost;

    if (cost is FeatureResourceCost) {
      // 1. Efecto Visual
      ScreenEffects.showMagicBlast(context, color);

      // 2. Disparar Evento BLoC
      context.read<CharacterBloc>().add(
        UseFeatureEvent(resourceId: cost.resourceId),
      );

      // 3. Feedback Snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("⚡ ${action.name} activado"),
          backgroundColor: color,
          duration: const Duration(seconds: 1),
        ),
      );
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
        debugPrint("Error buscando spell: $e");
      }
    }
  }
}
