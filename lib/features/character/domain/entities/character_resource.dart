import 'package:equatable/equatable.dart';

enum RefreshRule { shortRest, longRest, dawn, never }

class CharacterResource extends Equatable {
  final String id; // ej: 'spell_slots_1', 'bardic_inspiration', 'action_surge'
  final String name; // ej: 'Espacios de Conjuro Nvl 1', 'Inspiración'
  final int current;
  final int max;
  final RefreshRule refresh;

  const CharacterResource({
    required this.id,
    required this.name,
    required this.current,
    required this.max,
    required this.refresh,
  });

  // Helper para saber si podemos gastar
  bool get isAvailable => current > 0;

  // CopyWith para inmutabilidad (esencial para el BLoC)
  CharacterResource copyWith({
    String? id,
    String? name,
    int? current,
    int? max,
    RefreshRule? refresh,
  }) {
    return CharacterResource(
      id: id ?? this.id,
      name: name ?? this.name,
      current: current ?? this.current,
      max: max ?? this.max,
      refresh: refresh ?? this.refresh,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, name, current, max, refresh];
}
