import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../inventory/domain/entities/armor.dart';
import '../../../inventory/domain/entities/equipment_slot.dart';
// --- IMPORTS DE INVENTARIO (Necesarios para la lógica de items) ---
import '../../../inventory/domain/entities/item.dart';
import '../../../inventory/domain/entities/weapon.dart';
import '../../domain/entities/character.dart';
import '../../domain/usecases/get_character.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final GetCharacter getCharacter;

  CharacterBloc({required this.getCharacter}) : super(CharacterInitial()) {
    // 1. Registramos los eventos
    on<GetCharacterEvent>(_onGetCharacter);
    on<UpdateHealthEvent>(_onUpdateHealth);

    // Registramos el evento de equipar
    on<ToggleEquipItemEvent>(_onToggleEquipItem);

    // NUEVO: Registramos el evento de favoritos
    on<ToggleFavoriteActionEvent>(_onToggleFavoriteAction);
  }

  // --- LÓGICA DE CARGA ---
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

  // --- LÓGICA DE VIDA ---
  void _onUpdateHealth(UpdateHealthEvent event, Emitter<CharacterState> emit) {
    if (state is CharacterLoaded) {
      final Character currentChar = (state as CharacterLoaded).character;
      int newHp = currentChar.currentHp + event.amount;

      if (newHp < 0) newHp = 0;
      if (newHp > currentChar.maxHp) newHp = currentChar.maxHp;

      emit(CharacterLoaded(currentChar.copyWith(currentHp: newHp)));
    }
  }

  // --- LÓGICA DE FAVORITOS (NUEVO) ---
  void _onToggleFavoriteAction(
    ToggleFavoriteActionEvent event,
    Emitter<CharacterState> emit,
  ) {
    final CharacterState currentState = state;
    if (currentState is! CharacterLoaded) return;

    final Character currentCharacter = currentState.character;

    // Creamos una copia modificable de la lista actual de favoritos
    final List<String> currentFavs = List<String>.from(
      currentCharacter.favoriteActionIds,
    );
    final String actionId = event.actionId;

    if (currentFavs.contains(actionId)) {
      currentFavs.remove(actionId); // Si ya es favorito, lo quitamos
    } else {
      currentFavs.add(actionId); // Si no lo es, lo añadimos
    }

    // Emitimos el nuevo estado con la lista actualizada
    emit(
      CharacterLoaded(
        currentCharacter.copyWith(favoriteActionIds: currentFavs),
      ),
    );
  }

  // --- LÓGICA DE EQUIPAMIENTO ---
  void _onToggleEquipItem(
    ToggleEquipItemEvent event,
    Emitter<CharacterState> emit,
  ) {
    final CharacterState currentState = state;
    // Solo actuamos si el personaje ya está cargado
    if (currentState is! CharacterLoaded) return;

    final Character currentCharacter = currentState.character;
    final Item itemToToggle = event.item;

    // Determinamos la intención: Si está equipado, queremos false. Si no, true.
    final bool willEquip = !_isItemEquipped(itemToToggle);

    // Creamos una NUEVA lista de inventario iterando sobre la actual
    final List<Item> newInventory = currentCharacter.inventory.map((Item item) {
      // 1. Caso: Es el item que el usuario tocó
      if (item.id == itemToToggle.id) {
        return _setItemEquippedStatus(item, willEquip);
      }

      // 2. Caso: Conflicto de Slot (Solo si estamos intentando EQUIPAR algo nuevo)
      // Si voy a equipar una espada en Mano Principal, y ya tengo una ahí, la desequipo.
      if (willEquip) {
        if (_isItemEquipped(item) &&
            _getItemSlot(item) == _getItemSlot(itemToToggle)) {
          // Desequipamos el item antiguo que ocupaba el lugar
          return _setItemEquippedStatus(item, false);
        }
      }

      // 3. Caso: Item no relacionado
      return item;
    }).toList();

    // Emitimos el nuevo estado con el inventario actualizado
    emit(CharacterLoaded(currentCharacter.copyWith(inventory: newInventory)));
  }

  // --- HELPERS PRIVADOS (Para manejar el polimorfismo de Item) ---

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
    if (item is Weapon) {
      return item.copyWith(isEquipped: status);
    }
    if (item is Armor) {
      return item.copyWith(isEquipped: status);
    }
    return item;
  }
}
