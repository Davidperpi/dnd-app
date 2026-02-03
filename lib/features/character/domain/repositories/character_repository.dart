import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/character.dart';

/// Repository contract.
/// The Presentation layer (BLoC) only knows this abstract class,
/// it doesn't know if the data comes from a Mock or from Firebase.
abstract class CharacterRepository {
  Future<Either<Failure, Character>> getCharacter();
}
