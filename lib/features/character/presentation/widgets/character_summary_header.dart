// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/character.dart';
import '../bloc/character_bloc.dart';

class CharacterSummaryHeader extends StatelessWidget {
  final Character character;

  const CharacterSummaryHeader({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String initSign = character.initiative >= 0 ? '+' : '';

    // Detectamos si es un lanzador de conjuros
    final bool hasMagic = character.spellSlotsMax.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          // 1. NOMBRE Y CLASE
          Text(
            character.name.toUpperCase(),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${character.race} ${character.characterClass} - NVL ${character.level}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.secondary,
              fontSize: 12,
              letterSpacing: 1.0,
            ),
          ),

          // --- NUEVA SECCIÓN: BARRA DE MAGIA COMPACTA ---
          if (hasMagic) ...<Widget>[
            const SizedBox(height: 12), // Espacio sutil
            _buildCompactSpellSlots(context, theme),
            const SizedBox(height: 12),
          ] else
            const SizedBox(height: 20), // Espacio original si no hay magia
          // 2. ZONA DE COMBATE (AC, Vida, Stats)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // --- A. CA (ESCUDO) ---
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Icon(
                    Icons.shield,
                    size: 55,
                    color: theme.colorScheme.secondary,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 2),
                      Text(
                        character.armorClass.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          height: 1.0,
                        ),
                      ),
                      const Text(
                        "CA",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // --- B. VIDA + STATS PEQUEÑOS ---
              Expanded(
                child: InkWell(
                  onTap: () => _showHealthDialog(context, theme),
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'PUNTOS DE GOLPE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),

                          Row(
                            children: <Widget>[
                              _buildMiniStat(
                                Icons.bolt,
                                "$initSign${character.initiative}",
                                theme,
                              ),
                              const SizedBox(width: 12),
                              _buildMiniStat(
                                Icons.directions_run,
                                _formatSpeed(character.speed),
                                theme,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // NÚMEROS DE VIDA
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${character.currentHp}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: theme.colorScheme.onSurface,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            ' / ${character.maxHp}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // BARRA DE PROGRESO
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: character.healthPercentage,
                          minHeight: 10,
                          color: _getHpColor(character.healthPercentage),
                          backgroundColor: theme.colorScheme.onSurface
                              .withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES DE MAGIA ---
  Widget _buildCompactSpellSlots(BuildContext context, ThemeData theme) {
    final List<int> levels = character.spellSlotsMax.keys.toList()..sort();

    const Color magicColor = Color(0xFFBA68C8);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: magicColor.withValues(alpha: 0.2)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: levels.map((int level) {
          final int max = character.spellSlotsMax[level] ?? 0;
          final int current = character.spellSlotsCurrent[level] ?? 0;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Etiqueta de Nivel más compacta
              Text(
                "N$level",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900, // Extra bold para legibilidad
                  color: magicColor.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 4),
              // Los puntitos
              ...List.generate(max, (int index) {
                final bool isAvailable = index < current;
                return Container(
                  margin: const EdgeInsets.only(
                    left: 3,
                  ), // Un pelín más separado
                  width: 7, // Ligeramente más pequeños para ganar espacio
                  height: 7,
                  decoration: BoxDecoration(
                    color: isAvailable ? magicColor : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: magicColor, width: 1),
                  ),
                );
              }),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _formatSpeed(int feet) {
    final double meters = (feet / 5) * 1.5;
    if (meters % 1 == 0) {
      return "${meters.toInt()}m";
    } else {
      return "${meters.toStringAsFixed(1)}m";
    }
  }

  Widget _buildMiniStat(IconData icon, String value, ThemeData theme) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 14, color: theme.colorScheme.secondary),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Color _getHpColor(double percent) {
    if (percent > 0.5) return const Color(0xFF4CAF50);
    if (percent > 0.25) return const Color(0xFFFFC107);
    return const Color(0xFFC62828);
  }

  void _showHealthDialog(BuildContext context, ThemeData theme) {
    // ... (Tu código existente del diálogo) ...
    // Solo asegúrate de copiarlo completo del archivo anterior si lo necesitas
    // o avísame si quieres que te lo vuelva a pegar aquí.
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surfaceContainer,
        title: Text(
          "Modificar Vida",
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 24),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: "Cantidad",
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.broken_image, color: Colors.redAccent),
            label: const Text(
              "DAÑO",
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () {
              final int? amount = int.tryParse(controller.text);
              if (amount != null) {
                context.read<CharacterBloc>().add(UpdateHealthEvent(-amount));
                Navigator.of(ctx).pop();
              }
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.favorite, color: Colors.greenAccent),
            label: const Text(
              "CURAR",
              style: TextStyle(color: Colors.greenAccent),
            ),
            onPressed: () {
              final int? amount = int.tryParse(controller.text);
              if (amount != null) {
                context.read<CharacterBloc>().add(UpdateHealthEvent(amount));
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
