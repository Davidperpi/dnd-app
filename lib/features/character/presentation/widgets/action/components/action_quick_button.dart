import 'package:dnd_app/core/utils/screen_effects.dart';
import 'package:dnd_app/features/character/domain/entities/character.dart';
import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/character/domain/entities/character_resource.dart';
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
    return BlocSelector<CharacterBloc, CharacterState, Character?>(
      selector: (CharacterState state) => state is CharacterLoaded ? state.character : null,
      builder: (BuildContext context, Character? character) {
        if (character == null) {
          return _buildButton(context, isAvailable: false, uses: 0);
        }

        final (bool isAvailable, int uses) = _isActionAvailable(character);
        return _buildButton(context, isAvailable: isAvailable, uses: uses);
      },
    );
  }

  Widget _buildButton(BuildContext context, {required bool isAvailable, required int uses}) {
    final Color effectiveColor = isAvailable ? color : Theme.of(context).disabledColor;
    final IconData icon = _getActionIcon();

    // Determina si debemos mostrar el contador de usos.
    // NO se muestra para FeatureResourceCost (IB, Ki, etc.)
    final bool showUsesCounter = action.resourceCost != null && action.resourceCost is! FeatureResourceCost;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isAvailable ? () => _handleQuickAction(context) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: effectiveColor.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: effectiveColor.withAlpha(isAvailable ? 77 : 25)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: effectiveColor, size: 24),
              if (action.toHitModifier != null || action.diceNotation != null) ...<Widget>[
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
              if (showUsesCounter) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  "x$uses",
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

  (bool, int) _isActionAvailable(Character character) {
    final ResourceCost? cost = action.resourceCost;
    if (cost == null) return (true, 99);

    switch (cost) {
      case FeatureResourceCost(resourceId: final String id, amount: final int amount):
        final CharacterResource? resource = character.resources[id];
        final int currentUses = resource?.current ?? 0;
        return (currentUses >= amount, currentUses);

      case ItemCost(amount: final int amount):
        final int currentUses = action.remainingUses ?? 0;
        return (currentUses >= amount, currentUses);

      case SpellSlotCost(level: final int lvl):
        if (lvl == 0) return (true, 99);
        final int currentUses = character.spellSlotsCurrent[lvl] ?? 0;
        return (currentUses > 0, currentUses);
    }
  }

  IconData _getActionIcon() {
    return switch (action.type) {
      ActionType.spell => Icons.auto_fix_high,
      ActionType.attack => Icons.casino,
      ActionType.utility => Icons.local_drink,
      ActionType.feature => Icons.flash_on,
    };
  }

  void _handleQuickAction(BuildContext context) {
    switch (action.type) {
      case ActionType.spell: _quickCastSpell(context); break;
      case ActionType.attack: ScreenEffects.showSlash(context, color); break;
      case ActionType.utility: _handleConsumable(context); break;
      case ActionType.feature: _handleFeature(context); break;
    }
  }

  void _handleConsumable(BuildContext context) {
    final ItemCost cost = action.resourceCost as ItemCost;
    ScreenEffects.showMagicBlast(context, color);
    context.read<CharacterBloc>().add(ConsumeItemEvent(itemId: cost.itemId));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🧪 Usaste ${action.name}"), backgroundColor: color, duration: const Duration(seconds: 1)));
  }

  void _handleFeature(BuildContext context) {
    final FeatureResourceCost cost = action.resourceCost as FeatureResourceCost;
    ScreenEffects.showMagicBlast(context, color);
    context.read<CharacterBloc>().add(UseFeatureEvent(resourceId: cost.resourceId));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("⚡ ${action.name} activado"), backgroundColor: color, duration: const Duration(seconds: 1)));
  }

  void _quickCastSpell(BuildContext context) {
    final CharacterState state = context.read<CharacterBloc>().state;
    if (state is CharacterLoaded) {
      final Spell spell = state.character.knownSpells.firstWhere((Spell s) => s.id == action.id, orElse: () => throw Exception("Spell not found"));
      if (spell.level == 0) {
        ScreenEffects.showMagicBlast(context, color);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✨ Truco lanzado: ${spell.name}"), backgroundColor: color));
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
    }
  }
}
