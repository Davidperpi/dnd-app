/// Defines the different schools of magic in the game.
enum MagicSchool {
  abjuration,
  conjuration,
  divination,
  enchantment,
  evocation,
  illusion,
  necromancy,
  transmutation,
}

extension MagicSchoolExtension on MagicSchool {
  String get label {
    return switch (this) {
      MagicSchool.abjuration => 'ABJURACIÓN',
      MagicSchool.conjuration => 'CONJURACIÓN',
      MagicSchool.divination => 'ADIVINACIÓN',
      MagicSchool.enchantment => 'ENCANTAMIENTO',
      MagicSchool.evocation => 'EVOCACIÓN',
      MagicSchool.illusion => 'ILUSIÓN',
      MagicSchool.necromancy => 'NECROMANCIA',
      MagicSchool.transmutation => 'TRANSMUTACIÓN',
    };
  }
}
