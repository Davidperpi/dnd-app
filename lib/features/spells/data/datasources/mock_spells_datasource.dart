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

const Spell cantripBladeWard = Spell(
  id: 'spell_blade_ward',
  name: 'Cuchilla Protectora',
  level: 0,
  school: MagicSchool.abjuration,
  castTime: ActionCost.action,
  range: 'Personal',
  components: <String>['V', 'S'],
  duration: '1 ronda',
  description:
      'Hasta el final de tu próximo turno, tienes resistencia al daño contundente, perforante y cortante de los ataques con armas.',
);

const Spell cantripFriends = Spell(
  id: 'spell_friends',
  name: 'Amigos',
  level: 0,
  school: MagicSchool.enchantment,
  castTime: ActionCost.action,
  range: 'Personal',
  components: <String>['S', 'M'],
  duration: '1 minuto',
  concentration: true,
  description:
      'Ganas ventaja en las pruebas de Carisma contra una criatura que no sea hostil. Cuando el conjuro termina, la criatura se da cuenta y se vuelve hostil.',
);

const Spell cantripLight = Spell(
  id: 'spell_light',
  name: 'Luz',
  level: 0,
  school: MagicSchool.evocation,
  castTime: ActionCost.action,
  range: 'Toque',
  components: <String>['V', 'M'],
  duration: '1 hora',
  description:
      'Un objeto que tocas emite luz brillante en un radio de 20 pies y luz tenue 20 pies más allá.',
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
);

const Spell spellFeatherFall = Spell(
  id: 'spell_feather_fall',
  name: 'Caída de Pluma',
  level: 1,
  school: MagicSchool.transmutation,
  castTime: ActionCost.reaction,
  range: '60 pies',
  components: <String>['V', 'M'],
  duration: '1 minuto',
  description:
      'Hasta cinco criaturas que caen reducen su velocidad de caída a 60 pies por turno y no sufren daño por impacto.',
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
  damageType: DamageType.thunder,
  requiresSave: true,
);

// NIVEL 2
const Spell spellHoldPerson = Spell(
  id: 'spell_hold_person',
  name: 'Inmovilizar Persona',
  level: 2,
  school: MagicSchool.enchantment,
  castTime: ActionCost.action,
  range: '60 pies',
  components: <String>['V', 'S', 'M'],
  duration: '1 minuto',
  concentration: true,
  description:
      'Un humanoide debe superar una salvación de Sabiduría o queda paralizado mientras te concentres.',
  requiresSave: true,
);

const Spell spellHeatMetal = Spell(
  id: 'spell_heat_metal',
  name: 'Calentar Metal',
  level: 2,
  school: MagicSchool.transmutation,
  castTime: ActionCost.action,
  range: '60 pies',
  components: <String>['V', 'S', 'M'],
  duration: '1 minuto',
  concentration: true,
  description:
      'Un objeto metálico fabricado que puedas ver se calienta al rojo vivo. Si una criatura lo lleva o lo viste, recibe 2d8 de daño por fuego y debe soltarlo o tener desventaja.',
  damageDice: '2d8',
  damageType: DamageType.fire,
  requiresSave: true, // Constitución para no soltarlo
);

const Spell spellPhantasmalForce = Spell(
  id: 'spell_phantasmal_force',
  name: 'Fuerza Fantasmal',
  level: 2,
  school: MagicSchool.illusion,
  castTime: ActionCost.action,
  range: '60 pies',
  components: <String>['V', 'S', 'M'],
  duration: '1 minuto',
  concentration: true,
  description:
      'Creas una ilusión en la mente de una criatura que solo ella puede percibir. La criatura racionaliza cualquier inconsistencia e incluso puede recibir daño psíquico.',
  damageDice: '1d6',
  damageType: DamageType.psychic,
  requiresSave: true, // Inteligencia
);


// NIVEL 3
const Spell spellHypnoticPattern = Spell(
  id: 'spell_hypnotic_pattern',
  name: 'Patrón Hipnótico',
  level: 3,
  school: MagicSchool.illusion,
  castTime: ActionCost.action,
  range: '120 pies',
  components: <String>['S', 'M'],
  duration: '1 minuto',
  concentration: true,
  description:
      'Creas un patrón de colores en un cubo de 30 pies. Las criaturas que lo vean deben salvar Sabiduría o quedarán incapacitadas y hechizadas.',
  requiresSave: true,
);

const Spell spellLeomundsTinyHut = Spell(
  id: 'spell_leomunds_tiny_hut',
  name: 'Pequeña Choza de Leomund',
  level: 3,
  school: MagicSchool.evocation,
  castTime: ActionCost.action, // Ritual
  range: 'Personal (hemisferio de 10 pies)',
  components: <String>['V', 'S', 'M'],
  duration: '8 horas',
  isRitual: true,
  description:
      'Creas una cúpula de fuerza inmóvil que protege a los que están dentro. Solo se puede lanzar como ritual.',
);
