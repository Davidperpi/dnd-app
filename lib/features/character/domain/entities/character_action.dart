import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:equatable/equatable.dart';

enum ActionType { attack, spell, feature, utility }

enum ActionCost { action, bonusAction, reaction, free }

class CharacterAction extends Equatable {
  final String id;
  final String name;
  final String description;
  final ActionType type;
  final ActionCost cost;
  final bool isFavorite;
  final String? diceNotation;
  final DamageType? damageType;
  final int? toHitModifier;
  final String? imageUrl;

  const CharacterAction({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.cost,
    this.diceNotation,
    this.damageType,
    this.toHitModifier,
    this.imageUrl,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    description,
    type,
    cost,
    diceNotation,
    damageType,
    toHitModifier,
    imageUrl,
    isFavorite,
  ];
}
