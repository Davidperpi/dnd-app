import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart'; // Asegúrate que tu carpeta se llama 'error' (singular)
import '../entities/character.dart';
import '../repositories/character_repository.dart';

class GetCharacter {
  final CharacterRepository repository;

  GetCharacter(this.repository);

  // 'call' permite usar la clase como una función: getCharacter()
  Future<Either<Failure, Character>> call() async {
    return await repository.getCharacter();
  }
}
