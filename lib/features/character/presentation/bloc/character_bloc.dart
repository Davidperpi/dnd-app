import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../inventory/domain/entities/armor.dart';
import '../../../inventory/domain/entities/equipment_slot.dart';
import '../../../inventory/domain/entities/item.dart';
import '../../../inventory/domain/entities/weapon.dart';
import '../../../spells/domain/entities/spell.dart';
import '../../domain/entities/character.dart';
import '../../domain/usecases/get_character.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final GetCharacter getCharacter;

  CharacterBloc({required this.getCharacter}) : super(CharacterInitial()) {
    on<GetCharacterEvent>(_onGetCharacter);
    on<UpdateHealthEvent>(_onUpdateHealth);
    on<ToggleEquipItemEvent>(_onToggleEquipItem);
    on<ToggleFavoriteActionEvent>(_onToggleFavoriteAction);
    on<CastSpellEvent>(_onCastSpell);
    on<ConsumeItemEvent>(_onConsumeItem);
    on<UseFeatureEvent>(_onUseFeature);
    on<PerformShortRestEvent>(_onPerformShortRest);
    on<PerformLongRestEvent>(_onPerformLongRest);
  }

  /// A helper method to execute a character update function if the state is [CharacterLoaded].
  /// This reduces boilerplate code in event handlers.
  void _emitLoadedIfPossible(
    Emitter<CharacterState> emit,
    Character Function(Character character) update,
  ) {
    final currentState = state;
    if (currentState is CharacterLoaded) {
      final newCharacter = update(currentState.character);
      emit(CharacterLoaded(newCharacter));
    }
  }

  Future<void> _onGetCharacter(
    GetCharacterEvent event,
    Emitter<CharacterState> emit,
  ) async {
    emit(CharacterLoading());
    final Either<Failure, Character> result = await getCharacter();
    result.fold(
      (Failure failure) => emit(CharacterError(failure.message)),
      (Character character) => emit(CharacterLoaded(character)),
    );
  }

  void _onUpdateHealth(UpdateHealthEvent event, Emitter<CharacterState> emit) {
    _emitLoadedIfPossible(emit, (character) {
      final newHp = (character.currentHp + event.amount).clamp(0, character.maxHp);
      return character.copyWith(currentHp: newHp);
    });
  }

  void _onToggleFavoriteAction(
    ToggleFavoriteActionEvent event,
    Emitter<CharacterState> emit,
  ) {
    _emitLoadedIfPossible(emit, (character) {
      final newFavs = List<String>.from(character.favoriteActionIds);
      if (newFavs.contains(event.actionId)) {
        newFavs.remove(event.actionId);
      } else {
        newFavs.add(event.actionId);
      }
      return character.copyWith(favoriteActionIds: newFavs);
    });
  }

  void _onToggleEquipItem(
    ToggleEquipItemEvent event,
    Emitter<CharacterState> emit,
  ) {
    _emitLoadedIfPossible(emit, (character) {
      final itemToToggle = event.item;
      final willEquip = !_isItemEquipped(itemToToggle);

      final newInventory = character.inventory.map((item) {
        // Toggle the selected item
        if (item.id == itemToToggle.id) {
          return _setItemEquippedStatus(item, willEquip);
        }
        // If we are equipping a new item, unequip any other item in the same slot.
        if (willEquip &&
            _isItemEquipped(item) &&
            _getItemSlot(item) == _getItemSlot(itemToToggle) &&
            _getItemSlot(item) != EquipmentSlot.other) {
          return _setItemEquippedStatus(item, false);
        }
        return item;
      }).toList();

      return character.copyWith(inventory: newInventory);
    });
  }

  void _onConsumeItem(ConsumeItemEvent event, Emitter<CharacterState> emit) {
    _emitLoadedIfPossible(emit, (character) {
      final inventory = List<Item>.from(character.inventory);
      final itemIndex = inventory.indexWhere((item) => item.id == event.itemId);

      if (itemIndex != -1) {
        final item = inventory[itemIndex];
        final newQuantity = item.quantity - event.amount;

        if (newQuantity > 0) {
          inventory[itemIndex] = item.copyWith(quantity: newQuantity);
        } else {
          inventory.removeAt(itemIndex);
        }
        return character.copyWith(inventory: inventory);
      }
      return character; // Item not found, return original character
    });
  }

  void _onUseFeature(UseFeatureEvent event, Emitter<CharacterState> emit) {
    _emitLoadedIfPossible(
      emit,
      (character) => character.useResource(event.resourceId),
    );
  }

  void _onCastSpell(CastSpellEvent event, Emitter<CharacterState> emit) {
    _emitLoadedIfPossible(emit, (char) {
      // Cantrips don't consume spell slots.
      if (event.slotLevel == 0) {
        return char;
      }

      final currentSlots = char.spellSlotsCurrent[event.slotLevel] ?? 0;
      if (currentSlots <= 0) {
        // No spell slots left for this level.
        return char;
      }

      final newSlots = Map<int, int>.from(char.spellSlotsCurrent);
      newSlots[event.slotLevel] = currentSlots - 1;

      return char.copyWith(spellSlotsCurrent: newSlots);
    });
  }

  void _onPerformShortRest(
    PerformShortRestEvent event,
    Emitter<CharacterState> emit,
  ) {
    _emitLoadedIfPossible(
      emit,
      (character) => character.recoverShortRest(),
    );
  }

  void _onPerformLongRest(
    PerformLongRestEvent event,
    Emitter<CharacterState> emit,
  ) {
    _emitLoadedIfPossible(
      emit,
      (character) => character.recoverLongRest(),
    );
  }

  // Helper methods for item equipping
  bool _isItemEquipped(Item item) {
    if (item is Weapon) return item.isEquipped;
    if (item is Armor) return item.isEquipped;
    return false;
  }

  EquipmentSlot _getItemSlot(Item item) {
    if (item is Weapon) return item.slot;
    if (item is Armor) return item.slot;
    return EquipmentSlot.other;
  }

  Item _setItemEquippedStatus(Item item, bool status) {
    if (item is Weapon) return item.copyWith(isEquipped: status);
    if (item is Armor) return item.copyWith(isEquipped: status);
    return item;
  }
}
