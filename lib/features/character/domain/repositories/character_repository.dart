import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/character.dart';

/// Contrato del Repositorio.
/// La capa de Presentación (BLoC) solo conoce esta clase abstracta,
/// no sabe si los datos vienen de un Mock o de Firebase.
abstract class CharacterRepository {
  Future<Either<Failure, Character>> getCharacter();
}
