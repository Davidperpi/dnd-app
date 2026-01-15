// ignore_for_file: always_specify_types

import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:dnd_app/features/character/domain/entities/character_action.dart';

import '../../../../core/constants/magic_school.dart';

class Spell {
  final String id;
  final String name;
  final int level;
  final MagicSchool school;
  final ActionCost castTime;
  final String range;
  final List<String> components;
  final String duration;
  final bool concentration;
  final String description;

  final String? damageDice;
  final DamageType? damageType;
  final bool requiresSave;
  final bool requiresAttackRoll;

  const Spell({
    required this.id,
    required this.name,
    required this.level,
    required this.school,
    required this.castTime,
    required this.range,
    this.components = const [],
    required this.duration,
    this.concentration = false,
    required this.description,
    this.damageDice,
    this.damageType,
    this.requiresSave = false,
    this.requiresAttackRoll = false,
  });
}
