import 'package:dnd_app/core/constants/attributes.dart';

// Asegúrate de importar Item y EquipmentSlot correctamente según tu estructura
import 'equipment_slot.dart';
import 'item.dart';

// Nota: Si DamageType está en core, úsalo desde ahí. Si está aquí, está bien.
// Pero recuerda el 'hide' si tienes colisiones.
enum DamageType { slashing, piercing, bludgeoning, psychic }

class Weapon extends Item {
  final String damageDice;
  final DamageType damageType;
  final Attribute attribute;
  final bool isProficient;
  final bool isEquipped;
  final EquipmentSlot slot;

  const Weapon({
    // Super params (Item)
    required super.id,
    required super.name,
    required super.description,
    required super.weight,
    super.quantity,

    // Weapon params
    required this.damageDice,
    required this.damageType,
    required this.attribute,
    this.slot = EquipmentSlot.mainHand,
    this.isProficient = true,
    this.isEquipped = false,
  }) : super(type: ItemType.weapon);

  /// CopyWith completo: Incluye campos del padre (Item) y del hijo (Weapon)
  Weapon copyWith({
    String? id,
    String? name,
    String? description,
    double? weight,
    int? quantity,
    String? damageDice,
    DamageType? damageType,
    Attribute? attribute,
    EquipmentSlot? slot,
    bool? isProficient,
    bool? isEquipped,
  }) {
    return Weapon(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      quantity: quantity ?? this.quantity,
      damageDice: damageDice ?? this.damageDice,
      damageType: damageType ?? this.damageType,
      attribute: attribute ?? this.attribute,
      slot: slot ?? this.slot,
      isProficient: isProficient ?? this.isProficient,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props, // Importante para que Equatable revise id, name, etc.
    damageDice,
    damageType,
    attribute,
    isProficient,
    isEquipped,
    slot,
  ];
}
