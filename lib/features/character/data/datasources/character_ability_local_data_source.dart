import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/character/domain/entities/character_resource.dart';
import 'package:dnd_app/features/character/domain/entities/character_ability.dart';
import 'package:dnd_app/features/character/domain/entities/resource_cost.dart';

/// Fuente de datos LOCAL que contiene el "Manual de Reglas" de las Habilidades de Personaje.
/// Actúa como un registro estático de definiciones.
class CharacterAbilityLocalDataSource {
  static final Map<String, CharacterAbility>
  registry = <String, CharacterAbility>{
    // --- HABILIDADES GENERALES DE BARDO ---
    'bardic_inspiration': const CharacterAbility(
      id: 'bardic_inspiration',
      name: 'Inspiración Bárdica',
      shortName: 'IB',
      description:
          'Puedes inspirar a otros como una acción adicional, o usar tus dados de inspiración para potenciar tus Florituras con la Espada.',
      refreshRule: RefreshRule.longRest, // Actualizado a 2024
      levelScaling: <int, String>{1: '1d6', 5: '1d8', 10: '1d10', 15: '1d12'},
    ),

    // --- BARDO (Colegio de las Espadas) ---
    'fighting_style_dueling': const CharacterAbility(
      id: 'fighting_style_dueling',
      name: 'Estilo de Combate: Duelo',
      description:
          'Cuando llevas un arma cuerpo a cuerpo en una mano y ninguna otra arma, ganas un +2 a las tiradas de daño con esa arma.',
      refreshRule: RefreshRule.passive,
      level: 3,
    ),

    'defensive_flourish': const CharacterAbility(
      id: 'defensive_flourish',
      name: 'Floritura Defensiva',
      description:
          'Puedes gastar un uso de Inspiración Bárdica para añadir el resultado del dado al daño. También sumas ese mismo resultado a tu CA hasta tu próximo turno.',
      refreshRule: RefreshRule.longRest,
      level: 3,
      actionTemplate: CharacterAction(
        id: 'use_defensive_flourish',
        name: 'Floritura Defensiva',
        description: 'Gasta una IB para añadir daño y CA.',
        type: ActionType.feature,
        cost: ActionCost.free, // Se activa al golpear
        resourceCost: FeatureResourceCost('bardic_inspiration'),
        imageUrl: 'assets/icons/defensive_flourish.png',
      ),
    ),

    'slashing_flourish': const CharacterAbility(
      id: 'slashing_flourish',
      name: 'Floritura Ofensiva',
      description:
          'Puedes gastar un uso de Inspiración Bárdica para añadir el resultado del dado al daño de tu ataque. Además, otras criaturas a 5 pies de ti reciben daño igual al resultado del dado.',
      refreshRule: RefreshRule.longRest,
      level: 3,
      actionTemplate: CharacterAction(
        id: 'use_slashing_flourish',
        name: 'Floritura Ofensiva',
        description: 'Gasta una IB para hacer daño en área.',
        type: ActionType.feature,
        cost: ActionCost.free, // Se activa al golpear
        resourceCost: FeatureResourceCost('bardic_inspiration'),
        imageUrl: 'assets/icons/slashing_flourish.png',
      ),
    ),

    'mobile_flourish': const CharacterAbility(
      id: 'mobile_flourish',
      name: 'Floritura Móvil',
      description:
          'Puedes gastar un uso de Inspiración Bárdica para añadir el resultado del dado al daño. Además, puedes empujar al objetivo una distancia igual a 5 + el resultado del dado. Puedes usar tu reacción para moverte a un espacio cercano al objetivo.',
      refreshRule: RefreshRule.longRest,
      level: 3,
      actionTemplate: CharacterAction(
        id: 'use_mobile_flourish',
        name: 'Floritura Móvil',
        description: 'Gasta una IB para añadir daño y movilidad.',
        type: ActionType.feature,
        cost: ActionCost.free, // Se activa al golpear
        resourceCost: FeatureResourceCost('bardic_inspiration'),
        imageUrl: 'assets/icons/mobile_flourish.png',
      ),
    ),
    
    'extra_attack': const CharacterAbility(
      id: 'extra_attack',
      name: 'Ataque Extra',
      description:
          'Puedes atacar dos veces, en lugar de una, siempre que realices la acción de Ataque en tu turno.',
      refreshRule: RefreshRule.passive,
      level: 6,
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
