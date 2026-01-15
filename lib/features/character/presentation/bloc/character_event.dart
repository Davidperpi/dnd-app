part of 'character_bloc.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object> get props => <Object>[];
}

class GetCharacterEvent extends CharacterEvent {}

class UpdateHealthEvent extends CharacterEvent {
  final int amount;

  const UpdateHealthEvent(this.amount);

  @override
  List<Object> get props => <Object>[amount];
}

class ToggleEquipItemEvent extends CharacterEvent {
  final Item item;

  const ToggleEquipItemEvent(this.item);

  @override
  List<Object> get props => <Object>[item];
}

class ToggleFavoriteActionEvent extends CharacterEvent {
  final String actionId;

  const ToggleFavoriteActionEvent(this.actionId);

  @override
  List<Object> get props => <Object>[actionId];
}

class CastSpellEvent extends CharacterEvent {
  final Spell spell;
  final int slotLevel;

  const CastSpellEvent(this.spell, {required this.slotLevel});
}

/// Evento para consumir un objeto del inventario (Poción, Pergamino)
class ConsumeItemEvent extends CharacterEvent {
  final String itemId;

  const ConsumeItemEvent({required this.itemId});

  @override
  List<Object> get props => <Object>[itemId];
}

/// Evento para gastar un recurso de clase (Inspiración, Ki, Maniobras)
class UseFeatureEvent extends CharacterEvent {
  final String resourceId;

  const UseFeatureEvent({required this.resourceId});

  @override
  List<Object> get props => <Object>[resourceId];
}

sealed class RestEvent extends CharacterEvent {
  const RestEvent();
}

class PerformShortRestEvent extends RestEvent {
  const PerformShortRestEvent();
  @override
  List<Object> get props => <Object>[];
}

class PerformLongRestEvent extends RestEvent {
  const PerformLongRestEvent();
  @override
  List<Object> get props => <Object>[];
}
