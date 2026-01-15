import 'package:dnd_app/features/character/domain/entities/character.dart';
import 'package:dnd_app/features/character/domain/entities/character_action.dart';
// IMPORTANTE: Necesario para distinguir consumibles
import 'package:dnd_app/features/character/domain/entities/resource_cost.dart';
import 'package:dnd_app/features/character/presentation/widgets/action/action_card.dart';
import 'package:flutter/material.dart';

/// Categorías visuales para el filtro
enum ActionCategory {
  all("Todo", Icons.grid_view),
  favorites("Favoritos", Icons.star), // Integrado como categoría
  attack("Ataques", Icons.casino),
  spell("Magia", Icons.auto_fix_high),
  feature("Rasgos", Icons.flash_on), // Nueva categoría
  consumable("Objetos", Icons.local_drink), // Nueva categoría
  utility("Otros", Icons.settings_accessibility);

  final String label;
  final IconData icon;
  const ActionCategory(this.label, this.icon);
}

class CharacterActionsTab extends StatefulWidget {
  final Character character;

  const CharacterActionsTab({super.key, required this.character});

  @override
  State<CharacterActionsTab> createState() => _CharacterActionsTabState();
}

class _CharacterActionsTabState extends State<CharacterActionsTab> {
  // Estado del filtro seleccionado (por defecto 'Todo')
  ActionCategory _selectedCategory = ActionCategory.all;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<CharacterAction> allActions = widget.character.actions;

    // --- LÓGICA DE FILTRADO ---
    final List<CharacterAction> filteredActions = allActions.where((
      CharacterAction action,
    ) {
      return switch (_selectedCategory) {
        ActionCategory.all => true,

        ActionCategory.favorites => action.isFavorite,

        ActionCategory.attack => action.type == ActionType.attack,

        ActionCategory.spell => action.type == ActionType.spell,

        ActionCategory.feature => action.type == ActionType.feature,

        // Aquí está la magia: Distinguimos objetos por su coste
        ActionCategory.consumable => action.resourceCost is ItemCost,

        // "Otros" son Utility pero que NO son objetos
        ActionCategory.utility =>
          action.type == ActionType.utility && action.resourceCost is! ItemCost,
      };
    }).toList();

    return Column(
      children: <Widget>[
        // 1. Barra de Filtros (Horizontal Scroll)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: ActionCategory.values.map((ActionCategory category) {
              final bool isSelected = category == _selectedCategory;

              // Color semántico activo
              final Color? activeColor = switch (category) {
                ActionCategory.favorites => Colors.amber,
                ActionCategory.attack => const Color(0xFFE57373),
                ActionCategory.spell => const Color(0xFFBA68C8),
                ActionCategory.feature => const Color(0xFFFFB74D),
                ActionCategory.consumable => Colors.green[400],
                _ => theme.colorScheme.primary,
              };

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category.label),
                  avatar: Icon(
                    category.icon,
                    size: 16,
                    // Si está seleccionado blanco, si no, color del tema atenuado
                    color: isSelected
                        ? Colors.white
                        : theme.iconTheme.color?.withValues(alpha: 0.6),
                  ),
                  selected: isSelected,
                  showCheckmark: false,
                  backgroundColor: theme.cardColor,
                  selectedColor: activeColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : theme.textTheme.bodyMedium?.color,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  side: isSelected
                      ? BorderSide.none
                      : BorderSide(
                          color: theme.dividerColor.withValues(alpha: 0.5),
                        ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() => _selectedCategory = category);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),

        // 2. Lista de Tarjetas
        Expanded(
          child: filteredActions.isEmpty
              ? _buildEmptyState(theme)
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

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.filter_list_off, size: 48, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(
            'No hay acciones en esta categoría',
            style: TextStyle(color: theme.disabledColor),
          ),
        ],
      ),
    );
  }
}
