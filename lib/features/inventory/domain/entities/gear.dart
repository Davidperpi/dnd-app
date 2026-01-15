import 'item.dart';

class Gear extends Item {
  const Gear({
    required super.id,
    required super.name,
    required super.description,
    required super.weight,
    super.quantity,
    super.type = ItemType.gear,
    super.isConsumable = false,
  });

  @override
  Gear copyWith({int? quantity}) {
    return Gear(
      id: id,
      name: name,
      description: description,
      weight: weight,
      quantity: quantity ?? this.quantity,
    );
  }
}
