import 'package:dnd_app/features/character/presentation/widgets/action/action_card.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/character.dart';
import '../../domain/entities/character_action.dart';

class CharacterActionsTab extends StatefulWidget {
  final Character character;

  const CharacterActionsTab({super.key, required this.character});

  @override
  State<CharacterActionsTab> createState() => _CharacterActionsTabState();
}

class _CharacterActionsTabState extends State<CharacterActionsTab> {
  // Null significa "Mostrar todos los tipos"
  ActionType? _selectedFilter;

  // Nuevo estado para el filtro de favoritos
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // 1. Obtenemos las acciones calculadas desde la Entidad
    final List<CharacterAction> allActions = widget.character.actions;

    // 2. Aplicamos el filtro visual (Lógica combinada)
    final List<CharacterAction> filteredActions = allActions.where((
      CharacterAction action,
    ) {
      // Prioridad 1: Si solo queremos favoritos, descartamos los que no lo son
      if (_showOnlyFavorites && !action.isFavorite) return false;

      // Prioridad 2: Filtro por tipo
      if (_selectedFilter == null) return true;
      return action.type == _selectedFilter;
    }).toList();

    return Column(
      children: <Widget>[
        // --- SECCIÓN DE FILTROS ---
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: <Widget>[
              // --- 1. CHIP DE FAVORITOS (NUEVO) ---
              FilterChip(
                label: Icon(
                  Icons.star,
                  size: 18,
                  // Color ámbar si está activo, gris si no
                  color: _showOnlyFavorites
                      ? Colors.amber
                      : theme.iconTheme.color?.withValues(alpha: 0.5),
                ),
                selected: _showOnlyFavorites,
                showCheckmark: false, // Más limpio sin el check estándar
                selectedColor: Colors.amber.withValues(alpha: 0.2),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onSelected: (bool val) {
                  setState(() {
                    _showOnlyFavorites = val;
                    // UX Opcional: Si activas favoritos, quitamos el filtro de tipo
                    // para que veas TODOS tus favoritos de un vistazo.
                    if (val) _selectedFilter = null;
                  });
                },
              ),

              const SizedBox(width: 8),

              // --- 2. CHIP "TODOS" ---
              _FilterChip(
                label: 'Todos',
                // Solo está seleccionado si NO hay filtro de tipo NI de favoritos
                isSelected: _selectedFilter == null && !_showOnlyFavorites,
                onTap: () => setState(() {
                  _selectedFilter = null;
                  _showOnlyFavorites = false; // Reset total
                }),
              ),

              const SizedBox(width: 8),

              // --- 3. CHIPS DE TIPO ---
              _FilterChip(
                label: 'Ataques',
                isSelected: _selectedFilter == ActionType.attack,
                onTap: () =>
                    setState(() => _selectedFilter = ActionType.attack),
              ),

              const SizedBox(width: 8),

              _FilterChip(
                label: 'Comunes',
                isSelected: _selectedFilter == ActionType.utility,
                onTap: () =>
                    setState(() => _selectedFilter = ActionType.utility),
              ),
            ],
          ),
        ),

        // --- LISTA DE CARTAS ---
        Expanded(
          child: filteredActions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.filter_list_off,
                        size: 48,
                        color: theme.disabledColor,
                      ),
                      const SizedBox(height: 16),
                      const Text('No hay acciones con este filtro'),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredActions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (BuildContext context, int index) {
                    return ActionCard(action: filteredActions[index]);
                  },
                ),
        ),
      ],
    );
  }
}

// Widget auxiliar privado para los chips de texto
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? theme.colorScheme.onSecondary : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      backgroundColor: isSelected ? theme.colorScheme.secondary : null,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: onTap,
    );
  }
}
