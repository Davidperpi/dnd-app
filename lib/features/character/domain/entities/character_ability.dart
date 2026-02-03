import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/character/domain/entities/character_resource.dart';

/// Defines a specific ability, trait, or skill of a character.
///
/// Abilities are the static representation of what a character CAN do,
/// such as "Bardic Inspiration" or "Second Wind". They do not represent the use
/// of the ability itself, but its definition according to the rules.
class CharacterAbility {
  /// The unique identifier for the ability (e.g., 'bardic_inspiration').
  final String id;

  /// The full, readable name of the ability (e.g., 'Bardic Inspiration').
  final String name;

  /// An optional short name or abbreviation (e.g., 'BI').
  final String? shortName;

  /// The full description of what the ability does and its rules.
  final String description;

  /// The level at which the ability is acquired. Optional.
  final int? level;

  /// The rule that determines when the uses of this ability are recharged
  /// (e.g., after a short or long rest).
  final RefreshRule refreshRule;

  /// A template for the action the character can perform using this ability.
  /// Defines the cost (action, bonus action), type, and other details.
  /// It is optional for passive abilities that do not have an associated action.
  final CharacterAction? actionTemplate;

  /// An optional map that defines how the ability scales with level.
  ///
  /// The key is the level at which the change occurs, and the value is a
  /// description of the new effect or an updated value (e.g., {5: '1d8', 10: '1d10'}).
  final Map<int, String>? levelScaling;

  const CharacterAbility({
    required this.id,
    required this.name,
    this.shortName,
    required this.description,
    this.level,
    required this.refreshRule,
    this.actionTemplate,
    this.levelScaling,
  });
}
