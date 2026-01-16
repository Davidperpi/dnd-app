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
    if (state is CharacterLoaded) {
      final Character currentChar = (state as CharacterLoaded).character;
      int newHp = currentChar.currentHp + event.amount;
      if (newHp < 0) newHp = 0;
      if (newHp > currentChar.maxHp) newHp = currentChar.maxHp;

      emit(CharacterLoaded(currentChar.copyWith(currentHp: newHp)));
    }
  }

  void _onToggleFavoriteAction(
    ToggleFavoriteActionEvent event,
    Emitter<CharacterState> emit,
  ) {
    final CharacterState currentState = state;
    if (currentState is! CharacterLoaded) return;
    final Character currentCharacter = currentState.character;

    final List<String> currentFavs = List<String>.from(
      currentCharacter.favoriteActionIds,
    );

    if (currentFavs.contains(event.actionId)) {
      currentFavs.remove(event.actionId);
    } else {
      currentFavs.add(event.actionId);
    }

    emit(
      CharacterLoaded(
        currentCharacter.copyWith(favoriteActionIds: currentFavs),
      ),
    );
  }

  void _onToggleEquipItem(
    ToggleEquipItemEvent event,
    Emitter<CharacterState> emit,
  ) {
    final CharacterState currentState = state;
    if (currentState is! CharacterLoaded) return;

    final Character currentCharacter = currentState.character;
    final Item itemToToggle = event.item;
    final bool willEquip = !_isItemEquipped(itemToToggle);

    final List<Item> newInventory = currentCharacter.inventory.map((Item item) {
      if (item.id == itemToToggle.id) {
        return _setItemEquippedStatus(item, willEquip);
      }
      if (willEquip) {
        if (_isItemEquipped(item) &&
            _getItemSlot(item) == _getItemSlot(itemToToggle)) {
          return _setItemEquippedStatus(item, false);
        }
      }
      return item;
    }).toList();

    emit(CharacterLoaded(currentCharacter.copyWith(inventory: newInventory)));
  }

  void _onConsumeItem(ConsumeItemEvent event, Emitter<CharacterState> emit) {
    final CharacterState currentState = state;
    if (currentState is! CharacterLoaded) return;

    final Character currentCharacter = currentState.character;
    final List<Item> updatedInventory = List<Item>.from(currentCharacter.inventory);
    final int itemIndex = updatedInventory.indexWhere((item) => item.id == event.itemId);

    if (itemIndex != -1) {
      final Item itemToConsume = updatedInventory[itemIndex];
      final int newQuantity = (itemToConsume.quantity) - event.amount;

      if (newQuantity > 0) {
        updatedInventory[itemIndex] = itemToConsume.copyWith(quantity: newQuantity);
      } else {
        updatedInventory.removeAt(itemIndex);
      }

      emit(CharacterLoaded(currentCharacter.copyWith(inventory: updatedInventory)));
    }
  }

  void _onUseFeature(UseFeatureEvent event, Emitter<CharacterState> emit) {
    final CharacterState state = this.state;
    if (state is CharacterLoaded) {
      final Character updatedChar = state.character.useResource(
        event.resourceId,
      );
      emit(CharacterLoaded(updatedChar));
    }
  }

  void _onCastSpell(CastSpellEvent event, Emitter<CharacterState> emit) {
    if (state is! CharacterLoaded) return;

    final Character char = (state as CharacterLoaded).character;

    if (event.slotLevel == 0) {
      return;
    }

    final int currentSlots = char.spellSlotsCurrent[event.slotLevel] ?? 0;
    if (currentSlots <= 0) {
      return;
    }

    final Map<int, int> newSlots = Map<int, int>.from(char.spellSlotsCurrent);
    newSlots[event.slotLevel] = currentSlots - 1;

    emit(CharacterLoaded(char.copyWith(spellSlotsCurrent: newSlots)));
  }

  void _onPerformShortRest(
    PerformShortRestEvent event,
    Emitter<CharacterState> emit,
  ) {
    if (state is CharacterLoaded) {
      final Character updatedChar = (state as CharacterLoaded).character.recoverShortRest();
      emit(CharacterLoaded(updatedChar));
    }
  }

  void _onPerformLongRest(
    PerformLongRestEvent event,
    Emitter<CharacterState> emit,
  ) {
    if (state is CharacterLoaded) {
      final Character updatedChar = (state as CharacterLoaded).character.recoverLongRest();
      emit(CharacterLoaded(updatedChar));
    }
  }

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
