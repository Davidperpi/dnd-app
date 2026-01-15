import 'package:dnd_app/core/constants/attributes.dart';
import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:dnd_app/core/constants/skills.dart';
import 'package:dnd_app/features/character/domain/entities/character_resource.dart';
import 'package:dnd_app/features/inventory/data/repositories/mock_items.dart';
import 'package:dnd_app/features/inventory/domain/entities/item.dart';
import 'package:dnd_app/features/spells/domain/data/mock_spells.dart';
import 'package:dnd_app/features/spells/domain/entities/spell.dart';

import '../../domain/entities/character.dart';

// --- PERSONAJE COMPLETO ---

const int _charismaScore = 18;

const Character mockAidan = Character(
  id: 'aidan-001',
  name: 'Aidan',
  race: 'Human',
  characterClass: 'Bard (College of Swords)',
  level: 5,
  maxHp: 29,
  currentHp: 21,
  initiative: 3,

  // Stats
  strength: 8,
  dexterity: 16,
  constitution: 12,
  intelligence: 10,
  wisdom: 12,
  charisma: _charismaScore,

  // MAGIA (NUEVO)
  spellcastingAbility: Attribute.charisma, // Carisma es su stat de magia

  proficientSaves: <Attribute>[Attribute.dexterity, Attribute.charisma],

  // INVENTARIO (Tus items existentes)
  inventory: <Item>[
    weaponSable,
    weaponDagger,
    armorLeather,
    gearLute,
    gearDice,
    weaponScimitar,
    potionHealing,
    potionInvisibility,
  ],

  // HECHIZOS CONOCIDOS (NUEVO)
  knownSpells: <Spell>[
    cantripViciousMockery,
    cantripMinorIllusion,
    spellHealingWord,
    spellDissonantWhispers,
    spellThunderwave,
    spellInvisibility,
    spellCloudOfDaggers,
  ],

  // SLOTS DE MAGIA (Nivel 5: 4 de Nivel 1, 3 de Nivel 2, 2 de Nivel 3)
  // Simulamos que ha gastado algunos
  spellSlotsMax: <int, int>{1: 4, 2: 3, 3: 2},
  spellSlotsCurrent: <int, int>{
    1: 3, // Gastó 1
    2: 1, // Gastó 2
    3: 2, // Llenos
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

  resistances: <DamageType>[DamageType.fire, DamageType.poison],
  immunities: <DamageType>[DamageType.acid],
  vulnerabilities: <DamageType>[DamageType.force],
  resources: <String, CharacterResource>{
    'bardic_inspiration': CharacterResource(
      id: 'bardic_inspiration',
      name: 'Inspiración Bárdica',
      max: (_charismaScore - 10) ~/ 2,
      current: 4,
      refresh: RefreshRule.shortRest,
    ),
  },
);
