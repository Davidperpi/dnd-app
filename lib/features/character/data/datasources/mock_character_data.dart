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
  race: 'Human',
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
      "Raised in the traveling theater 'The Star Mirror', Aidan soon learned that life is a performance. "
      "After the mysterious disappearance of his friend Dafne and the growing darkness of his mentor Selana, he fled, taking with him "
      "an elven dagger, a ring from his forgotten past, and a loaded die stolen as a farewell.\n\n"
      "It was the old bard Haldric who polished his talent in 'The Children of the Wind', teaching him to mix steel and magic. "
      "Expelled from the College of Bards for defending his honor against an arrogant noble, he now travels as a wandering soul. "
      "Charismatic, pragmatic, and allergic to attachments, he searches in Asbravn for his next great story... or his next big gamble.",
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
      name: 'Bardic Inspiration (d8)',
      max: (_charismaScore - 10) ~/ 2,
      current: (_charismaScore - 10) ~/ 2, 
      refresh: RefreshRule.longRest,
    ),
     'song_of_rest': CharacterResource(
      id: 'song_of_rest',
      name: 'Song of Rest (d6)',
      max: 1,
      current: 1,
      refresh: RefreshRule.shortRest,
    ),
  },
  features: <CharacterFeature>[
    CharacterFeature(name: 'Two-Weapon Fighting', description: 'When you engage in two-weapon fighting, you can add your ability modifier to the damage of the second attack.'),
    CharacterFeature(name: 'Expertise', description: 'Choose two of your skill proficiencies. Your proficiency bonus is doubled for any ability check you make that uses either of the chosen proficiencies.'),
    CharacterFeature(name: 'Jack of All Trades', description: 'You can add half your proficiency bonus, rounded down, to any ability check you make that doesn\'t already include your proficiency bonus.'),
  ]
);
