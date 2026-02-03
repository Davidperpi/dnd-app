enum Attribute {
  strength('FUERZA', 'STR'),
  dexterity('DESTREZA', 'DEX'),
  constitution('CONSTITUCIÓN', 'CON'),
  intelligence('INTELIGENCIA', 'INT'),
  wisdom('SABIDURÍA', 'WIS'),
  charisma('CARISMA', 'CHA');

  final String label; // The label for display and mapping
  final String abbr; // The abbreviation for compact display

  const Attribute(this.label, this.abbr);
}
