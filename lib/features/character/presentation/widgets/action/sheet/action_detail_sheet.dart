import 'package:dnd_app/core/utils/screen_effects.dart';
import 'package:dnd_app/features/character/domain/entities/character.dart';
import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/character/domain/entities/character_resource.dart';
import 'package:dnd_app/features/character/domain/entities/resource_cost.dart';
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
    return BlocBuilder<CharacterBloc, CharacterState>(
      builder: (BuildContext context, CharacterState state) {
        if (state is! CharacterLoaded) {
          // Show a minimal disabled view if character data is not available
          return const Padding(
            padding: EdgeInsets.all(40.0),
            child: Center(child: Text("Cargando datos del personaje...")),
          );
        }

        final Character character = state.character;
        final (bool isAvailable, String usageText) = _getAvailabilityAndUsageText(character);

        return Padding(
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
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _FavoriteButton(action: action),
                ],
              ),
              const Divider(height: 32),

              // 2. STATS DETALLADOS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  if (action.toHitModifier != null)
                    _DetailStatItem(
                        label: "IMPACTO",
                        value: "+${action.toHitModifier}",
                        color: color),
                  if (action.diceNotation != null)
                    _DetailStatItem(
                        label: "DAÑO",
                        value: action.diceNotation!,
                        color: color),
                  _DetailStatItem(
                      label: "USO", value: usageText, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 24),

              // 3. DESCRIPCIÓN
              const Text("DESCRIPCIÓN",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 12)),
              const SizedBox(height: 8),
              Text(action.description,
                  style: const TextStyle(fontSize: 16, height: 1.5)),

              if (action.damageType != null) ...<Widget>[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: color.withAlpha(25),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(children: <Widget>[
                    Icon(Icons.info_outline, color: color, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(
                            getDamageTypeDescription(action.damageType!),
                            style: TextStyle(
                                color: color,
                                fontSize: 13,
                                fontStyle: FontStyle.italic)))
                  ]),
                )
              ],

              // 5. BOTÓN DE ACCIÓN PRINCIPAL
              const SizedBox(height: 40),
              _buildActionButton(context, isAvailable: isAvailable),
            ],
          ),
        );
      },
    );
  }

  (bool, String) _getAvailabilityAndUsageText(Character character) {
    final ResourceCost? cost = action.resourceCost;
    if (cost == null) return (true, translateActionCost(action.cost));

    switch (cost) {
      case FeatureResourceCost(resourceId: final String id, amount: final int amount):
        final CharacterResource? resource = character.resources[id];
        final int current = resource?.current ?? 0;
        final int max = resource?.max ?? 0;
        return (current >= amount, "$current/$max");

      case ItemCost():
        final int current = action.remainingUses ?? 0;
        final int max = action.maxUses ?? 0;
        return (current > 0, max > 0 ? "$current/$max" : "x$current");

      case SpellSlotCost(level: final int lvl):
        if (lvl == 0) return (true, "TRUCO");
        final int current = character.spellSlotsCurrent[lvl] ?? 0;
        final int max = character.spellSlotsMax[lvl] ?? 0;
        return (current > 0, "$current/$max");
    }
  }

  Widget _buildActionButton(BuildContext context, {required bool isAvailable}) {
    final Color btnColor = isAvailable ? color : Theme.of(context).disabledColor;
    String label = "REALIZAR ACCIÓN";
    IconData icon = Icons.flash_on;

    if (!isAvailable) {
      label = "AGOTADO";
      icon = Icons.block;
    } else if (action.type == ActionType.spell) {
      label = "LANZAR CONJURO";
      icon = Icons.auto_fix_high;
    } else if (action.resourceCost is ItemCost) {
      label = "USAR OBJETO";
      icon = Icons.local_drink;
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
            backgroundColor: btnColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            disabledBackgroundColor: Colors.grey.withAlpha(50)),
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        onPressed: isAvailable ? () => _handleAction(context) : null,
      ),
    );
  }

  void _handleAction(BuildContext context) {
    if (action.type == ActionType.spell) {
      _castSpell(context);
      return;
    }

    Navigator.pop(context);

    switch (action.type) {
      case ActionType.attack:
        ScreenEffects.showSlash(context, color);
        HapticFeedback.heavyImpact();
        break;
      case ActionType.utility: _handleConsumable(context); break;
      case ActionType.feature: _handleFeature(context); break;
      default: break;
    }
  }

  void _handleConsumable(BuildContext context) {
    final ItemCost cost = action.resourceCost as ItemCost;
    ScreenEffects.showMagicBlast(context, color);
    context.read<CharacterBloc>().add(ConsumeItemEvent(itemId: cost.itemId));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🧪 Usaste ${action.name}"), backgroundColor: color, behavior: SnackBarBehavior.floating));
  }

  void _handleFeature(BuildContext context) {
    final FeatureResourceCost cost = action.resourceCost as FeatureResourceCost;
    ScreenEffects.showMagicBlast(context, color);
    context.read<CharacterBloc>().add(UseFeatureEvent(resourceId: cost.resourceId));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("⚡ ${action.name} activado"), backgroundColor: color, behavior: SnackBarBehavior.floating));
  }

  void _castSpell(BuildContext context) {
    final CharacterState state = context.read<CharacterBloc>().state;
    if (state is CharacterLoaded) {
      try {
        final Spell spell = state.character.knownSpells.firstWhere((Spell s) => s.id == action.id);
        Navigator.pop(context);
        if (spell.level == 0) {
          ScreenEffects.showMagicBlast(context, color);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✨ Truco lanzado: ${spell.name}"), backgroundColor: color, behavior: SnackBarBehavior.floating));
        } else {
          showModalBottomSheet(
            context: context,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            isScrollControlled: true,
            builder: (_) => BlocProvider.value(
              value: context.read<CharacterBloc>(), 
              child: CastSpellSheet(spell: spell, bloc: context.read<CharacterBloc>()),
            ),
          );
        }
      } catch (e) {
        debugPrint("Error: No se encontró el hechizo original: $e");
      }
    }
  }
}

class _DetailStatItem extends StatelessWidget {
  final String label, value;
  final Color color;

  const _DetailStatItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
    ]);
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
          onPressed: () => context.read<CharacterBloc>().add(ToggleFavoriteActionEvent(action.id)),
          icon: Icon(isFav ? Icons.star : Icons.star_border, color: isFav ? Colors.amber : Colors.grey, size: 32),
        );
      },
    );
  }
}
