import 'package:flutter/material.dart';

import '../../../../../core/constants/skills.dart';
import '../../../domain/entities/character.dart';

class SkillsList extends StatefulWidget {
  final Character character;

  const SkillsList({super.key, required this.character});

  @override
  State<SkillsList> createState() => _SkillsListState();
}

class _SkillsListState extends State<SkillsList> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Character char = widget.character;

    // LÓGICA DE QUÉ MOSTRAR:
    // 1. Siempre mostramos: Expertas, Competentes y Percepción (por ser la más usada).
    // 2. Si _showAll es true, mostramos todo.
    final Set<Skill> skillsToDisplaySet = <Skill>{};

    if (_showAll) {
      skillsToDisplaySet.addAll(Skill.values);
    } else {
      skillsToDisplaySet.addAll(char.expertSkills);
      skillsToDisplaySet.addAll(char.proficientSkills);
      skillsToDisplaySet.add(Skill.perception); // Percepción siempre visible
      skillsToDisplaySet.add(Skill.stealth); // Sigilo suele ser vital también
    }

    final List<Skill> skillsList = skillsToDisplaySet.toList()
      ..sort((Skill a, Skill b) => a.name.compareTo(b.name));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Cabecera con Toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("COMPETENCIAS", style: theme.textTheme.titleLarge),
            InkWell(
              onTap: () => setState(() => _showAll = !_showAll),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  _showAll ? "VER MENOS" : "VER TODAS",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Lista de Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skillsList.map((Skill skill) {
            return _SkillChip(skill: skill, character: char);
          }).toList(),
        ),
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  final Skill skill;
  final Character character;

  const _SkillChip({required this.skill, required this.character});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // 1. Determinar Estado
    final bool isExpert = character.expertSkills.contains(skill);
    final bool isProficient = character.proficientSkills.contains(skill);

    // 2. Calcular Bono
    final int bonus = character.getSkillBonus(skill);
    final String sign = bonus >= 0 ? '+' : '';

    // 3. Configuración Visual (El estilo Stitch)
    final Color accentColor = theme.colorScheme.secondary; // Dorado
    final Color neutralColor = Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        // Fondo oscuro sutil (#2c2716 en tu theme)
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          // Borde sutil, un poco más brillante si es experto
          color: isExpert
              ? accentColor.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // --- EL INDICADOR (DOT / ICON) ---
          if (isExpert)
            // EXPERTO: Estrella Dorada (Diferenciación clara)
            Icon(Icons.stars, size: 14, color: accentColor)
          else if (isProficient)
            // COMPETENTE: Círculo Dorado Sólido
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.4),
                    blurRadius: 4,
                  ),
                ],
              ),
            )
          else
            // NORMAL: Círculo Gris (Anillo o sólido apagado)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: neutralColor, width: 1.5),
                shape: BoxShape.circle,
              ),
            ),

          const SizedBox(width: 8),

          // --- NOMBRE ---
          Text(
            skill.name.toUpperCase(), // Capitalizado estilo RPG
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              // Si no es competente, texto un poco más gris
              color: (isExpert || isProficient)
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),

          const SizedBox(width: 6),

          // --- VALOR (+5) ---
          Text(
            "$sign$bonus",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800, // Número gordito
              // El número siempre se ve bien, pero destaca en dorado si eres experto
              color: isExpert ? accentColor : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
