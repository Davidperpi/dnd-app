import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
// We only import the final data
import '../datasources/mock_character_data.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  @override
  Future<Either<Failure, Character>> getCharacter() async {
    // We simulate network latency
    await Future<void>.delayed(const Duration(milliseconds: 800));

    // We return the pre-made object
    return const Right<Failure, Character>(mockAidan);
  }
}
