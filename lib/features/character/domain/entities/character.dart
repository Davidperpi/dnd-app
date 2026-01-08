import 'package:dnd_app/core/constants/attributes.dart';
import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:dnd_app/core/constants/skills.dart';
import 'package:equatable/equatable.dart';

/// Entidad de Dominio: Character
/// Representa al personaje puro, agnóstico de si viene de JSON, Firebase o SQL.
class Character extends Equatable {
  final String id;
  final String name;
  final String race;
  final String characterClass;
  final int level;

  // Stats (Value Objects simplificados)
  final int maxHp;
  final int currentHp;
  final int armorClass; // AC
  final int initiative; // Basado en Destreza

  // Ability Scores (Stats base)
  final int strength;
  final int dexterity;
  final int constitution;
  final int intelligence;
  final int wisdom;
  final int charisma;

  final List<Attribute> proficientSaves;

  final String description; // Lore
  final String imageUrl; // URL de la foto
  final List<Skill> proficientSkills; // Lista de skills entrenadas
  final List<Skill> expertSkills;

  final int speed;

  final bool hasJackOfAllTrades;

  // Inventario (Strings por ahora para el MVP)
  final List<String> equipment;

  final List<DamageType> resistances;
  final List<DamageType> immunities;
  final List<DamageType> vulnerabilities;

  const Character({
    required this.id,
    required this.name,
    required this.race,
    required this.characterClass,
    required this.level,
    required this.maxHp,
    required this.currentHp,
    required this.armorClass,
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
    this.equipment = const <String>[],
    this.resistances = const <DamageType>[],
    this.immunities = const <DamageType>[],
    this.vulnerabilities = const <DamageType>[],
  }) : assert(
         currentHp >= 0,
         'HP cannot be negative',
       ), // Validaciones de dominio
       assert(maxHp > 0, 'Max HP must be positive');

  // --- Domain Logic (Getters computados) ---
  // La UI nunca debe calcular esto, solo mostrarlo.

  bool get isDead => currentHp == 0;

  /// "Bloodied" es una regla de D&D 4e/5e (HP < 50%) útil para UI roja
  bool get isBloodied => currentHp <= (maxHp / 2) && currentHp > 0;

  /// Retorna un valor entre 0.0 y 1.0 para usar en LinearProgressIndicator
  double get healthPercentage => (currentHp / maxHp).clamp(0.0, 1.0);

  // Cálculo del modificador base: (16 - 10) / 2 = +3
  int getModifier(int score) => (score - 10) ~/ 2;

  // Cálculo del Bono de Competencia según nivel (Regla D&D 5e)
  // Nivel 1-4: +2, 5-8: +3, etc.
  int get proficiencyBonus => 2 + ((level - 1) ~/ 4);

  Map<Attribute, int> get abilityScores => <Attribute, int>{
    Attribute.strength: strength,
    Attribute.dexterity: dexterity,
    Attribute.constitution: constitution,
    Attribute.intelligence: intelligence,
    Attribute.wisdom: wisdom,
    Attribute.charisma: charisma,
  };

  // Ahora tu método de "negocio" es una sola línea, sin switch.
  // Usamos el operador [] porque estamos seguros de que el mapa tiene todas las claves.
  int getScore(Attribute attribute) => abilityScores[attribute]!;

  // Cálculo de la Salvación Total
  int getSavingThrow(Attribute attribute) {
    final int score = getScore(attribute);
    final int baseMod = getModifier(score);
    // Si la lista de competencias incluye este atributo, suma el bono
    final bool isProficient = proficientSaves.contains(attribute);
    return baseMod + (isProficient ? proficiencyBonus : 0);
  }

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

    // 1. Caso EXPERTISE (x2)
    if (expertSkills.contains(skill)) {
      return baseMod + (proficiencyBonus * 2);
    }

    // 2. Caso PROFICIENCY (x1)
    if (proficientSkills.contains(skill)) {
      return baseMod + proficiencyBonus;
    }

    // 3. Caso JACK OF ALL TRADES (x0.5)
    // Solo aplica si NO eres competente y tienes el flag activo
    if (hasJackOfAllTrades) {
      return baseMod + (proficiencyBonus ~/ 2); // División entera
    }

    // 4. Caso BASE (Solo atributo)
    return baseMod;
  }

  int get passivePerception => 10 + getSkillBonus(Skill.perception);

  // --- Helper: CopyWith ---
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
    List<String>? equipment,
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
      armorClass: armorClass ?? this.armorClass,
      initiative: initiative ?? this.initiative,
      strength: strength ?? this.strength,
      dexterity: dexterity ?? this.dexterity,
      constitution: constitution ?? this.constitution,
      intelligence: intelligence ?? this.intelligence,
      wisdom: wisdom ?? this.wisdom,
      charisma: charisma ?? this.charisma,
      proficientSaves: proficientSaves ?? this.proficientSaves,
      equipment: equipment ?? this.equipment,
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
  // Equatable: Importante añadir los nuevos campos aquí.
  // Si cambia la descripción o gana una skill nueva, BLoC debe saberlo.
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
    equipment,
    description,
    imageUrl,
    proficientSkills,
    expertSkills,
    speed,
    hasJackOfAllTrades,
    resistances,
    immunities,
    vulnerabilities,
  ];
}
