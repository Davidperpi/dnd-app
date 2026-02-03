/// Defines the rendering order in the UI.
/// The order in the enum defines the order in the list.
enum EquipmentSlot {
  mainHand('Mano principal'),
  offHand('Mano secundaria'),
  armor('Armadura'),
  head('Cabeza'),
  hands('Manos'),
  feet('Pies'),
  neck('Cuello'),
  ring('Anillos'),
  other('Otro');

  final String label;
  const EquipmentSlot(this.label);
}
