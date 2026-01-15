import 'package:dnd_app/features/inventory/domain/entities/item.dart';

class Potion extends Item {
  /// Usamos una notación genérica. Puede ser daño (veneno) o cura.
  /// Si es null, es una poción de utilidad (Volar, Invisibilidad).
  final String? diceNotation;

  const Potion({
    required super.id,
    required super.name,
    required super.description,
    required super.weight,
    super.quantity,
    this.diceNotation, // Opcional
  }) : super(type: ItemType.potion, isConsumable: true);

  @override
  Potion copyWith({int? quantity}) {
    return Potion(
      id: id,
      name: name,
      description: description,
      weight: weight,
      quantity: quantity ?? this.quantity,
      diceNotation: diceNotation,
    );
  }

  @override
  List<Object?> get props => [...super.props, diceNotation];
}
