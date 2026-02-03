import 'package:dnd_app/core/constants/attributes.dart';
import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:dnd_app/core/constants/skills.dart';
import 'package:dnd_app/core/constants/standard_actions.dart';
import 'package:dnd_app/features/character/data/datasources/character_ability_local_data_source.dart';
import 'package:dnd_app/features/character/domain/entities/character_ability.dart';
import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/character/domain/entities/character_feature.dart';
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
  final int maxHp;
  final int currentHp;
  final int initiative;
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
  final List<CharacterFeature> features;
  final List<Item> inventory;
  final List<DamageType> resistances;
  final List<DamageType> immunities;
  final List<DamageType> vulnerabilities;
  final List<String> favoriteActionIds;
  final List<Spell> knownSpells;
  final Map<int, int> spellSlotsMax;
  final Map<int, int> spellSlotsCurrent;
  final Map<String, CharacterResource> resources;

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
    this.features = const <CharacterFeature>[],
    this.inventory = const <Item>[],
    this.resistances = const <DamageType>[],
    this.immunities = const <DamageType>[],
    this.vulnerabilities = const <DamageType>[],
    this.favoriteActionIds = const <String>[],
    this.knownSpells = const <Spell>[],
    this.spellSlotsMax = const <int, int>{},
    this.spellSlotsCurrent = const <int, int>{},
    this.resources = const <String, CharacterResource>{},
  })  : assert(currentHp >= 0, 'HP cannot be negative'),
        assert(maxHp > 0, 'Max HP must be positive');

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

  Character useResource(String resourceId) {
    if (!resources.containsKey(resourceId)) return this;

    final CharacterResource resource = resources[resourceId]!;
    if (resource.current <= 0) return this;

    final CharacterResource updatedResource = resource.copyWith(
      current: resource.current - 1,
    );

    final Map<String, CharacterResource> newResources = Map.of(resources);
    newResources[resourceId] = updatedResource;

    return copyWith(resources: newResources);
  }

  Character recoverLongRest() {
    final Map<String, CharacterResource> refreshedResources =
        <String, CharacterResource>{};

    for (final MapEntry<String, CharacterResource> entry in resources.entries) {
      refreshedResources[entry.key] = entry.value.copyWith(
        current: entry.value.max,
      );
    }

    final Map<int, int> refreshedSlots = Map.of(spellSlotsMax);

    return copyWith(
      currentHp: maxHp,
      spellSlotsCurrent: refreshedSlots,
      resources: refreshedResources,
    );
  }

  Character recoverShortRest() {
    final Map<String, CharacterResource> refreshedResources = Map.of(resources);

    for (final MapEntry<String, CharacterResource> entry in resources.entries) {
      if (entry.value.refresh == RefreshRule.shortRest) {
        refreshedResources[entry.key] = entry.value.copyWith(
          current: entry.value.max,
        );
      }
    }

    return copyWith(resources: refreshedResources);
  }

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

  List<Weapon> get weapons => inventory.whereType<Weapon>().toList();
  List<Weapon> get equippedWeapons =>
      weapons.where((Weapon w) => w.isEquipped).toList();
  Armor? get equippedArmor {
    final Iterable<Armor> armors = inventory
        .whereType<Armor>()
        .where((Armor a) => a.isEquipped && a.armorType != ArmorType.shield);
    return armors.isNotEmpty ? armors.first : null;
  }

  int getAttackBonus(Weapon weapon) {
    final int mod = getModifier(getScore(weapon.attribute));
    return mod + (weapon.isProficient ? proficiencyBonus : 0);
  }

  int getDamageModifier(Weapon weapon) {
    return getModifier(getScore(weapon.attribute));
  }

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

  List<CharacterAction> get actions {
    final List<CharacterAction> computedActions = <CharacterAction>[];

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

    for (final Spell spell in knownSpells) {
      computedActions.add(_mapSpellToAction(spell));
    }

    for (final MapEntry<String, CharacterResource> entry in resources.entries) {
      final String resourceId = entry.key;
      final CharacterAbility? definition =
          CharacterAbilityLocalDataSource.registry[resourceId];

      if (definition != null && definition.actionTemplate != null) {
        CharacterAction action = definition.actionTemplate!;

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
    for (final Item item in inventory) {
      if (item.isConsumable && item.quantity > 0) {
        computedActions.add(_mapConsumableToAction(item));
      }
    }

    computedActions.addAll(StandardActions.all);

    return computedActions.map((CharacterAction action) {
      final bool isFav = favoriteActionIds.contains(action.id);
      if (action.isFavorite == isFav) return action;
      return action.copyWith(isFavorite: isFav);
    }).toList();
  }

  CharacterAction _mapSpellToAction(Spell spell) {
    final int? hitMod = spell.requiresAttackRoll ? spellAttackBonus : null;
    final ResourceCost? cost =
        spell.level > 0 ? SpellSlotCost(spell.level) : null;

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

  Attribute getAttributeForSkill(Skill skill) {
    return switch (skill) {
      Skill.athletics => Attribute.strength,
      Skill.acrobatics ||
      Skill.sleightOfHand ||
      Skill.stealth =>
        Attribute.dexterity,
      Skill.arcana ||
      Skill.history ||
      Skill.investigation ||
      Skill.nature ||
      Skill.religion =>
        Attribute.intelligence,
      Skill.animalHandling ||
      Skill.insight ||
      Skill.medicine ||
      Skill.perception ||
      Skill.survival =>
        Attribute.wisdom,
      Skill.deception ||
      Skill.intimidation ||
      Skill.performance ||
      Skill.persuasion =>
        Attribute.charisma,
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
    List<CharacterFeature>? features,
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
      features: features ?? this.features,
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
        features,
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
