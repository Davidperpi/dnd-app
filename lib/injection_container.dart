import 'package:get_it/get_it.dart';

import 'features/character/data/repositories/mock_character_repository.dart';
import 'features/character/domain/repositories/character_repository.dart';
import 'features/character/domain/usecases/get_character.dart';
import 'features/character/presentation/bloc/character_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // ! Features - Character

  // Bloc
  sl.registerFactory(() => CharacterBloc(getCharacter: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetCharacter(sl()));

  // Repository
  sl.registerLazySingleton<CharacterRepository>(
    () => MockCharacterRepository(),
  );
}
