import 'package:flutter/material.dart';

enum DamageType {
  acid,
  bludgeoning,
  cold,
  fire,
  force,
  lightning,
  necrotic,
  piercing,
  poison,
  psychic,
  radiant,
  slashing,
  thunder,
}

/// Extensión para darle "superpoderes" al Enum
extension DamageTypeExtension on DamageType {
  String get nameES {
    return switch (this) {
      DamageType.acid => 'ÁCIDO',
      DamageType.bludgeoning => 'CONTUNDENTE',
      DamageType.cold => 'FRÍO',
      DamageType.fire => 'FUEGO',
      DamageType.force => 'FUERZA',
      DamageType.lightning => 'RELÁMPAGO',
      DamageType.necrotic => 'NECRÓTICO',
      DamageType.piercing => 'PERFORANTE',
      DamageType.poison => 'VENENO',
      DamageType.psychic => 'PSÍQUICO',
      DamageType.radiant => 'RADIANTE',
      DamageType.slashing => 'CORTANTE',
      DamageType.thunder => 'TRUENO',
    };
  }

  IconData get icon {
    return switch (this) {
      DamageType.acid => Icons.science, // O water_drop
      DamageType.bludgeoning => Icons.gavel, // O gavel
      DamageType.cold => Icons.ac_unit,
      DamageType.fire => Icons.local_fire_department,
      DamageType.force => Icons.compare_arrows, // O explosion
      DamageType.lightning => Icons.flash_on,
      DamageType.necrotic =>
        Icons.dangerous, // No hay calavera en standard, usamos algo similar
      DamageType.piercing => Icons.arrow_right_alt, // Flecha
      DamageType.poison => Icons.bug_report, // O biological
      DamageType.psychic => Icons.psychology,
      DamageType.radiant => Icons.wb_sunny,
      DamageType.slashing =>
        Icons.content_cut, // Espada no hay, tijeras/corte sirve
      DamageType.thunder => Icons.volume_up,
    };
  }
}
