import 'package:dnd_app/core/constants/attributes.dart';
import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:dnd_app/features/inventory/domain/entities/armor.dart';
import 'package:dnd_app/features/inventory/domain/entities/equipment_slot.dart';
import 'package:dnd_app/features/inventory/domain/entities/item.dart';
import 'package:dnd_app/features/inventory/domain/entities/weapon.dart';
import 'package:flutter/material.dart';

class InventoryItemCard extends StatelessWidget {
  final Item item;
  final bool isEquipped;
  final VoidCallback onTapBody;
  final VoidCallback onTapAction;

  const InventoryItemCard({
    super.key,
    required this.item,
    required this.isEquipped,
    required this.onTapBody,
    required this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final EquipmentSlot slot = _getItemSlot();
    final bool isEquippable = item is Weapon || item is Armor;

    return Card(
      color: theme.colorScheme.surfaceContainer,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isEquipped
              ? theme.colorScheme.primary.withOpacity(0.3)
              : Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTapBody,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              // 1. ICONO
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: isEquipped
                      ? Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                        )
                      : null,
                ),
                child: Icon(
                  _getVisualIconFor(item),
                  color: isEquipped ? theme.colorScheme.primary : Colors.grey,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              // 2. TEXTOS Y CHIPS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (isEquipped)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          slot.label.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme.primary.withOpacity(0.8),
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),

                    Text(
                      item.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isEquipped
                            ? null
                            : theme.colorScheme.onSurface.withOpacity(0.9),
                      ),
                    ),

                    const SizedBox(height: 6),
                    // GENERADOR DE ETIQUETAS
                    _buildSafeStatsRow(context),
                  ],
                ),
              ),

              // 3. ACCIÓN
              const SizedBox(width: 8),
              if (isEquipped)
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.grey,
                  ),
                  onPressed: onTapAction,
                  tooltip: 'Desequipar',
                )
              else if (isEquippable)
                InkWell(
                  onTap: onTapAction,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      "EQUIPAR",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '${item.weight} lb',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPERS INTERNOS ---

  Widget _buildSafeStatsRow(BuildContext context) {
    if (item is! Weapon && item is! Armor) {
      return Text(
        item.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          fontSize: 12,
        ),
      );
    }
    return Row(children: _buildStatsTags(context));
  }

  List<Widget> _buildStatsTags(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Widget> tags = <Widget>[];

    if (item is Weapon) {
      final Weapon w = item as Weapon;
      // 1. DADO (1d8)
      tags.add(
        _buildTag(
          context,
          w.damageDice,
          icon: Icons.casino_outlined,
          isHighlight: true,
        ),
      );
      // 2. TIPO DE DAÑO (COR, PER...)
      tags.add(_buildTag(context, _translateDamageTypeShort(w.damageType)));
      // 3. ATRIBUTO (DES, FUE...)
      tags.add(
        _buildTag(
          context,
          _translateAttributeShort(w.attribute),
          color: theme.colorScheme.secondary,
        ),
      );
    } else if (item is Armor) {
      final Armor a = item as Armor;
      tags.add(
        _buildTag(
          context,
          "+${a.armorClassBonus} AC",
          icon: Icons.shield,
          isHighlight: true,
        ),
      );
      tags.add(_buildTag(context, a.armorType.name.toUpperCase()));
    }

    if (tags.isNotEmpty) {
      return tags
          .expand(
            (Widget element) => <Widget>[element, const SizedBox(width: 6)],
          )
          .toList()
        ..removeLast();
    }
    return tags;
  }

  EquipmentSlot _getItemSlot() {
    if (item is Weapon) return (item as Weapon).slot;
    if (item is Armor) return (item as Armor).slot;
    return EquipmentSlot.other;
  }

  IconData _getVisualIconFor(Item item) {
    if (item is Weapon) {
      final EquipmentSlot slot = (item).slot;
      return slot == EquipmentSlot.mainHand
          ? Icons.front_hand
          : Icons.back_hand;
    }
    if (item is Armor) return Icons.shield;
    if (item.type == ItemType.potion) return Icons.local_drink;
    if (item.type == ItemType.gear) return Icons.backpack;
    if (item.type == ItemType.tool) return Icons.build;
    return Icons.circle_outlined;
  }

  Widget _buildTag(
    BuildContext context,
    String text, {
    IconData? icon,
    bool isHighlight = false,
    Color? color,
  }) {
    final ThemeData theme = Theme.of(context);
    final Color contentColor =
        color ??
        (isHighlight
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withOpacity(0.7));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isHighlight
            ? theme.colorScheme.primary.withOpacity(0.1)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(4),
        border: isHighlight
            ? Border.all(color: contentColor.withOpacity(0.3))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 12, color: contentColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              color: contentColor,
            ),
          ),
        ],
      ),
    );
  }

  // --- TRADUCCIONES ---
  String _translateDamageTypeShort(DamageType type) {
    return switch (type) {
      DamageType.slashing => 'COR',
      DamageType.piercing => 'PER',
      DamageType.bludgeoning => 'CON',
      DamageType.psychic => 'PSI',
      DamageType.acid => 'ACD',
      DamageType.cold => 'FRO',
      DamageType.fire => 'FGO',
      DamageType.force => 'FRZ',
      DamageType.lightning => 'RAY',
      DamageType.necrotic => 'NEC',
      DamageType.poison => 'VEN',
      DamageType.radiant => 'RAD',
      DamageType.thunder => 'TRU',
    };
  }

  String _translateAttributeShort(Attribute attr) {
    return switch (attr) {
      Attribute.strength => 'FUE',
      Attribute.dexterity => 'DES',
      Attribute.constitution => 'CON',
      Attribute.intelligence => 'INT',
      Attribute.wisdom => 'SAB',
      Attribute.charisma => 'CAR',
    };
  }
}
