import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/character.dart';
import '../../domain/usecases/get_character.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final GetCharacter getCharacter;

  CharacterBloc({required this.getCharacter}) : super(CharacterInitial()) {
    // 1. Registramos los eventos
    on<GetCharacterEvent>(_onGetCharacter);
    on<UpdateHealthEvent>(_onUpdateHealth);
  }

  // Lógica para cargar el personaje (API/Base de datos)
  Future<void> _onGetCharacter(
    GetCharacterEvent event,
    Emitter<CharacterState> emit,
  ) async {
    emit(CharacterLoading());

    final Either<Failure, Character> result = await getCharacter();

    result.fold(
      (Failure failure) => emit(CharacterError(failure.message)),
      (Character character) => emit(CharacterLoaded(character)),
    );
  }

  // Lógica para modificar la vida (Local)
  void _onUpdateHealth(UpdateHealthEvent event, Emitter<CharacterState> emit) {
    // Solo podemos curar/herir si ya tenemos un personaje cargado
    if (state is CharacterLoaded) {
      final Character currentChar = (state as CharacterLoaded).character;

      // Calculamos la nueva vida
      int newHp = currentChar.currentHp + event.amount;

      // CLAMP: Evitamos que la vida baje de 0 o suba del máximo
      if (newHp < 0) newHp = 0;
      if (newHp > currentChar.maxHp) newHp = currentChar.maxHp;

      // Emitimos el nuevo estado clonando el personaje con la vida actualizada
      emit(CharacterLoaded(currentChar.copyWith(currentHp: newHp)));
    }
  }
}
