import 'package:equatable/equatable.dart';

class CharacterFeature extends Equatable {
  final String name;
  final String description;

  const CharacterFeature({
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [name, description];
}
