import '../../features/character/domain/entities/character_action.dart';

class StandardActions {
  static const CharacterAction dash = CharacterAction(
    id: 'act_dash',
    name: 'Carrera',
    description: 'Ganas un movimiento extra igual a tu velocidad actual.',
    type: ActionType.utility,
    cost: ActionCost.action,
  );

  static const CharacterAction disengage = CharacterAction(
    id: 'act_disengage',
    name: 'Destrabarse',
    description:
        'Tu movimiento no provoca ataques de oportunidad durante el resto del turno.',
    type: ActionType.utility,
    cost: ActionCost.action,
  );

  static const CharacterAction dodge = CharacterAction(
    id: 'act_dodge',
    name: 'Esquivar',
    description:
        'Impones desventaja en los ataques contra ti. Tienes ventaja en las tiradas de salvación de Destreza.',
    type: ActionType.utility,
    cost: ActionCost.action,
  );

  // Base list
  static const List<CharacterAction> all = <CharacterAction>[
    dash,
    disengage,
    dodge,
  ];
}
