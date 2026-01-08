// Core Imports
import 'package:dnd_app/core/constants/attributes.dart';
import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:dnd_app/core/constants/skills.dart';
import 'package:equatable/equatable.dart';

import '../../../inventory/domain/entities/armor.dart';
// Inventory Feature Imports (Asegúrate de que la ruta relativa sea correcta)
// Dado que character y inventory son hermanos en 'features/', subimos 3 niveles:
import '../../../inventory/domain/entities/item.dart';
import '../../../inventory/domain/entities/weapon.dart' hide DamageType;

class Character extends Equatable {
  final String id;
  final String name;
  final String race;
  final String characterClass;
  final int level;

  // Stats
  final int maxHp;
  final int currentHp;
  final int initiative;

  // Ability Scores
  final int strength;
  final int dexterity;
  final int constitution;
  final int intelligence;
  final int wisdom;
  final int charisma;

  final List<Attribute> proficientSaves;
  final String description;
  final String imageUrl;
  final List<Skill> proficientSkills;
  final List<Skill> expertSkills;
  final int speed;
  final bool hasJackOfAllTrades;

  // --- NUEVO SISTEMA DE INVENTARIO ---
  // Ya no usamos List<String>. Ahora es la Single Source of Truth.
  final List<Item> inventory;

  final List<DamageType> resistances;
  final List<DamageType> immunities;
  final List<DamageType> vulnerabilities;

  int get armorClass {
    int baseAC = 10;
    final int dexMod = getModifier(dexterity);

    // 1. Buscamos armadura equipada (Slot.armor)
    final Armor? armor =
        equippedArmor; // Usamos el getter que ya tenías o creamos uno

    if (armor != null) {
      baseAC = armor
          .armorClassBonus; // En D&D 5e, la armadura establece la base (ej. Leather = 11)

      // Aplicamos reglas de Dex según tipo
      switch (armor.armorType) {
        case ArmorType.light:
          baseAC += dexMod; // Full Dex
          break;
        case ArmorType.medium:
          // Máximo +2 de Dex
          baseAC += (dexMod > 2 ? 2 : dexMod);
          break;
        case ArmorType.heavy:
          // No suma Dex
          break;
        case ArmorType.shield:
          // El escudo se suma aparte, no define la base
          break;
      }
    } else {
      // Sin armadura: 10 + Dex
      baseAC += dexMod;
      // (Aquí iría Unarmored Defense de Monje/Bárbaro en el futuro)
    }

    // 2. Buscamos Escudos equipados (Cualquier item Armor que sea tipo Shield)
    // Nota: equippedItems es un getter que retorna List<Item>
    final bool hasShield = inventory.any(
      (Item i) => i is Armor && i.isEquipped && i.armorType == ArmorType.shield,
    );

    if (hasShield) {
      baseAC += 2;
    }

    // (Aquí sumaríamos anillos de protección, etc.)

    return baseAC;
  }

  const Character({
    required this.id,
    required this.name,
    required this.race,
    required this.characterClass,
    required this.level,
    required this.maxHp,
    required this.currentHp,
    required this.initiative,
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
    required this.proficientSaves,
    required this.description,
    required this.imageUrl,
    required this.proficientSkills,
    required this.expertSkills,
    required this.speed,
    this.hasJackOfAllTrades = false,
    this.inventory = const <Item>[], // Default vacío
    this.resistances = const <DamageType>[],
    this.immunities = const <DamageType>[],
    this.vulnerabilities = const <DamageType>[],
  }) : assert(currentHp >= 0, 'HP cannot be negative'),
       assert(maxHp > 0, 'Max HP must be positive');

  // --- Domain Logic (Getters computados) ---

  bool get isDead => currentHp == 0;
  bool get isBloodied => currentHp <= (maxHp / 2) && currentHp > 0;
  double get healthPercentage => (currentHp / maxHp).clamp(0.0, 1.0);

  int getModifier(int score) => (score - 10) ~/ 2;
  int get proficiencyBonus => 2 + ((level - 1) ~/ 4);

  Map<Attribute, int> get abilityScores => <Attribute, int>{
    Attribute.strength: strength,
    Attribute.dexterity: dexterity,
    Attribute.constitution: constitution,
    Attribute.intelligence: intelligence,
    Attribute.wisdom: wisdom,
    Attribute.charisma: charisma,
  };

  int getScore(Attribute attribute) => abilityScores[attribute]!;

  int getSavingThrow(Attribute attribute) {
    final int score = getScore(attribute);
    final int baseMod = getModifier(score);
    final bool isProficient = proficientSaves.contains(attribute);
    return baseMod + (isProficient ? proficiencyBonus : 0);
  }

  // --- NUEVA LÓGICA DE COMBATE E INVENTARIO ---

  /// Filtra y devuelve solo los items que son Armas
  List<Weapon> get weapons => inventory.whereType<Weapon>().toList();

