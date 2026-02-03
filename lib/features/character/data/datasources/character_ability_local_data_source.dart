import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/character/domain/entities/character_resource.dart';
import 'package:dnd_app/features/character/domain/entities/character_ability.dart';
import 'package:dnd_app/features/character/domain/entities/resource_cost.dart';

class CharacterAbilityLocalDataSource {
  static final Map<String, CharacterAbility>
  registry = <String, CharacterAbility>{
    // --- BARD GENERAL ABILITIES ---
    'bardic_inspiration': const CharacterAbility(
      id: 'bardic_inspiration',
      name: 'Bardic Inspiration',
      shortName: 'BI',
      description:
          'You can inspire others as a bonus action (with a [dice] die), or use your inspiration dice to empower your Blade Flourishes.',
      refreshRule: RefreshRule.longRest,
      levelScaling: <int, String>{1: '1d6', 5: '1d8', 10: '1d10', 15: '1d12'},
      actionTemplate: CharacterAction(
        id: 'use_bardic_inspiration',
        name: 'Bardic Inspiration',
        description: 'You grant a Bardic Inspiration die to an ally who can hear you. The ally can roll that die and add the result to an attack roll, ability check, or saving throw.',
        type: ActionType.feature,
        cost: ActionCost.bonusAction,
        resourceCost: FeatureResourceCost('bardic_inspiration'),
        imageUrl: 'assets/icons/bardic_inspiration.png',
      ),
    ),

    'song_of_rest': const CharacterAbility(
      id: 'song_of_rest',
      name: 'Song of Rest',
      shortName: 'SR',
      description:
          'During a short rest, you and your allies regain additional hit points equal to your die roll if you spend any Hit Dice.',
      refreshRule: RefreshRule.passive,
      level: 2,
      levelScaling: <int, String>{2: '1d6', 9: '1d8', 13: '1d10', 17: '1d12'},
    ),

    'jack_of_all_trades': const CharacterAbility(
      id: 'jack_of_all_trades',
      name: 'Jack of All Trades',
      description:
          'You can add half of your proficiency bonus to any ability check you make that does not already include your proficiency bonus.',
      refreshRule: RefreshRule.passive,
      level: 2,
    ),

    'expertise': const CharacterAbility(
      id: 'expertise',
      name: 'Expertise',
      description:
          'Choose two of your skill proficiencies. Your proficiency bonus is doubled for any ability check you make that uses either of the chosen proficiencies.',
      refreshRule: RefreshRule.passive,
      level: 3,
    ),

    // --- BARD (College of Swords) ---
    'fighting_style_dueling': const CharacterAbility(
      id: 'fighting_style_dueling',
      name: 'Fighting Style: Dueling',
      description:
          'When you are wielding a melee weapon in one hand and no other weapons, you gain a +2 bonus to damage rolls with that weapon.',
      refreshRule: RefreshRule.passive,
      level: 3,
    ),

    'defensive_flourish': const CharacterAbility(
      id: 'defensive_flourish',
      name: 'Defensive Flourish',
      description:
          'When you hit with an attack, you can expend one use of Bardic Inspiration to add the die to the damage. You also add the number rolled to your AC until your next turn.',
      refreshRule: RefreshRule.longRest,
      level: 3,
      levelScaling: <int, String>{1: '1d6', 5: '1d8', 10: '1d10', 15: '1d12'},
      actionTemplate: CharacterAction(
        id: 'use_defensive_flourish',
        name: 'Defensive Flourish',
        description: 'When you hit with an attack, you can expend one use of Bardic Inspiration to add the die to the damage. You also add the number rolled to your AC until your next turn.',
        type: ActionType.feature,
        cost: ActionCost.free,
        resourceCost: FeatureResourceCost('bardic_inspiration'),
        imageUrl: 'assets/icons/defensive_flourish.png',
      ),
    ),

    'slashing_flourish': const CharacterAbility(
      id: 'slashing_flourish',
      name: 'Slashing Flourish',
      description:
          'When you hit with an attack, you can expend one use of Bardic Inspiration to add the die to your attacks damage. In addition, other creatures within 5 feet of you take damage equal to the number rolled on the die.',
      refreshRule: RefreshRule.longRest,
      level: 3,
      levelScaling: <int, String>{1: '1d6', 5: '1d8', 10: '1d10', 15: '1d12'},
      actionTemplate: CharacterAction(
        id: 'use_slashing_flourish',
        name: 'Slashing Flourish',
        description: 'When you hit with an attack, you can expend one use of Bardic Inspiration to add the die to your attacks damage. In addition, other creatures within 5 feet of you take damage equal to the number rolled on the die.',
        type: ActionType.feature,
        cost: ActionCost.free, 
        resourceCost: FeatureResourceCost('bardic_inspiration'),
        imageUrl: 'assets/icons/slashing_flourish.png',
      ),
    ),

    'mobile_flourish': const CharacterAbility(
      id: 'mobile_flourish',
      name: 'Mobile Flourish',
      description:
          'When you hit with an attack, you can expend one use of Bardic Inspiration to add the die to the damage. In addition, you can push the target a distance equal to 5 + the number rolled on the die. You can use your reaction to move to a space adjacent to the target.',
      refreshRule: RefreshRule.longRest,
      level: 3,
      levelScaling: <int, String>{1: '1d6', 5: '1d8', 10: '1d10', 15: '1d12'},
      actionTemplate: CharacterAction(
        id: 'use_mobile_flourish',
        name: 'Mobile Flourish',
        description: 'When you hit with an attack, you can expend one use of Bardic Inspiration to add the die to the damage. In addition, you can push the target a distance equal to 5 + the number rolled on the die. You can use your reaction to move to a space adjacent to the target.',
        type: ActionType.feature,
        cost: ActionCost.free,
        resourceCost: FeatureResourceCost('bardic_inspiration'),
        imageUrl: 'assets/icons/mobile_flourish.png',
      ),
    ),
    
    'extra_attack': const CharacterAbility(
      id: 'extra_attack',
      name: 'Extra Attack',
      description:
          'You can attack twice, instead of once, whenever you take the Attack action on your turn.',
      refreshRule: RefreshRule.passive,
      level: 6,
    ),

  };
}
