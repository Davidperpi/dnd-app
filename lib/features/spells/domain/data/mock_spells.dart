// TRUCOS
import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:dnd_app/core/constants/magic_school.dart';
import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/spells/domain/entities/spell.dart';

const Spell cantripViciousMockery = Spell(
  id: 'spell_vicious_mockery',
  name: 'Burla Dañina',
  level: 0,
  school: MagicSchool.enchantment,
  castTime: ActionCost.action,
  range: '60 pies',
  components: <String>['V'],
  duration: 'Instantánea',
  description:
      'Insultos entretejidos con magia sutil. Si falla la salvación (SAB), recibe daño y desventaja en su próximo ataque.',
  damageDice: '1d4',
  damageType: DamageType.psychic,
  requiresSave: true,
);

const Spell cantripMinorIllusion = Spell(
  id: 'spell_minor_illusion',
  name: 'Ilusión Menor',
  level: 0,
  school: MagicSchool.illusion,
  castTime: ActionCost.action,
  range: '30 pies',
  components: <String>['S', 'M'],
  duration: '1 minuto',
  description:
      'Creas un sonido o una imagen de un objeto inmóvil dentro del alcance.',
  requiresAttackRoll: false,
);

// NIVEL 1
const Spell spellHealingWord = Spell(
  id: 'spell_healing_word',
  name: 'Palabra de Curación',
  level: 1,
  school: MagicSchool.evocation,
  castTime: ActionCost.bonusAction,
  range: '60 pies',
  components: <String>['V'],
  duration: 'Instantánea',
  description:
      'Una criatura a tu elección recupera puntos de golpe iguales a 1d4 + mod de lanzamiento.',
  damageDice: '1d4',
  // No tiene damageType real porque cura, pero lo dejamos null o definimos 'healing' si tuviéramos ese tipo
);

const Spell spellDissonantWhispers = Spell(
  id: 'spell_dissonant_whispers',
  name: 'Susurros Disonantes',
  level: 1,
  school: MagicSchool.enchantment,
  castTime: ActionCost.action,
  range: '60 pies',
  components: <String>['V'],
  duration: 'Instantánea',
  description:
      'Melodía discordante que causa dolor y obliga a huir usando la reacción.',
  damageDice: '3d6',
  damageType: DamageType.psychic,
  requiresSave: true,
);

const Spell spellThunderwave = Spell(
  id: 'spell_thunderwave',
  name: 'Onda Atronadora',
  level: 1,
  school: MagicSchool.evocation,
  castTime: ActionCost.action,
  range: 'Personal (Cubo 15 pies)',
  components: <String>['V', 'S'],
  duration: 'Instantánea',
  description: 'Una onda de fuerza atronadora barre todo a tu alrededor.',
  damageDice: '2d8',
  damageType: DamageType
      .thunder, // Si no tienes 'thunder' en tu enum, usa 'force' o añade 'thunder'
  requiresSave: true,
);

// NIVEL 2
const Spell spellInvisibility = Spell(
  id: 'spell_invisibility',
  name: 'Invisibilidad',
  level: 2,
  school: MagicSchool.illusion,
  castTime: ActionCost.action,
  range: 'Toque',
  components: <String>['V', 'S', 'M'],
  duration: '1 hora',
  concentration: true,
  description:
      'Una criatura que tocas se vuelve invisible hasta que ataca o lanza un conjuro.',
);

const Spell spellCloudOfDaggers = Spell(
  id: 'spell_cloud_of_daggers',
  name: 'Nube de Dagas',
  level: 2,
  school: MagicSchool.conjuration,
  castTime: ActionCost.action,
  range: '60 pies',
  components: <String>['V', 'S', 'M'],
  duration: '1 minuto',
  concentration: true,
  description: 'Llenas el aire en un cubo de 5 pies con dagas giratorias.',
  damageDice: '4d4',
  damageType: DamageType.slashing,
  requiresSave: false, // Es daño automático al entrar/empezar turno
);
