enum Attribute {
  strength('FUERZA', 'FUE'),
  dexterity('DESTREZA', 'DES'),
  constitution('CONSTITUCION', 'CON'),
  intelligence('INTELIGENCIA', 'INT'),
  wisdom('SABIDURIA', 'SAB'),
  charisma('CARISMA', 'CAR');

  final String id; // El ID para comparar con la base de datos/mock
  final String abbr; // La abreviatura para mostrar en pantalla

  const Attribute(this.id, this.abbr);
}
