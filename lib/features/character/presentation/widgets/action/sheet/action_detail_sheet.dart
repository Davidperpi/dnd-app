import 'package:dnd_app/core/utils/screen_effects.dart';
import 'package:dnd_app/features/character/domain/entities/character_action.dart';
import 'package:dnd_app/features/character/domain/entities/resource_cost.dart';
import 'package:dnd_app/features/character/presentation/bloc/character_bloc.dart';
import 'package:dnd_app/features/character/presentation/widgets/action/components/action_badges.dart';
import 'package:dnd_app/features/character/presentation/widgets/action/components/action_visual.dart';
import 'package:dnd_app/features/character/presentation/widgets/action/sheet/cast_spell_sheet.dart';
import 'package:dnd_app/features/spells/domain/entities/spell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionDetailSheet extends StatelessWidget {
  final CharacterAction action;
  final Color color;

  const ActionDetailSheet({
    super.key,
    required this.action,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Nota: El BlocProvider ya viene inyectado desde el showModalBottomSheet
    // en el archivo padre (action_card.dart), así que aquí consumimos directamente.

    return Padding(
      // Añadimos padding inferior extra para que el botón respire
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 1. CABECERA
          Row(
            children: <Widget>[
              ActionVisual(action: action, color: color, size: 50),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  action.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _FavoriteButton(action: action),
            ],
          ),

          const Divider(height: 32),

          // 2. STATS DETALLADOS
          // Se muestran solo si existen (null check)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              if (action.toHitModifier != null)
                _DetailStatItem(
                  label: "IMPACTO",
                  value: "+${action.toHitModifier}",
                  color: color,
                ),
              if (action.diceNotation != null)
                _DetailStatItem(
                  label: "DAÑO",
                  value: action.diceNotation!,
                  color: color,
                ),
              // Mostramos el coste o el stock restante
              _DetailStatItem(
                label: "USO",
                value: _getUsageText(), // Función auxiliar para texto dinámico
                color: Colors.grey,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 3. DESCRIPCIÓN
          const Text(
            "DESCRIPCIÓN",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            action.description,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),

          // 4. INFO TIPO DE DAÑO
          if (action.damageType != null) ...<Widget>[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.info_outline, color: color, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      getDamageTypeDescription(action.damageType!),
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 5. BOTÓN DE ACCIÓN PRINCIPAL (MEJORADO)
          const SizedBox(height: 40),
          _buildActionButton(context),
        ],
      ),
    );
  }

  // --- HELPER DE TEXTO ---
  String _getUsageText() {
    if (action.remainingUses != null) {
      if (action.maxUses != null) {
        return "${action.remainingUses}/${action.maxUses}";
      }
      return "x${action.remainingUses}";
    }
    return translateActionCost(action.cost);
  }

  // --- LÓGICA DEL BOTÓN DE ACCIÓN ---

  Widget _buildActionButton(BuildContext context) {
    // 1. Verificar disponibilidad (Stock)
    final bool isAvailable =
        action.remainingUses == null || action.remainingUses! > 0;

    // 2. Color dinámico (Gris si está agotado)
    final Color btnColor = isAvailable
        ? color
        : Theme.of(context).disabledColor;

    // 3. Texto e Icono Dinámicos
    String label = "REALIZAR ACCIÓN";
    IconData icon = Icons.flash_on;

    if (!isAvailable) {
      label = "AGOTADO";
      icon = Icons.block;
    } else if (action.type == ActionType.spell) {
      label = "LANZAR CONJURO";
      icon = Icons.auto_fix_high;
    } else if (action.resourceCost is ItemCost) {
      label = "USAR OBJETO";
      icon = Icons.local_drink;
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: btnColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Efecto visual de deshabilitado
          disabledBackgroundColor: Colors.grey.withValues(alpha: 0.2),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        // Si no está disponible, onPressed es null (lo deshabilita nativamente)
        onPressed: isAvailable ? () => _handleAction(context) : null,
      ),
    );
  }

  // DISPATCHER CENTRALIZADO (Igual que ActionQuickButton)
  void _handleAction(BuildContext context) {
    // Cerramos el modal inmediatamente para ver el efecto en la pantalla principal
    // EXCEPCIÓN: Si es un hechizo con selector de nivel, no cerramos aún.

    if (action.type == ActionType.spell) {
      _castSpell(context);
      return;
    }

    // Para el resto, cerramos el modal
    Navigator.pop(context);

    // Lógica según tipo
    switch (action.type) {
      case ActionType.attack:
        ScreenEffects.showSlash(context, color);
        HapticFeedback.heavyImpact();
        break;

      case ActionType.utility:
        _handleConsumable(context);
        break;

      case ActionType.feature:
        _handleFeature(context);
        break;

      default:
        break;
    }
  }

  void _handleConsumable(BuildContext context) {
    final ResourceCost? cost = action.resourceCost;
    if (cost is ItemCost) {
      ScreenEffects.showMagicBlast(context, color);
      context.read<CharacterBloc>().add(ConsumeItemEvent(itemId: cost.itemId));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("🧪 Usaste ${action.name}"),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleFeature(BuildContext context) {
    final ResourceCost? cost = action.resourceCost;
    if (cost is FeatureResourceCost) {
      ScreenEffects.showMagicBlast(context, color);
      context.read<CharacterBloc>().add(
        UseFeatureEvent(resourceId: cost.resourceId),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("⚡ ${action.name} activado"),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _castSpell(BuildContext context) {
    final CharacterState state = context.read<CharacterBloc>().state;
    if (state is CharacterLoaded) {
      try {
        final Spell spell = state.character.knownSpells.firstWhere(
          (Spell s) => s.id == action.id,
        );

        // Si es truco, cerramos y lanzamos. Si es de nivel, abrimos selector.
        if (spell.level == 0) {
          Navigator.pop(context); // Cerramos este modal
          ScreenEffects.showMagicBlast(context, color);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✨ Truco lanzado: ${spell.name}"),
              backgroundColor: color,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          // Cerramos este modal antes de abrir el siguiente para no apilar sheets
          Navigator.pop(context);

          showModalBottomSheet(
            context: context,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            isScrollControlled: true,
            builder: (_) => CastSpellSheet(
              spell: spell,
              bloc: context.read<CharacterBloc>(),
            ),
          );
        }
      } catch (e) {
        debugPrint("Error: No se encontró el hechizo original: $e");
      }
    }
  }
}

// Widget auxiliar privado (solo para el sheet)
class _DetailStatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _DetailStatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final CharacterAction action;

  const _FavoriteButton({required this.action});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterBloc, CharacterState>(
      builder: (BuildContext context, CharacterState state) {
        bool isFav = action.isFavorite;
        if (state is CharacterLoaded) {
          isFav = state.character.favoriteActionIds.contains(action.id);
        }

        return IconButton(
          onPressed: () {
            context.read<CharacterBloc>().add(
              ToggleFavoriteActionEvent(action.id),
            );
          },
          icon: Icon(
            isFav ? Icons.star : Icons.star_border,
            color: isFav ? Colors.amber : Colors.grey,
            size: 32,
          ),
        );
      },
    );
  }
}
