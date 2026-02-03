enum Skill {
  acrobatics,
  animalHandling,
  arcana,
  athletics,
  deception,
  history,
  insight,
  intimidation,
  investigation,
  medicine,
  nature,
  perception,
  performance,
  persuasion,
  religion,
  sleightOfHand,
  stealth,
  survival,
}

extension SkillExtension on Skill {
  String get label {
    return switch (this) {
      Skill.acrobatics => 'ACROBACIAS',
      Skill.animalHandling => 'TRATO CON ANIMALES',
      Skill.arcana => 'ARCANO',
      Skill.athletics => 'ATLETISMO',
      Skill.deception => 'ENGAÑO',
      Skill.history => 'HISTORIA',
      Skill.insight => 'PERSPICACIA',
      Skill.intimidation => 'INTIMIDACIÓN',
      Skill.investigation => 'INVESTIGACIÓN',
      Skill.medicine => 'MEDICINA',
      Skill.nature => 'NATURALEZA',
      Skill.perception => 'PERCEPCIÓN',
      Skill.performance => 'INTERPRETACIÓN',
      Skill.persuasion => 'PERSUASIÓN',
      Skill.religion => 'RELIGIÓN',
      Skill.sleightOfHand => 'JUEGO DE MANOS',
      Skill.stealth => 'SIGILO',
      Skill.survival => 'SUPERVIVENCIA',
    };
  }
}
