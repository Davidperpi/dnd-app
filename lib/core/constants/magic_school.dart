// domain/entities/magic_school.dart
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

extension MagicSchoolExt on MagicSchool {
  String get nameEs => switch (this) {
    MagicSchool.evocation => 'Evocación',
    MagicSchool.illusion => 'Ilusión',

    _ => name.toUpperCase(),
  };
}
