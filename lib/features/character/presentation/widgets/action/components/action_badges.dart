import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:flutter/material.dart';

class ActionBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const ActionBadge({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: textColor,
        ),
      ),
    );
  }
}

// --- UTILS DE TRADUCCIÓN (Para usar en otros widgets) ---

String translateActionCost(ActionCost cost) {
  return switch (cost) {
    ActionCost.action => 'ACCIÓN',
    ActionCost.bonusAction => 'BONUS',
    ActionCost.reaction => 'REACCIÓN',
    ActionCost.free => 'GRATIS',
  };
}

String translateDamageType(DamageType type) {
  return switch (type) {
    DamageType.slashing => 'CORTANTE',
    DamageType.piercing => 'PERFORANTE',
    DamageType.bludgeoning => 'CONTUNDENTE',
    DamageType.psychic => 'PSÍQUICO',
    DamageType.fire => 'FUEGO',
    _ => 'MÁGICO',
  };
}

String getDamageTypeDescription(DamageType type) {
  return switch (type) {
    DamageType.slashing =>
      'Daño causado por el filo de un arma, como espadas o hachas.',
    DamageType.piercing =>
      'Daño causado por puntas afiladas, como lanzas, flechas o dagas.',
    DamageType.bludgeoning =>
      'Daño causado por fuerza bruta y objetos romos, como martillos.',
    DamageType.psychic => 'Daño directo a la mente. No deja marcas físicas.',
    _ => 'Daño de naturaleza mágica o elemental.',
  };
}
