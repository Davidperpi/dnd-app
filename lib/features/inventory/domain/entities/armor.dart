import 'equipment_slot.dart';
import 'item.dart';

enum ArmorType { light, medium, heavy, shield }

class Armor extends Item {
  final int armorClassBonus;
  final ArmorType armorType;
  final bool imposesStealthDisadvantage;
  final EquipmentSlot slot;
  final bool isEquipped;

  const Armor({
    // Super params
    required super.id,
    required super.name,
    required super.description,
    required super.weight,
    super.quantity,

    // Armor params
    required this.armorClassBonus,
    required this.armorType,
    this.imposesStealthDisadvantage = false,
    this.slot = EquipmentSlot.armor,
    this.isEquipped = false,
  }) : super(type: ItemType.armor);

  /// CopyWith completo
  Armor copyWith({
    String? id,
    String? name,
    String? description,
    double? weight,
    int? quantity,
    int? armorClassBonus,
    ArmorType? armorType,
    bool? imposesStealthDisadvantage,
    EquipmentSlot? slot,
    bool? isEquipped,
  }) {
    return Armor(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      quantity: quantity ?? this.quantity,
      armorClassBonus: armorClassBonus ?? this.armorClassBonus,
      armorType: armorType ?? this.armorType,
      imposesStealthDisadvantage:
          imposesStealthDisadvantage ?? this.imposesStealthDisadvantage,
      slot: slot ?? this.slot,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    armorClassBonus,
    armorType,
    imposesStealthDisadvantage,
    slot,
    isEquipped,
  ];
}
