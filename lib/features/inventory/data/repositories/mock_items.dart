import 'package:dnd_app/core/constants/damage_type.dart';

import '../../../../core/constants/attributes.dart';
import '../../domain/entities/armor.dart';
import '../../domain/entities/equipment_slot.dart';
import '../../domain/entities/gear.dart';
import '../../domain/entities/weapon.dart';

// --- ARMAS ---
const Weapon weaponSable = Weapon(
  id: 'wpn_sable_01',
  name: 'Sable Oriental',
  description: 'Hoja curva ideal para danzas letales.',
  weight: 3.0,
  damageDice: '1d8',
  damageType: DamageType.slashing,
  attribute: Attribute.dexterity, // Finesse
  slot: EquipmentSlot.mainHand,
  isEquipped: true,
  isProficient: true,
);

const Weapon weaponScimitar = Weapon(
  id: 'wpn_sable_02',
  name: 'Espada',
  description: 'Hoja curva ideal para danzas letales.',
  weight: 3.0,
  damageDice: '1d8',
  damageType: DamageType.slashing,
  attribute: Attribute.dexterity,
  slot: EquipmentSlot.mainHand,
  isEquipped: false,
  isProficient: true,
);

const Weapon weaponDagger = Weapon(
  id: 'wpn_daga_elfica',
  name: 'Daga Élfica (Dafne)',
  description:
      'Brilla tenuemente ante la presencia de orcos. Recuerdo de Dafne.',
  weight: 1.0,
  damageDice: '1d4',
  damageType: DamageType.piercing,
  attribute: Attribute.dexterity,
  slot: EquipmentSlot.offHand, // Dual wielding
  isEquipped: true,
  isProficient: true,
);

// --- ARMADURA ---
const Armor armorLeather = Armor(
  id: 'arm_leather_01',
  name: 'Armadura de Cuero',
  description: 'Cuero curtido y flexible.',
  weight: 10.0,
  armorClassBonus: 11,
  armorType: ArmorType.light,
  slot: EquipmentSlot.armor,
  isEquipped: true,
);

// --- OTROS (GEAR) ---
const Gear gearLute = Gear(
  id: 'gear_lute',
  name: 'Laúd de Madera Oscura',
  description: 'Instrumento finamente tallado. Tiene una cuerda rota.',
  weight: 2.0,
);

const Gear gearDice = Gear(
  id: 'gear_dice',
  name: 'Dado Trucado',
  description: 'Siempre cae en 6 si lo lanzas con el giro correcto.',
  weight: 0.0,
);

// Lista completa para exportar si se necesita
final List<dynamic> allMockItems = <dynamic>[
  weaponSable,
  weaponDagger,
  armorLeather,
  gearLute,
  gearDice,
];
