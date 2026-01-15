import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/character/domain/entities/character_resource.dart'; // Para RefreshRule

class FeatureDefinition {
  final String id;
  final String name;
  final String? shortName;
  final String description;
  final RefreshRule refreshRule;
  final CharacterAction actionTemplate;
  final Map<int, String>? levelScaling;

  const FeatureDefinition({
    required this.id,
    required this.name,
    this.shortName,
    required this.description,
    required this.refreshRule,
    required this.actionTemplate,
    this.levelScaling,
  });
}
