part of 'character_bloc.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object> get props => [];
}

/// Evento inicial para cargar los datos de Aidan
class GetCharacterEvent extends CharacterEvent {}

class UpdateHealthEvent extends CharacterEvent {
  final int amount; // Puede ser positivo (curar) o negativo (daño)

  const UpdateHealthEvent(this.amount);

  @override
  List<Object> get props => [amount];
}
