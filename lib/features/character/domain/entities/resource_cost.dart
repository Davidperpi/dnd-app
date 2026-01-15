import 'package:equatable/equatable.dart';

sealed class ResourceCost extends Equatable {
  const ResourceCost();
}

class SpellSlotCost extends ResourceCost {
  final int level;
  const SpellSlotCost(this.level);

  @override
  List<Object?> get props => <Object?>[level];
}

class FeatureResourceCost extends ResourceCost {
  final String resourceId;
  final int amount;

  const FeatureResourceCost(this.resourceId, {this.amount = 1});

  @override
  List<Object?> get props => <Object?>[resourceId, amount];
}

class ItemCost extends ResourceCost {
  final String itemId;
  final int amount;

  const ItemCost(this.itemId, {this.amount = 1});

  @override
  List<Object?> get props => <Object?>[itemId, amount];
}
