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

    'song_of_rest': const CharacterAbility(
      id: 'song_of_rest',
      name: 'Canción de Descanso',
      shortName: 'CD',
      description:
          'Durante un descanso corto, tú y tus aliados recuperáis 1d6 puntos de golpe adicionales si gastáis dados de golpe.',
      refreshRule: RefreshRule.passive,
      level: 2,
      levelScaling: <int, String>{2: '1d6', 9: '1d8', 13: '1d10', 17: '1d12'},
    ),

    'jack_of_all_trades': const CharacterAbility(
      id: 'jack_of_all_trades',
      name: 'Tirado para Todo',
      description:
          'Puedes añadir la mitad de tu bonificador de competencia a cualquier prueba de característica en la que no seas competente.',
      refreshRule: RefreshRule.passive,
      level: 2,
    ),

    'expertise': const CharacterAbility(
      id: 'expertise',
      name: 'Pericia',
      description:
          'Elige dos de tus habilidades competentes. Tu bonificador de competencia se duplica para cualquier prueba de característica que hagas con ellas.',
      refreshRule: RefreshRule.passive,
      level: 3,
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

  };
}
