/// Define el orden de renderizado en la UI.
/// El orden en el enum define el orden en la lista.
enum EquipmentSlot {
  mainHand('Mano Principal'),
  offHand('Mano Torpe'),
  armor('Armadura'),
  head('Cabeza'),
  hands('Guantes'),
  feet('Pies'),
  neck('Cuello'),
  ring('Anillos'),
  other('Otros');

  final String label;
  const EquipmentSlot(this.label);
}
