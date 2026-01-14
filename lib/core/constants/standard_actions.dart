import '../../features/character/domain/entities/character_action.dart';

class StandardActions {
  static const CharacterAction dash = CharacterAction(
    id: 'act_dash',
    name: 'Correr',
    description: 'Ganas movimiento extra igual a tu velocidad actual.',
    type: ActionType.utility,
    cost: ActionCost.action,
  );

  static const CharacterAction disengage = CharacterAction(
    id: 'act_disengage',
    name: 'Destrabarse',
    description: 'Tu movimiento no provoca ataques de oportunidad este turno.',
    type: ActionType.utility,
    cost: ActionCost.action,
  );

  static const CharacterAction dodge = CharacterAction(
    id: 'act_dodge',
    name: 'Esquivar',
    description:
        'Impones desventaja en ataques contra ti. Tienes ventaja en salvaciones de Destreza.',
    type: ActionType.utility,
    cost: ActionCost.action,
  );

  // Lista base
  static const List<CharacterAction> all = <CharacterAction>[
    dash,
    disengage,
    dodge,
  ];
}
