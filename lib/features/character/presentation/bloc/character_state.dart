part of 'character_bloc.dart';

sealed class CharacterState extends Equatable {
  const CharacterState();

  @override
  List<Object> get props => [];
}

final class CharacterInitial extends CharacterState {}

final class CharacterLoading extends CharacterState {}

final class CharacterLoaded extends CharacterState {
  final Character character;

  const CharacterLoaded(this.character);

  @override
  List<Object> get props => [character];
}

final class CharacterError extends CharacterState {
  final String message;

  const CharacterError(this.message);

  @override
  List<Object> get props => [message];
}
