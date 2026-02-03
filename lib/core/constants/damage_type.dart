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

/// Extension to add extra functionality to the DamageType Enum.
extension DamageTypeExtension on DamageType {
  /// Returns a user-friendly, uppercased string representation.
  String get label {
    return switch (this) {
      DamageType.acid => 'ÁCIDO',
      DamageType.bludgeoning => 'CONTUNDENTE',
      DamageType.cold => 'FRÍO',
      DamageType.fire => 'FUEGO',
      DamageType.force => 'FUERZA',
      DamageType.lightning => 'RAYO',
      DamageType.necrotic => 'NECRÓTICO',
      DamageType.piercing => 'PERFORANTE',
      DamageType.poison => 'VENENO',
      DamageType.psychic => 'PSÍQUICO',
      DamageType.radiant => 'RADIANTE',
      DamageType.slashing => 'CORTANTE',
      DamageType.thunder => 'TRUENO',
    };
  }

  /// Returns a corresponding icon for the damage type.
  IconData get icon {
    return switch (this) {
      DamageType.acid => Icons.science, // or water_drop
      DamageType.bludgeoning => Icons.construction, // was gavel
      DamageType.cold => Icons.ac_unit,
      DamageType.fire => Icons.local_fire_department,
      DamageType.force => Icons.compare_arrows, // or explosion
      DamageType.lightning => Icons.flash_on,
      DamageType.necrotic =>
        Icons.dangerous, // No skull icon in standard set, using a similar one.
      DamageType.piercing => Icons.arrow_right_alt, // Arrow
      DamageType.poison => Icons.bug_report, // or science
      DamageType.psychic => Icons.psychology,
      DamageType.radiant => Icons.wb_sunny,
      DamageType.slashing =>
        Icons.content_cut, // No sword icon, using scissors/cut as an alternative.
      DamageType.thunder => Icons.volume_up,
    };
  }
}
