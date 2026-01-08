import 'package:dnd_app/features/inventory/data/repositories/mock_items.dart';
import 'package:dnd_app/features/inventory/domain/entities/item.dart';

import '../../../../core/constants/attributes.dart';
import '../../../../core/constants/damage_type.dart';
import '../../../../core/constants/skills.dart';
// Importamos los items que acabamos de crear
import '../../domain/entities/character.dart';

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
  charisma: 18,

  proficientSaves: <Attribute>[Attribute.dexterity, Attribute.charisma],

  // AQUÍ ESTÁ LA MAGIA: Inyección de dependencias de datos
  inventory: <Item>[
    weaponSable,
    weaponDagger,
    armorLeather,
    gearLute,
    gearDice,
    weaponScimitar,
  ],

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
);