  /// Devuelve las armas actualmente equipadas (Listas para la Action Tab)
  List<Weapon> get equippedWeapons =>
      weapons.where((Weapon w) => w.isEquipped).toList();

  /// Devuelve la armadura equipada (si la hay)
  Armor? get equippedArmor {
    final Iterable<Armor> armors = inventory.whereType<Armor>().where(
      (Armor a) => a.isEquipped,
    );
    return armors.isNotEmpty ? armors.first : null;
  }

  /// Calcula el bono de ataque (+Hit) para un arma específica
  int getAttackBonus(Weapon weapon) {
    final int mod = getModifier(getScore(weapon.attribute));
    // Si el personaje es competente con el arma, suma el bono de competencia
    // (Asumimos que si está en la lista weapon.isProficient es true por defecto o viene del item)
    return mod + (weapon.isProficient ? proficiencyBonus : 0);
  }

  /// Calcula el modificador de daño para un arma
  int getDamageModifier(Weapon weapon) {
    // Por defecto en 5e, sumas el modificador del atributo al daño
    // (A menos que sea off-hand sin estilo de combate, pero eso es lógica avanzada para v2)
    return getModifier(getScore(weapon.attribute));
  }

  // --- LÓGICA DE SKILLS (Sin cambios) ---

  Attribute getAttributeForSkill(Skill skill) {
    return switch (skill) {
      Skill.athletics => Attribute.strength,
      Skill.acrobatics ||
      Skill.sleightOfHand ||
      Skill.stealth => Attribute.dexterity,
      Skill.arcana ||
      Skill.history ||
      Skill.investigation ||
      Skill.nature ||
      Skill.religion => Attribute.intelligence,
      Skill.animalHandling ||
      Skill.insight ||
      Skill.medicine ||
      Skill.perception ||
      Skill.survival => Attribute.wisdom,
      Skill.deception ||
      Skill.intimidation ||
      Skill.performance ||
      Skill.persuasion => Attribute.charisma,
    };
  }

  int getSkillBonus(Skill skill) {
    final Attribute associatedAttr = getAttributeForSkill(skill);
    final int baseMod = getModifier(getScore(associatedAttr));

    if (expertSkills.contains(skill)) return baseMod + (proficiencyBonus * 2);
    if (proficientSkills.contains(skill)) return baseMod + proficiencyBonus;
    if (hasJackOfAllTrades) return baseMod + (proficiencyBonus ~/ 2);
    return baseMod;
  }

  int get passivePerception => 10 + getSkillBonus(Skill.perception);

  // --- CopyWith Actualizado ---
  Character copyWith({
    String? id,
    String? name,
    String? race,
    String? characterClass,
    int? level,
    int? maxHp,
    int? currentHp,
    int? armorClass,
    int? initiative,
    int? strength,
    int? dexterity,
    int? constitution,
    int? intelligence,
    int? wisdom,
    int? charisma,
    int? speed,
    List<Item>? inventory, // <--- CAMBIO AQUÍ
    List<Attribute>? proficientSaves,
    String? description,
    String? imageUrl,
    List<Skill>? proficientSkills,
    List<Skill>? expertSkills,
    bool? hasJackOfAllTrades,
    List<DamageType>? resistances,
    List<DamageType>? immunities,
    List<DamageType>? vulnerabilities,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      race: race ?? this.race,
      characterClass: characterClass ?? this.characterClass,
      level: level ?? this.level,
      maxHp: maxHp ?? this.maxHp,
      currentHp: currentHp ?? this.currentHp,
      initiative: initiative ?? this.initiative,
      strength: strength ?? this.strength,
      dexterity: dexterity ?? this.dexterity,
      constitution: constitution ?? this.constitution,
      intelligence: intelligence ?? this.intelligence,
      wisdom: wisdom ?? this.wisdom,
      charisma: charisma ?? this.charisma,
      proficientSaves: proficientSaves ?? this.proficientSaves,
      inventory: inventory ?? this.inventory,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      proficientSkills: proficientSkills ?? this.proficientSkills,
      expertSkills: expertSkills ?? this.expertSkills,
      speed: speed ?? this.speed,
      hasJackOfAllTrades: hasJackOfAllTrades ?? this.hasJackOfAllTrades,
      resistances: resistances ?? this.resistances,
      immunities: immunities ?? this.immunities,
      vulnerabilities: vulnerabilities ?? this.vulnerabilities,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id, name, race, characterClass, level, maxHp, currentHp, armorClass,
    initiative,
    strength,
    dexterity,
    constitution,
    intelligence,
    wisdom,
    charisma,
    proficientSaves, inventory, // <--- CAMBIO EN PROPS
    description, imageUrl, proficientSkills, expertSkills, speed,
    hasJackOfAllTrades, resistances, immunities, vulnerabilities,
  ];
}
