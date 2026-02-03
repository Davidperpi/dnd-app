import 'package:dnd_app/core/constants/damage_type.dart';
import 'package:dnd_app/features/character/domain/entities/character_action.dart';

String translateActionCost(ActionCost cost) {
  return switch (cost) {
    ActionCost.action => '1 ACCIÓN',
    ActionCost.bonusAction => 'ACCIÓN ADICIONAL',
    ActionCost.reaction => 'REACCIÓN',
    ActionCost.free => 'GRATIS',
  };
}

String translateDamageType(DamageType type) {
  return type.label.toUpperCase();
}
