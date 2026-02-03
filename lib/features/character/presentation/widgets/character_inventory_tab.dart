import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../inventory/domain/entities/armor.dart';
import '../../../inventory/domain/entities/equipment_slot.dart';
import '../../../inventory/domain/entities/item.dart';
import '../../../inventory/domain/entities/weapon.dart';
import '../../domain/entities/character.dart';
import '../bloc/character_bloc.dart';
// Imports for our new divided Widgets
import 'inventory/inventory_item_card.dart';
import 'inventory/inventory_modals.dart';

enum InventoryView { equipped, backpack }

class CharacterInventoryTab extends StatefulWidget {
  final Character character;

  const CharacterInventoryTab({super.key, required this.character});

  @override
  State<CharacterInventoryTab> createState() => _CharacterInventoryTabState();
}

class _CharacterInventoryTabState extends State<CharacterInventoryTab> {
  InventoryView _currentView = InventoryView.equipped;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        // 1. LIST
        Expanded(
          child: _currentView == InventoryView.equipped
              ? _buildEquippedList(widget.character)
              : _buildBackpackList(widget.character),
        ),

        // 2. NAVIGATION DOCK
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<InventoryView>(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((
                    Set<WidgetState> states,
                  ) {
                    return states.contains(WidgetState.selected)
                        ? theme.colorScheme.primary
                        : Colors.transparent;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>((
                    Set<WidgetState> states,
                  ) {
                    return states.contains(WidgetState.selected)
                        ? const Color(0xFF121212)
                        : theme.colorScheme.onSurface;
                  }),
                  side: WidgetStateProperty.all<BorderSide>(
                    BorderSide(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                ),
                segments: const <ButtonSegment<InventoryView>>[
                  ButtonSegment<InventoryView>(
                    value: InventoryView.equipped,
                    label: Text('EQUIPADO'),
                    icon: Icon(Icons.shield_outlined),
                  ),
                  ButtonSegment<InventoryView>(
                    value: InventoryView.backpack,
                    label: Text('MOCHILA'),
                    icon: Icon(Icons.backpack_outlined),
                  ),
                ],
                selected: <InventoryView>{_currentView},
                onSelectionChanged: (Set<InventoryView> newSelection) {
                  setState(() {
                    _currentView = newSelection.first;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEquippedList(Character char) {
    final List<Item> equippedItems = char.inventory.where((Item item) {
      if (item is Weapon) return item.isEquipped;
      if (item is Armor) return item.isEquipped;
      return false;
    }).toList();

    if (equippedItems.isEmpty) {
      return const Center(child: Text("No tienes nada equipado."));
    }

    equippedItems.sort((Item a, Item b) {
      final EquipmentSlot slotA = _getItemSlot(a);
      final EquipmentSlot slotB = _getItemSlot(b);
      return slotA.index.compareTo(slotB.index);
    });

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: equippedItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (BuildContext context, int index) {
        final Item item = equippedItems[index];
        return InventoryItemCard(
          item: item,
          isEquipped: true,
          onTapBody: () => showInventoryItemDetails(context, item),
          onTapAction: () {
            // Unequip confirmation (Imported from modals.dart)
            showUnequipConfirmation(context, item, () {
              context.read<CharacterBloc>().add(ToggleEquipItemEvent(item));
            });
          },
        );
      },
    );
  }

  Widget _buildBackpackList(Character char) {
    final List<Item> backpackItems = char.inventory.where((Item item) {
      if (item is Weapon) return !item.isEquipped;
      if (item is Armor) return !item.isEquipped;
      return true;
    }).toList();

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: backpackItems.length,
      separatorBuilder: (_, __) =>
          Divider(color: Colors.white.withOpacity(0.05)),
      itemBuilder: (BuildContext context, int index) {
        final Item item = backpackItems[index];
        return InventoryItemCard(
          item: item,
          isEquipped: false,
          onTapBody: () => showInventoryItemDetails(context, item),
          onTapAction: () {
            _handleEquipAttempt(context, item);
          },
        );
      },
    );
  }

  // --- MANAGEMENT LOGIC (Widget Intelligence) ---

  void _handleEquipAttempt(BuildContext context, Item newItem) {
    final EquipmentSlot targetSlot = _getItemSlot(newItem);
    final Item? currentItem = _getEquippedItemInSlot(
      widget.character,
      targetSlot,
    );

    if (currentItem != null) {
      // Conflict: Show substitution dialog (Imported from modals.dart)
      showSwapConfirmation(context, newItem, currentItem, () {
        context.read<CharacterBloc>().add(ToggleEquipItemEvent(newItem));
      });
    } else {
      // Free: Equip directly
      context.read<CharacterBloc>().add(ToggleEquipItemEvent(newItem));
    }
  }

  Item? _getEquippedItemInSlot(Character char, EquipmentSlot slot) {
    try {
      return char.inventory.firstWhere((Item item) {
        if (item is Weapon) return item.isEquipped && item.slot == slot;
        if (item is Armor) return item.isEquipped && item.slot == slot;
        return false;
      });
    } catch (e) {
      return null;
    }
  }

  EquipmentSlot _getItemSlot(Item item) {
    if (item is Weapon) return item.slot;
    if (item is Armor) return item.slot;
    return EquipmentSlot.other;
  }
}
