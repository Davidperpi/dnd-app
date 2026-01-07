import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';

class MockCharacterRepository implements CharacterRepository {
  @override
  Future<Either<Failure, Character>> getCharacter() async {
    // Simulamos 1 segundo de espera (como una API real)
    await Future<void>.delayed(const Duration(seconds: 1));

    return const Right<Failure, Character>(
      Character(
        id: 'aidan-001',
        name: 'Aidan',
        race: 'Human',
        characterClass: 'Bard (College of Swords)',
        level: 4,
        maxHp: 33,
        currentHp: 21,
        armorClass: 15,
        initiative: 3,
        strength: 8,
        dexterity: 16,
        constitution: 14,
        intelligence: 12,
        wisdom: 10,
        charisma: 18,
        proficientSaves: <String>['DESTREZA', 'CARISMA'],
        equipment: <String>['Scimitar', 'Lute', 'Leather Armor', 'Dagger'],
      ),
    );
  }
}
