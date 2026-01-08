import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
// Importamos solo el dato final
import '../datasources/mock_character_data.dart';

class MockCharacterRepository implements CharacterRepository {
  @override
  Future<Either<Failure, Character>> getCharacter() async {
    // Simulamos latencia de red
    await Future<void>.delayed(const Duration(milliseconds: 800));

    // Retornamos el objeto pre-fabricado
    return const Right<Failure, Character>(mockAidan);
  }
}
