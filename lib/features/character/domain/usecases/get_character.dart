import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart'; // Make sure your folder is named 'error' (singular)
import '../entities/character.dart';
import '../repositories/character_repository.dart';

class GetCharacter {
  final CharacterRepository repository;

  GetCharacter(this.repository);

  // 'call' allows using the class as a function: getCharacter()
  Future<Either<Failure, Character>> call() async {
    return await repository.getCharacter();
  }
}
