import 'package:equatable/equatable.dart';

enum RefreshRule { shortRest, longRest, dawn, passive, never }

class CharacterResource extends Equatable {
  final String id; // e.g., 'spell_slots_1', 'bardic_inspiration', 'action_surge'
  final String name; // e.g., 'Level 1 Spell Slots', 'Inspiration'
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

  // Helper to check if we can spend
  bool get isAvailable => current > 0;

  // CopyWith for immutability (essential for BLoC)
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
