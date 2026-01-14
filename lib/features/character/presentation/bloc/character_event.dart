part of 'character_bloc.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object> get props => <Object>[];
}

/// Evento inicial para cargar los datos de Aidan
class GetCharacterEvent extends CharacterEvent {}

class UpdateHealthEvent extends CharacterEvent {
  final int amount; // Puede ser positivo (curar) o negativo (daño)

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
