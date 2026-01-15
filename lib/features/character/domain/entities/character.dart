// features/character/domain/entities/character.dart

// Core Imports
import 'package:dnd_app/core/constants/attributes.dart';
import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:dnd_app/core/constants/skills.dart';
import 'package:dnd_app/core/constants/standard_actions.dart';
import 'package:dnd_app/features/character/data/datasources/character_ability_local_data_source.dart';
// Data Imports (Excepción controlada para Static Registry)
import 'package:dnd_app/features/character/domain/entities/character_ability.dart';
// Feature Imports
import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/character/domain/entities/character_resource.dart';
import 'package:dnd_app/features/character/domain/entities/resource_cost.dart';
import 'package:dnd_app/features/inventory/domain/entities/armor.dart';
import 'package:dnd_app/features/inventory/domain/entities/item.dart';
import 'package:dnd_app/features/inventory/domain/entities/weapon.dart';
import 'package:dnd_app/features/spells/domain/entities/spell.dart';
import 'package:equatable/equatable.dart';

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

  final Attribute? spellcastingAbility;

  final List<Attribute> proficientSaves;
  final String description;
  final String imageUrl;
  final List<Skill> proficientSkills;
  final List<Skill> expertSkills;
  final int speed;
  final bool hasJackOfAllTrades;

  // --- INVENTARIO ---
  final List<Item> inventory;

  // --- DEFENSAS ---
  final List<DamageType> resistances;
  final List<DamageType> immunities;
  final List<DamageType> vulnerabilities;

  // --- FAVORITOS ---
  final List<String> favoriteActionIds;

  // --- MAGIA ---
  final List<Spell> knownSpells;
  final Map<int, int> spellSlotsMax;
  final Map<int, int> spellSlotsCurrent;

  // --- RECURSOS ---
  final Map<String, CharacterResource> resources;

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
    this.spellcastingAbility,
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
    this.favoriteActionIds = const <String>[],
    this.knownSpells = const <Spell>[],
    this.spellSlotsMax = const <int, int>{},
    this.spellSlotsCurrent = const <int, int>{},
    this.resources = const <String, CharacterResource>{},
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

  // --- LÓGICA DE NEGOCIO (State Mutation Methods) ---

  /// Consume un recurso de clase (ej. Inspiración, Ki).
  /// Retorna una nueva instancia de Character.
  Character useResource(String resourceId) {
    if (!resources.containsKey(resourceId)) return this;

    final CharacterResource resource = resources[resourceId]!;
    if (resource.current <= 0) return this;

    // Actualizamos el recurso
    final CharacterResource updatedResource = resource.copyWith(
      current: resource.current - 1,
    );

    // Creamos nuevo mapa inmutable
    final Map<String, CharacterResource> newResources = Map.of(resources);
    newResources[resourceId] = updatedResource;

    return copyWith(resources: newResources);
  }

  /// Consume una unidad de un item del inventario.
  /// Retorna una nueva instancia de Character.
  Character consumeItem(String itemId) {
    final int index = inventory.indexWhere((Item i) => i.id == itemId);
    if (index == -1) return this;

    final Item item = inventory[index];
    if (item.quantity <= 0) return this;

    // Usamos el método abstracto copyWith para actualizar cantidad
    final Item updatedItem = item.copyWith(quantity: item.quantity - 1);

    // Reconstruimos la lista de inventario
    final List<Item> newInventory = List.of(inventory);
    newInventory[index] = updatedItem;

    return copyWith(inventory: newInventory);
  }

  // --- SISTEMA DE DESCANSO ---

  /// DESCANSAR LARGO (8h):
  /// - Recupera toda la vida.
  /// - Recupera todos los Spell Slots.
  /// - Recupera todos los Recursos (sin importar su regla).
  Character recoverLongRest() {
    // 1. Recuperar Recursos (Inspiración, etc.)
    final Map<String, CharacterResource> refreshedResources =
        <String, CharacterResource>{};

    for (final MapEntry<String, CharacterResource> entry in resources.entries) {
      // Descanso largo
      refreshedResources[entry.key] = entry.value.copyWith(
        current: entry.value.max,
      );
    }

    // 2. Recuperar Espacios de Conjuro (Reset total)
    // Copiamos el mapa de Máximos al de Actuales
    final Map<int, int> refreshedSlots = Map.of(spellSlotsMax);

    return copyWith(
      currentHp: maxHp, // Vida a tope
      spellSlotsCurrent: refreshedSlots,
      resources: refreshedResources,
    );
  }

  // Descanso corto:
  Character recoverShortRest() {
    final Map<String, CharacterResource> refreshedResources = Map.of(resources);

    for (final MapEntry<String, CharacterResource> entry in resources.entries) {
      // Solo recuperamos si la regla es ShortRest
      if (entry.value.refresh == RefreshRule.shortRest) {
        refreshedResources[entry.key] = entry.value.copyWith(
          current: entry.value.max,
        );
      }
    }

    return copyWith(resources: refreshedResources);
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

  // --- LÓGICA DE INVENTARIO ---
  List<Weapon> get weapons => inventory.whereType<Weapon>().toList();
  List<Weapon> get equippedWeapons =>
      weapons.where((Weapon w) => w.isEquipped).toList();
  Armor? get equippedArmor {
    final Iterable<Armor> armors = inventory.whereType<Armor>().where(
      (Armor a) => a.isEquipped,
    );
    return armors.isNotEmpty ? armors.first : null;
  }

  // --- LÓGICA DE COMBATE (FÍSICO) ---
  int getAttackBonus(Weapon weapon) {
    final int mod = getModifier(getScore(weapon.attribute));
    return mod + (weapon.isProficient ? proficiencyBonus : 0);
  }

  int getDamageModifier(Weapon weapon) {
    return getModifier(getScore(weapon.attribute));
  }

  // --- LÓGICA DE MAGIA (SPELLS) ---
  int get spellAttackBonus {
    if (spellcastingAbility == null) return 0;
    final int score = getScore(spellcastingAbility!);
    return getModifier(score) + proficiencyBonus;
  }

  int get spellSaveDC {
    if (spellcastingAbility == null) return 0;
    final int score = getScore(spellcastingAbility!);
    return 8 + getModifier(score) + proficiencyBonus;
  }

  // --- LÓGICA DE ACCIONES (Generador Dinámico) ---

  List<CharacterAction> get actions {
    final List<CharacterAction> computedActions = <CharacterAction>[];

    // 1. Armas
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
          imageUrl: null,
          resourceCost: null,
        ),
      );
    }

    // 2. Conjuros
    for (final Spell spell in knownSpells) {
      computedActions.add(_mapSpellToAction(spell));
    }

    // 3. Rasgos de Clase (Features)
    for (final MapEntry<String, CharacterResource> entry in resources.entries) {
      final String resourceId = entry.key;
      final CharacterAbility? definition =
          CharacterAbilityLocalDataSource.registry[resourceId];

      if (definition != null) {
        CharacterAction action = definition.actionTemplate;

        // --- LÓGICA DE ESCALADO GENÉRICA ---
        if (definition.levelScaling != null) {
          final List<int> applicableLevels = definition.levelScaling!.keys
              .where((int lvl) => level >= lvl)
              .toList();

          if (applicableLevels.isNotEmpty) {
            applicableLevels.sort();
            final int bestLevel = applicableLevels.last;
            final String newDice = definition.levelScaling![bestLevel]!;
            action = action.copyWith(diceNotation: newDice);
          }
        }

        action = action.copyWith(
          remainingUses: entry.value.current,
          maxUses: entry.value.max,
        );

        computedActions.add(action);
      }
    }
    // 4. Consumibles
    for (final Item item in inventory) {
      // Solo mostramos items consumibles que tengan stock
      if (item.isConsumable && item.quantity > 0) {
        computedActions.add(_mapConsumableToAction(item));
      }
    }

    // 5. Universales
    computedActions.addAll(StandardActions.all);

    // 6. Favoritos
    return computedActions.map((CharacterAction action) {
      final bool isFav = favoriteActionIds.contains(action.id);
      if (action.isFavorite == isFav) return action;
      return action.copyWith(isFavorite: isFav);
    }).toList();
  }

  // Adaptador Spell -> Action
  CharacterAction _mapSpellToAction(Spell spell) {
    final int? hitMod = spell.requiresAttackRoll ? spellAttackBonus : null;
    final ResourceCost? cost = spell.level > 0
        ? SpellSlotCost(spell.level)
        : null;

    return CharacterAction(
      id: spell.id,
      name: spell.name,
      description: spell.description,
      type: ActionType.spell,
      cost: spell.castTime,
      diceNotation: spell.damageDice,
      damageType: spell.damageType,
      toHitModifier: hitMod,
      imageUrl: null,
      resourceCost: cost,
    );
  }

  // Adaptador Item -> Action
  CharacterAction _mapConsumableToAction(Item item) {
    return CharacterAction(
      id: 'use_${item.id}',
      name: 'Usar ${item.name}',
      description: item.description,
      type: ActionType.utility,
      cost: ActionCost.action,
      resourceCost: ItemCost(item.id, amount: 1),
      imageUrl: null,
      remainingUses: item.quantity,
    );
  }

  // --- Helpers Skills ---
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
    Attribute? spellcastingAbility,
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
    List<Spell>? knownSpells,
    Map<int, int>? spellSlotsMax,
    Map<int, int>? spellSlotsCurrent,
    Map<String, CharacterResource>? resources,
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
      spellcastingAbility: spellcastingAbility ?? this.spellcastingAbility,
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
      knownSpells: knownSpells ?? this.knownSpells,
      spellSlotsMax: spellSlotsMax ?? this.spellSlotsMax,
      spellSlotsCurrent: spellSlotsCurrent ?? this.spellSlotsCurrent,
      resources: resources ?? this.resources,
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
    spellcastingAbility,
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
    knownSpells,
    spellSlotsMax,
    spellSlotsCurrent,
    resources,
  ];
}
