import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/character/domain/entities/character_resource.dart';
import 'package:dnd_app/features/character/domain/entities/character_ability.dart';
import 'package:dnd_app/features/character/domain/entities/resource_cost.dart';

/// Fuente de datos LOCAL que contiene el "Manual de Reglas" de las Habilidades de Personaje.
/// Actúa como un registro estático de definiciones.
class CharacterAbilityLocalDataSource {
  static final Map<String, CharacterAbility>
  registry = <String, CharacterAbility>{
    // --- BARDO (Colegio de Espadas) ---
    'bardic_inspiration': const CharacterAbility(
      id: 'bardic_inspiration',
      name: 'Inspiración Bárdica',
      shortName: 'IB',
      description:
          'Como acción adicional, otorga un dado de inspiración a una criatura.',
      refreshRule: RefreshRule.shortRest,
      levelScaling: <int, String>{1: '1d6', 5: '1d8', 10: '1d10', 15: '1d12'},
      actionTemplate: CharacterAction(
        id: 'use_bardic_inspiration',
        name: 'Inspiración Bárdica',
        description: 'Otorga un dado extra a una tirada.',
        type: ActionType.feature,
        cost: ActionCost.bonusAction,
        resourceCost: FeatureResourceCost('bardic_inspiration'),
        imageUrl: 'assets/icons/inspiration.png',
      ),
    ),

    // --- GUERRERO (Ejemplo futuro) ---
    'second_wind': const CharacterAbility(
      id: 'second_wind',
      name: 'Tomar Aliento',
      description: 'Recuperas 1d10 + Nivel HP.',
      refreshRule: RefreshRule.shortRest,
      actionTemplate: CharacterAction(
        id: 'use_second_wind',
        name: 'Tomar Aliento',
        description: 'Recupera puntos de golpe en combate.',
        type: ActionType.utility,
        cost: ActionCost.bonusAction,
        resourceCost: FeatureResourceCost('second_wind'),
        diceNotation: '1d10',
      ),
    ),
  };
}
