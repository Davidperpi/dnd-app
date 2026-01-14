import 'package:dnd_app/core/constants/attributes.dart';
import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:dnd_app/features/inventory/domain/entities/armor.dart';
import 'package:dnd_app/features/inventory/domain/entities/item.dart';
import 'package:dnd_app/features/inventory/domain/entities/weapon.dart';
import 'package:flutter/material.dart';

/// Muestra la hoja de detalles del objeto
void showInventoryItemDetails(BuildContext context, Item item) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    isScrollControlled: true,
    builder: (BuildContext ctx) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              item.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            if (item is Weapon) ...<Widget>[
              _buildDetailRow(
                context,
                "Tipo de Daño",
                _translateDamageTypeFull(item.damageType),
              ),
              _buildDetailRow(context, "Dado de Daño", item.damageDice),
              _buildDetailRow(
                context,
                "Atributo",
                _translateAttributeFull(item.attribute),
              ),
            ],
            if (item is Armor) ...<Widget>[
              _buildDetailRow(
                context,
                "Clase de Armadura",
                "+${item.armorClassBonus} AC",
              ),
              _buildDetailRow(
                context,
                "Tipo",
                item.armorType.name.toUpperCase(),
              ),
            ],
            _buildDetailRow(context, "Peso", "${item.weight} lb"),
            const SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}

/// Diálogo para confirmar desequipamiento
void showUnequipConfirmation(
  BuildContext context,
  Item item,
  VoidCallback onConfirm,
) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: Text('¿Desequipar ${item.name}?'),
        content: const Text('Volverá a tu mochila.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onConfirm();
            },
            child: Text(
              'DESEQUIPAR',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      );
    },
  );
}

/// Diálogo para confirmar sustitución de objeto
void showSwapConfirmation(
  BuildContext context,
  Item newItem,
  Item currentItem,
  VoidCallback onConfirm,
) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: const Text('Sustituir objeto', style: TextStyle(fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Vas a quitar:',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              currentItem.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 16),
            const Icon(Icons.swap_vert, size: 24, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Para equipar:',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              newItem.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onConfirm();
            },
            child: const Text('SUSTITUIR'),
          ),
        ],
      );
    },
  );
}

// --- HELPERS PRIVADOS DE UI ---

Widget _buildDetailRow(BuildContext context, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

String _translateDamageTypeFull(DamageType type) {
  return switch (type) {
    DamageType.slashing => 'Cortante',
    DamageType.piercing => 'Perforante',
    DamageType.bludgeoning => 'Contundente',
    DamageType.psychic => 'Psíquico',
    _ => 'Mágico',
  };
}

String _translateAttributeFull(Attribute attr) {
  return switch (attr) {
    Attribute.strength => 'Fuerza',
    Attribute.dexterity => 'Destreza',
    Attribute.constitution => 'Constitución',
    Attribute.intelligence => 'Inteligencia',
    Attribute.wisdom => 'Sabiduría',
    Attribute.charisma => 'Carisma',
  };
}
