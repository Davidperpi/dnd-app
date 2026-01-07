import 'package:flutter/material.dart';

import '../../../../core/constants/attributes.dart';
import '../../domain/entities/character.dart';

class CharacterStatsTab extends StatefulWidget {
  final Character character;

  const CharacterStatsTab({super.key, required this.character});

  @override
  State<CharacterStatsTab> createState() => _CharacterStatsTabState();
}

class _CharacterStatsTabState extends State<CharacterStatsTab> {
  bool _showSavingThrows = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Character char = widget.character;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // --- TÍTULO CON BARRA VERTICAL DORADA (Estilo TAV) ---
          Row(
            children: <Widget>[
              // La barra amarilla vertical característica
              Container(
                width: 3,
                height: 18,
                color: theme.colorScheme.secondary, // Amarillo puro
              ),
              const SizedBox(width: 8),

              // Título
              Text(
                _showSavingThrows ? 'SALVACIONES' : 'ATRIBUTOS',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.9), // Blanco hueso
                ),
              ),

              const Spacer(),

              // Botón Toggle
              InkWell(
                onTap: () =>
                    setState(() => _showSavingThrows = !_showSavingThrows),
                child: Row(
                  children: <Widget>[
                    Text(
                      _showSavingThrows ? 'VER ATRIBUTOS' : 'VER SALVACIONES',
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios, // Flechita más sutil
                      size: 10,
                      color: theme.colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- GRID ---
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: Attribute.values.map((Attribute attr) {
              return _buildStatBox(attr, char, theme);
            }).toList(),
          ),

          // ... (resto del código de nota al pie igual)
        ],
      ),
    );
  }

  Widget _buildStatBox(Attribute attr, Character char, ThemeData theme) {
    // ... (Lógica de obtención de score igual que antes) ...
    final int score = char.getScore(attr);
    int valueToShow;
    bool isProficient = false;
    if (_showSavingThrows) {
      valueToShow = char.getSavingThrow(attr);
      isProficient = char.proficientSaves.contains(attr);
    } else {
      valueToShow = char.getModifier(score);
    }
    final String sign = valueToShow >= 0 ? '+' : '';

    // DISEÑO DE TARJETA ACTUALIZADO
    return SizedBox(
      width: 105,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          // Fondo oscuro (casi negro)
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(8), // Menos redondeado, más serio
          border: Border.all(
            // Borde sutil dorado para TODOS, más brillante si es competente
            color: (_showSavingThrows && isProficient)
                ? theme.colorScheme.secondary
                : theme.colorScheme.secondary.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Column(
          children: <Widget>[
            Text(
              attr.abbr,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400], // Gris claro
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$sign$valueToShow',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),

            // Puntuación base o icono
            if (!_showSavingThrows)
              Text(
                score.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color:
                      theme.colorScheme.secondary, // Numero pequeño en dorado
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              isProficient
                  ? Icon(
                      Icons.check,
                      color: theme.colorScheme.secondary,
                      size: 16,
                    )
                  : const SizedBox(
                      height: 16,
                    ), // Espacio vacío si no es competente
          ],
        ),
      ),
    );
  }
}
