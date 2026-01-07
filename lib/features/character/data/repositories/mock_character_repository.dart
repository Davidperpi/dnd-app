import 'package:dnd_app/core/constants/attributes.dart';
import 'package:dnd_app/core/constants/skills.dart';
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
        characterClass: 'Bard',
        level: 5,
        maxHp: 29,
        currentHp: 21,
        armorClass: 15,
        initiative: 3,
        strength: 8,
        dexterity: 16,
        constitution: 12,
        intelligence: 10,
        wisdom: 12,
        charisma: 18,
        proficientSaves: <Attribute>[Attribute.dexterity, Attribute.charisma],
        equipment: <String>[
          'Sable Oriental',
          'Laúd de Madera Oscura',
          'Daga Élfica (Dafne)',
          'Dado Trucado',
          'Armadura de Cuero',
        ],
        description:
            "Crecido en el teatro ambulante 'El Espejo de las Estrellas', Aidan aprendió pronto que la vida es una actuación. "
            "Tras la misteriosa desaparición de su amiga Dafne y la creciente oscuridad de su mentora Selana, huyó llevando consigo "
            "una daga élfica, un anillo de su pasado olvidado y un dado trucado robado a modo de despedida.\n\n"
            "Fue el viejo bardo Haldric quien pulió su talento en 'Los Hijos del Viento', enseñándole a mezclar acero y magia. "
            "Expulsado del Colegio de Bardos por defender su honor ante un noble arrogante, ahora viaja como un alma errante. "
            "Carismático, pragmático y alérgico a las ataduras, busca en Asbravn su próxima gran historia... o su próxima gran apuesta.",
        imageUrl: 'assets/images/aidan_portrait.jpeg',
        expertSkills: <Skill>[Skill.acrobatics, Skill.stealth],
        proficientSkills: <Skill>[Skill.survival],
        hasJackOfAllTrades: true,
        speed: 30,
      ),
    );
  }
}
