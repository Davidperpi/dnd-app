import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:dnd_app/features/character/domain/entities/resource_cost.dart';
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
  final ResourceCost? resourceCost;
  final int? remainingUses;
  final int? maxUses;

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
    this.resourceCost,
    this.remainingUses, // <--- Nuevo
    this.maxUses,
  });

  CharacterAction copyWith({
    String? id,
    String? name,
    String? description,
    ActionType? type,
    ActionCost? cost,
    bool? isFavorite,
    String? diceNotation,
    DamageType? damageType,
    int? toHitModifier,
    String? imageUrl,
    ResourceCost? resourceCost,
    int? remainingUses,
    int? maxUses,
  }) {
    return CharacterAction(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      cost: cost ?? this.cost,
      isFavorite: isFavorite ?? this.isFavorite,
      diceNotation: diceNotation ?? this.diceNotation,
      damageType: damageType ?? this.damageType,
      toHitModifier: toHitModifier ?? this.toHitModifier,
      imageUrl: imageUrl ?? this.imageUrl,
      resourceCost: resourceCost ?? this.resourceCost,
      remainingUses: remainingUses ?? this.remainingUses,
      maxUses: maxUses ?? this.maxUses,
    );
  }

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
    resourceCost,
    remainingUses,
    maxUses,
  ];
}
