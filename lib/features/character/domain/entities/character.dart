// Core Imports
import 'package:dnd_app/core/constants/attributes.dart';
import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:dnd_app/core/constants/skills.dart';
// Importamos las acciones estándar (Master Data)
import 'package:dnd_app/core/constants/standard_actions.dart';
import 'package:equatable/equatable.dart';

// Inventory Feature Imports
import '../../../inventory/domain/entities/armor.dart';
import '../../../inventory/domain/entities/item.dart';
// Ya no hace falta el 'hide' porque hemos borrado el enum duplicado en weapon.dart
import '../../../inventory/domain/entities/weapon.dart';
// Importamos la definición de Acción
import 'character_action.dart';

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

  // --- INVENTARIO ---
  final List<Item> inventory;

  final List<DamageType> resistances;
  final List<DamageType> immunities;
  final List<DamageType> vulnerabilities;

  // --- NUEVO: SISTEMA DE FAVORITOS ---
  final List<String> favoriteActionIds;

  // --- Constructor ---
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
    this.inventory = const <Item>[],
    this.resistances = const <DamageType>[],
    this.immunities = const <DamageType>[],
    this.vulnerabilities = const <DamageType>[],
    this.favoriteActionIds = const <String>[], // Default vacío
  }) : assert(currentHp >= 0, 'HP cannot be negative'),
       assert(maxHp > 0, 'Max HP must be positive');

  // --- Domain Logic (Getters computados) ---

  bool get isDead => currentHp == 0;
  bool get isBloodied => currentHp <= (maxHp / 2) && currentHp > 0;

  double get healthPercentage => (currentHp / maxHp).clamp(0.0, 1.0);

  // Helpers de Stats
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

  // --- LÓGICA DE ARMADURA (AC) ---
  int get armorClass {
    int baseAC = 10;
    final int dexMod = getModifier(dexterity);
    final Armor? armor = equippedArmor;

    if (armor != null) {
      baseAC = armor.armorClassBonus;
      switch (armor.armorType) {
        case ArmorType.light:
          baseAC += dexMod;
          break;
        case ArmorType.medium:
          baseAC += (dexMod > 2 ? 2 : dexMod);
          break;
        case ArmorType.heavy:
          break;
        case ArmorType.shield:
          break;
      }
    } else {
      baseAC += dexMod;
    }

    final bool hasShield = inventory.any(
      (Item i) => i is Armor && i.isEquipped && i.armorType == ArmorType.shield,
    );

    if (hasShield) baseAC += 2;
    return baseAC;
  }

  // --- LÓGICA DE INVENTARIO Y COMBATE ---

  List<Weapon> get weapons => inventory.whereType<Weapon>().toList();

  List<Weapon> get equippedWeapons =>
      weapons.where((Weapon w) => w.isEquipped).toList();

  Armor? get equippedArmor {
    final Iterable<Armor> armors = inventory.whereType<Armor>().where(
      (Armor a) => a.isEquipped,
    );
    return armors.isNotEmpty ? armors.first : null;
  }

  int getAttackBonus(Weapon weapon) {
    final int mod = getModifier(getScore(weapon.attribute));
    return mod + (weapon.isProficient ? proficiencyBonus : 0);
  }

  int getDamageModifier(Weapon weapon) {
    return getModifier(getScore(weapon.attribute));
  }

  // --- LÓGICA DE ACCIONES (Fase 1: Física y Universal + Favoritos) ---

  List<CharacterAction> get actions {
    final List<CharacterAction> computedActions = <CharacterAction>[];

    // 1. Acciones de Armas
    for (final Weapon weapon in equippedWeapons) {
      final int hitBonus = getAttackBonus(weapon);
      final int dmgMod = getDamageModifier(weapon);

      final String dmgSign = dmgMod >= 0 ? '+' : '-';
      final String finalDice = '${weapon.damageDice} $dmgSign ${dmgMod.abs()}';

      computedActions.add(
        CharacterAction(
          id: 'atk_${weapon.id}',
          name: weapon.name,
          description: weapon.description,
          type: ActionType.attack,
          cost: ActionCost.action,
          diceNotation: finalDice,
          damageType: weapon.damageType,
          toHitModifier: hitBonus,
          imageUrl: null, // Asumimos null por ahora (la UI pone icono)
        ),
      );
    }

    // 2. Acciones Universales (Desde Master Data)
    computedActions.addAll(StandardActions.all);

    // 3. APLICACIÓN DE FAVORITOS (Mapeo Final)
    // Cruzamos la lista generada con la lista de IDs favoritos del personaje
    return computedActions.map((action) {
      final bool isFav = favoriteActionIds.contains(action.id);

      // Si el estado de favorito coincide, devolvemos la instancia original (eficiencia)
      if (action.isFavorite == isFav) return action;

      // Si no, creamos una nueva instancia con el flag actualizado
      return CharacterAction(
        id: action.id,
        name: action.name,
        description: action.description,
        type: action.type,
        cost: action.cost,
        diceNotation: action.diceNotation,
        damageType: action.damageType,
        toHitModifier: action.toHitModifier,
        imageUrl: action.imageUrl,
        isFavorite: isFav,
      );
    }).toList();
  }

  // --- LÓGICA DE SKILLS (Helpers) ---

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

  // --- CopyWith ---
  Character copyWith({
    String? id,
    String? name,
    String? race,
    String? characterClass,
    int? level,
    int? maxHp,
    int? currentHp,
    int? initiative,
    int? strength,
    int? dexterity,
    int? constitution,
    int? intelligence,
    int? wisdom,
    int? charisma,
    List<Attribute>? proficientSaves,
    String? description,
    String? imageUrl,
    List<Skill>? proficientSkills,
    List<Skill>? expertSkills,
    int? speed,
    bool? hasJackOfAllTrades,
    List<Item>? inventory,
    List<DamageType>? resistances,
    List<DamageType>? immunities,
    List<DamageType>? vulnerabilities,
    List<String>? favoriteActionIds,
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
      favoriteActionIds: favoriteActionIds ?? this.favoriteActionIds,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    race,
    characterClass,
    level,
    maxHp,
    currentHp,
    armorClass,
    initiative,
    strength,
    dexterity,
    constitution,
    intelligence,
    wisdom,
    charisma,
    proficientSaves,
    inventory,
    description,
    imageUrl,
    proficientSkills,
    expertSkills,
    speed,
    hasJackOfAllTrades,
    resistances,
    immunities,
    vulnerabilities,
    favoriteActionIds,
  ];
}
