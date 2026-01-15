import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/character/domain/entities/character_resource.dart';

/// Define una habilidad, rasgo o aptitud específica de un personaje.
///
/// Las habilidades son la representación estática de lo que un personaje PUEDE hacer,
/// como "Inspiración Bárdica" o "Tomar Aliento". No representan el uso
/// de la habilidad en sí, sino su definición según las reglas.
class CharacterAbility {
  /// El identificador único de la habilidad (ej: 'bardic_inspiration').
  final String id;

  /// El nombre completo y legible de la habilidad (ej: 'Inspiración Bárdica').
  final String name;

  /// Un nombre corto o abreviatura opcional (ej: 'IB').
  final String? shortName;

  /// La descripción completa de lo que hace la habilidad y sus reglas.
  final String description;

  /// El nivel en el que se adquiere la habilidad. Opcional.
  final int? level;

  /// La regla que determina cuándo se recargan los usos de esta habilidad
  /// (ej: después de un descanso corto o largo).
  final RefreshRule refreshRule;

  /// Una plantilla para la acción que el personaje puede ejecutar usando esta habilidad.
  /// Define el coste (acción, acción bonus), el tipo y otros detalles.
  /// Es opcional para habilidades pasivas que no tienen una acción asociada.
  final CharacterAction? actionTemplate;

  /// Un mapa opcional que define cómo escala la habilidad con el nivel.
  ///
  /// La clave es el nivel en el que ocurre el cambio, y el valor es una
  /// descripción del nuevo efecto o un valor actualizado (ej: {5: '1d8', 10: '1d10'}).
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
