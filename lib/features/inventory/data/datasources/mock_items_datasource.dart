import 'package:dnd_app/core/constants/damage_type.dart';

import '../../../../core/constants/attributes.dart';
import '../../domain/entities/armor.dart';
import '../../domain/entities/equipment_slot.dart';
import '../../domain/entities/gear.dart';
import '../../domain/entities/weapon.dart';

// --- ARMAS ---
const Weapon weaponSable = Weapon(
  id: 'wpn_sable_01',
  name: 'Sable',
  description: 'Hoja curva y elegante, perfecta para un bardo de espadas.',
  weight: 3.0,
  damageDice: '1d8',
  damageType: DamageType.slashing,
  attribute: Attribute.dexterity, // Finesse
  slot: EquipmentSlot.mainHand,
  isEquipped: true,
  isProficient: true,
);

const Weapon weaponDagger = Weapon(
  id: 'wpn_daga_01',
  name: 'Daga',
  description: 'Una daga de acero simple y fiable.',
  weight: 1.0,
  damageDice: '1d4',
  damageType: DamageType.piercing,
  attribute: Attribute.dexterity, // Finesse, arrojadiza
  slot: EquipmentSlot.offHand,
  isEquipped: true,
  isProficient: true,
);

const Weapon weaponElvenDagger = Weapon(
  id: 'wpn_daga_elfica_01',
  name: 'Daga Élfica (Dafne)',
  description:
      'Brilla tenuemente ante la presencia de orcos. Un recuerdo de tu amiga desaparecida, Dafne.',
  weight: 1.0,
  damageDice: '1d4',
  damageType: DamageType.piercing,
  attribute: Attribute.dexterity,
  slot: EquipmentSlot.offHand,
  isEquipped: false,
  isProficient: true,
);

const Weapon weaponShortbow = Weapon(
  id: 'wpn_arco_corto_01',
  name: 'Arco Corto',
  description: 'Un arco corto de madera, fácil de transportar.',
  weight: 2.0,
  damageDice: '1d6',
  damageType: DamageType.piercing,
  attribute: Attribute.dexterity,
  isEquipped: false,
  isProficient: true,
);

// --- ARMADURA ---
const Armor armorStuddedLeather = Armor(
  id: 'arm_studded_leather_01',
  name: 'Armadura de Cuero Tachonado',
  description: 'Cuero flexible reforzado con remaches de metal.',
  weight: 13.0,
  armorClassBonus: 12, // AC = 12 + DEX
  armorType: ArmorType.light,
  slot: EquipmentSlot.armor,
  isEquipped: true,
);

const Armor armorBracersDexSave = Armor(
  id: 'gear_bracers_dex_save_01',
  name: 'Brazales de Salvación +1 DES',
  description: 'Confiere un bonificador de +1 a las tiradas de salvación de Destreza.',
  weight: 1.0,
  armorClassBonus: 0,
  armorType: ArmorType.light,
  slot: EquipmentSlot.hands,
  isEquipped: true,
);

const Armor armorInheritedRing = Armor(
  id: 'gear_ring_01',
  name: 'Anillo Heredado',
  description: 'Un anillo de plata con un blasón familiar que no reconoces.',
  weight: 0.0,
  isEquipped: true,
  slot: EquipmentSlot.ring, armorClassBonus: 0, armorType: ArmorType.light,
);

// --- OTROS (GEAR) ---
const Gear gearLute = Gear(
  id: 'gear_lute_haldric',
  name: 'Laúd de Haldric',
  description: 'El laúd que te entregó tu mentor. Finamente tallado, parece contener secretos.',
  weight: 2.0,
);

const Gear gearDice = Gear(
  id: 'gear_dice',
  name: 'Dado Trucado',
  description: 'Siempre cae en 6 si lo lanzas con el giro correcto.',
  weight: 0.0,
);

const Gear gearMoonPendant = Gear(
  id: 'gear_moon_pendant_01',
  name: 'Colgante de la Luna',
  description: 'Un colgante de piedra lunar que vibra con una extraña energía. Lo usaste para activar un ascensor en el Underdark.',
  weight: 0.5,
);

const Gear gearCloak = Gear(
  id: 'gear_cloak_01',
  name: 'Capa de Viajero',
  description: 'Una capa de lana gruesa, útil para protegerse del frío y la lluvia.',
  weight: 4.0,
);

const Gear gearThievesTools = Gear(
  id: 'gear_thieves_tools_01',
  name: 'Ganzúas',
  description: '',
  weight: 1.0,
  quantity: 3,
  isConsumable: true,
);

const Gear gearArrows = Gear(
  id: 'gear_arrows_01',
  name: 'Flechas',
  description: 'Una flecha',
  weight: 1.0,
  quantity: 20,
  isConsumable: true
);

const Gear gearBedroll = Gear(
  id: 'gear_bedroll_01',
  name: 'Saco de Dormir',
  description: 'Un saco de dormir de lana enrollado.',
  weight: 7.0,
);

const Gear gearRations = Gear(
  id: 'gear_rations_01',
  name: 'Raciones de Viaje',
  description: 'Comida seca para 5 días.',
  weight: 2.0,
  quantity: 5,
);

const Gear gearTorches = Gear(
  id: 'gear_torches_01',
  name: 'Antorchas',
  description: 'Un paquete de 10 antorchas.',
  weight: 10.0,
  quantity: 10,
);

// Lista completa para exportar si se necesita
final List<dynamic> allMockItems = <dynamic>[
  weaponSable,
  weaponDagger,
  weaponElvenDagger,
  weaponShortbow,
  armorStuddedLeather,
  armorInheritedRing,
  armorBracersDexSave,
  gearLute,
  gearDice,
  gearMoonPendant,
  gearCloak,
  gearThievesTools,
  gearArrows,
  gearBedroll,
  gearRations,
  gearTorches,
];
