import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:dnd_app/features/character/domain/entities/resource_cost.dart';
import 'package:equatable/equatable.dart';

enum ActionType { attack, spell, feature, utility }

enum ActionCost { action, bonusAction, reaction, free }

/// Represents a specific, executable action that a character can perform in a turn.
///
/// Unlike [CharacterAbility], which is a static definition, [CharacterAction]
/// is a "computed" object that represents a concrete action ready to be used.
/// For example, it might represent a weapon attack with the hit bonus already
/// calculated, or a spell with its save DC.
class CharacterAction extends Equatable {
  /// The unique identifier for the action (e.g., 'atk_longsword', 'spl_fireball').
  final String id;

  /// The name of the action to be displayed (e.g., "Longsword Attack", "Fireball").
  final String name;

  /// The detailed description of the action's effects.
  final String description;

  /// The type of action, used for categorization (e.g., Attack, Spell).
  final ActionType type;

  /// The cost required to perform the action (e.g., Action, Bonus Action).
  final ActionCost cost;

  /// The cost in terms of character resources (e.g., spell slots, ki points). Optional.
  final ResourceCost? resourceCost;

  /// The dice notation for the damage or effect (e.g., "1d8 + 4"). Optional.
  final String? diceNotation;

  /// The type of damage inflicted by the action (e.g., Slashing, Fire). Optional.
  final DamageType? damageType;

  /// The modifier to add to the attack roll. Only for actions that require an attack. Optional.
  final int? toHitModifier;

  /// The number of uses currently available for this action. Optional.
  final int? remainingUses;

  /// The maximum number of uses for this action. Optional.
  final int? maxUses;

  /// URL or local path to an icon representing the action. Optional.
  final String? imageUrl;

  /// Indicates if the user has marked this action as a favorite.
  final bool isFavorite;

  const CharacterAction({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.cost,
    this.resourceCost,
    this.diceNotation,
    this.damageType,
    this.toHitModifier,
    this.remainingUses,
    this.maxUses,
    this.imageUrl,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        cost,
        resourceCost,
        diceNotation,
        damageType,
        toHitModifier,
        remainingUses,
        maxUses,
        imageUrl,
        isFavorite,
      ];

  CharacterAction copyWith({
    String? id,
    String? name,
    String? description,
    ActionType? type,
    ActionCost? cost,
    ResourceCost? resourceCost,
    String? diceNotation,
    DamageType? damageType,
    int? toHitModifier,
    int? remainingUses,
    int? maxUses,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return CharacterAction(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      cost: cost ?? this.cost,
      resourceCost: resourceCost ?? this.resourceCost,
      diceNotation: diceNotation ?? this.diceNotation,
      damageType: damageType ?? this.damageType,
      toHitModifier: toHitModifier ?? this.toHitModifier,
      remainingUses: remainingUses ?? this.remainingUses,
      maxUses: maxUses ?? this.maxUses,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
