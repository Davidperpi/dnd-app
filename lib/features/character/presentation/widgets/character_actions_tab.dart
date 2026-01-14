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
  ActionType? _selectedFilter;
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<CharacterAction> allActions = widget.character.actions;
    final List<CharacterAction> filteredActions = allActions.where((
      CharacterAction action,
    ) {
      if (_showOnlyFavorites && !action.isFavorite) {
        return false;
      }
      if (_selectedFilter == null) {
        return true;
      }
      return action.type == _selectedFilter;
    }).toList();

    return Column(
      children: <Widget>[
        // Filtros
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: <Widget>[
              // Favoritos
              FilterChip(
                label: Icon(
                  Icons.star,
                  size: 18,
                  color: _showOnlyFavorites
                      ? Colors.amber
                      : theme.iconTheme.color?.withValues(alpha: 0.5),
                ),
                selected: _showOnlyFavorites,
                showCheckmark: false,
                selectedColor: Colors.amber.withValues(alpha: 0.2),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onSelected: (bool val) {
                  setState(() {
                    _showOnlyFavorites = val;
                    if (val) {
                      _selectedFilter = null;
                    }
                  });
                },
              ),
              const SizedBox(width: 8),
              // Todos
              _FilterChip(
                label: 'Todos',
                isSelected: _selectedFilter == null && !_showOnlyFavorites,
                onTap: () => setState(() {
                  _selectedFilter = null;
                  _showOnlyFavorites = false;
                }),
              ),
              const SizedBox(width: 8),
              // Ataques
              _FilterChip(
                label: 'Ataques',
                isSelected: _selectedFilter == ActionType.attack,
                onTap: () =>
                    setState(() => _selectedFilter = ActionType.attack),
              ),
              const SizedBox(width: 8),
              // Conjuros
              _FilterChip(
                label: 'Conjuros',
                isSelected: _selectedFilter == ActionType.spell,
                onTap: () => setState(() => _selectedFilter = ActionType.spell),
              ),
              const SizedBox(width: 8),
              // Comunes
              _FilterChip(
                label: 'Comunes',
                isSelected: _selectedFilter == ActionType.utility,
                onTap: () =>
                    setState(() => _selectedFilter = ActionType.utility),
              ),
            ],
          ),
        ),
        // Tarjetas
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
