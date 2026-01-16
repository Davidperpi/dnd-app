import 'package:dnd_app/core/constants/attributes.dart';
import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:dnd_app/core/constants/skills.dart';
import 'package:dnd_app/features/character/domain/entities/character_feature.dart';
import 'package:dnd_app/features/character/domain/entities/character_resource.dart';
import 'package:dnd_app/features/inventory/data/datasources/mock_items_datasource.dart';
import 'package:dnd_app/features/inventory/domain/entities/item.dart';
import 'package:dnd_app/features/spells/data/datasources/mock_spells_datasource.dart';
import 'package:dnd_app/features/spells/domain/entities/spell.dart';

import '../../domain/entities/character.dart';

const int _charismaScore = 18;

const Character mockAidan = Character(
  id: 'aidan-001',
  name: 'Aidan',
  race: 'Humano',
  characterClass: 'Bard (College of Swords)',
  level: 5,
  maxHp: 29,
  currentHp: 29,
  initiative: 3,
  strength: 8,
  dexterity: 16,
  constitution: 12,
  intelligence: 10,
  wisdom: 12,
  charisma: _charismaScore,
  spellcastingAbility: Attribute.charisma,
  proficientSaves: <Attribute>[Attribute.dexterity, Attribute.charisma],
  inventory: <Item>[
    weaponSable,
    weaponDagger,
    weaponShortbow,
    weaponElvenDagger,
    armorStuddedLeather,
    armorBracersDexSave,
    armorInheritedRing,
    gearLute,
    gearDice,
    gearArrows,
    gearThievesTools
  ],
  knownSpells: <Spell>[
    cantripViciousMockery,
    cantripFriends,
    spellThunderwave,
    spellFeatherFall,
    spellHealingWord,
    spellHoldPerson,
    spellHeatMetal,
    spellHypnoticPattern,
    spellLeomundsTinyHut
  ],
  spellSlotsMax: <int, int>{1: 4, 2: 3, 3: 2},
  spellSlotsCurrent: <int, int>{
    1: 4, 
    2: 3,
    3: 2,
  },
  description:
      "Crecido en el teatro ambulante 'El Espejo de las Estrellas', Aidan aprendió pronto que la vida es una actuación. "
      "Tras la misteriosa desaparición de su amiga Dafne y la creciente oscuridad de su mentora Selana, huyó llevando consigo "
      "una daga élfica, un anillo de su pasado olvidado y un dado trucado robado a modo de despedida.\n\n"
      "Fue el viejo bardo Haldric quien pulió su talento en 'Los Hijos del Viento', enseñándole a mezclar acero y magia. "
      "Expulsado del Colegio de Bardos por defender su honor ante un noble arrogante, ahora viaja como un alma errante. "
      "Carismático, pragmático y alérgico a las ataduras, busca en Asbravn su próxima gran historia... o su próxima gran apuesta.",
  imageUrl: 'assets/images/aidan_portrait.jpeg',
  expertSkills: <Skill>[Skill.acrobatics, Skill.stealth],
  proficientSkills: <Skill>[Skill.survival],
  hasJackOfAllTrades: true,
  speed: 30,
  resistances: <DamageType>[],
  immunities: <DamageType>[],
  vulnerabilities: <DamageType>[],
  resources: <String, CharacterResource>{
    'bardic_inspiration': CharacterResource(
      id: 'bardic_inspiration',
      name: 'Inspiración Bárdica (d8)',
      max: (_charismaScore - 10) ~/ 2,
      current: (_charismaScore - 10) ~/ 2, 
      refresh: RefreshRule.longRest,
    ),
    'defensive_flourish': CharacterResource(
      id: 'defensive_flourish',
      name: 'Floritura Defensiva',
      max: 0,
      current: 0,
      refresh: RefreshRule.longRest,
    ),
    'slashing_flourish': CharacterResource(
      id: 'slashing_flourish',
      name: 'Floritura Ofensiva',
      max: 0,
      current: 0,
      refresh: RefreshRule.longRest,
    ),
    'mobile_flourish': CharacterResource(
      id: 'mobile_flourish',
      name: 'Floritura Móvil',
      max: 0,
      current: 0,
      refresh: RefreshRule.longRest,
    ),
     'song_of_rest': CharacterResource(
      id: 'song_of_rest',
      name: 'Canción de Descanso (d6)',
      max: 1,
      current: 1,
      refresh: RefreshRule.shortRest,
    ),
  },
  features: <CharacterFeature>[
    CharacterFeature(name: 'Lucha con Dos Armas', description: 'Cuando luchas con dos armas, puedes añadir tu modificador de característica al daño del segundo ataque.'),
    CharacterFeature(name: 'Pericia', description: 'Eliges dos de tus competencias de habilidad, y tu bonificador de competencia se duplica para cualquier prueba de característica que hagas usando cualquiera de las competencias elegidas.'),
    CharacterFeature(name: 'Jack of All Trades', description: 'Puedes sumar la mitad de tu bonificador de competencia, redondeado hacia abajo, a cualquier prueba de característica que hagas y que no sume ya tu bonificador de competencia.'),
  ]
);
