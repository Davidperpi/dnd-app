import 'package:equatable/equatable.dart';

enum ItemType { weapon, armor, potion, gear, tool }

/// Clase base abstracta. Todo en el inventario es un Item.
abstract class Item extends Equatable {
  final String id;
  final String name;
  final String description;
  final double weight;
  final ItemType type;
  final int quantity;
  final bool isConsumable;

  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.weight,
    required this.type,
    this.quantity = 1,
    this.isConsumable = false,
  });

  Item copyWith({int? quantity});

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    description,
    weight,
    type,
    quantity,
    isConsumable,
  ];
}
