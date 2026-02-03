import 'package:flutter/material.dart';

import '../../../../core/constants/attributes.dart';
import '../../../../core/constants/damage_type.dart';
import '../../../../core/constants/skills.dart';
import '../../domain/entities/character.dart';
import 'general/character_bio.dart';

class CharacterStatsTab extends StatefulWidget {
  final Character character;

  const CharacterStatsTab({super.key, required this.character});

  @override
  State<CharacterStatsTab> createState() => _CharacterStatsTabState();
}

class _CharacterStatsTabState extends State<CharacterStatsTab> {
  bool _showSavingThrows = false;
  bool _showAllSkills = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Character char = widget.character;

    final bool hasDefenses = char.resistances.isNotEmpty ||
        char.immunities.isNotEmpty ||
        char.vulnerabilities.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 1. ATTRIBUTES
          _buildSectionHeader(
            theme: theme,
            title: _showSavingThrows ? 'SALVACIONES' : 'ATRIBUTOS',
            actionLabel:
                _showSavingThrows ? 'VER ATRIBUTOS' : 'VER SALVACIONES',
            onActionTap: () =>
                setState(() => _showSavingThrows = !_showSavingThrows),
            icon: Icons.swap_horiz,
          ),
          const SizedBox(height: 16),
          Center(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: Attribute.values.map((Attribute attr) {
                return _buildStatBox(attr, char, theme);
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          // 2. PASSIVE PERCEPTION
          _buildPassivePerceptionRow(char, theme),
          const SizedBox(height: 32),
          // 3. DEFENSES (Now with Header and Legend)
          _buildDefensesSection(char, theme, context),
          if (hasDefenses) ...<Widget>[
            const SizedBox(height: 32),
          ] else ...<Widget>[
            const SizedBox(height: 24),
          ],
          // 4. SKILLS
          _buildSectionHeader(
            theme: theme,
            title: 'HABILIDADES',
            actionLabel: _showAllSkills ? 'MOSTRAR MENOS' : 'MOSTRAR TODO',
            onActionTap: () => setState(() => _showAllSkills = !_showAllSkills),
            icon: _showAllSkills ? Icons.expand_less : Icons.expand_more,
          ),
          const SizedBox(height: 16),
          _buildSkillsList(char, theme),
          const SizedBox(height: 32),
          Divider(color: theme.dividerColor),
          const SizedBox(height: 32),
          // 5. BIO
          CharacterBio(character: char),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ===========================================================================
  // HELPER WIDGETS
  // ===========================================================================

  /// Defenses Section with Unified Header and Help Button
  Widget _buildDefensesSection(
    Character char,
    ThemeData theme,
    BuildContext context,
  ) {
    if (char.resistances.isEmpty &&
        char.immunities.isEmpty &&
        char.vulnerabilities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 1. UNIFIED HEADER
        _buildSectionHeader(
          theme: theme,
          title: 'DEFENSAS',
          actionLabel: 'LEYENDA', // Button to explain colors
          icon: Icons.help_outline,
          onActionTap: () => _showDefenseLegendDialog(context, theme),
        ),
        const SizedBox(height: 16),
        // 2. DEFENSE CHIPS
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: <Widget>[
              // Resistances (Gold/Amber)
              ...char.resistances.map(
                (DamageType res) => _buildDefenseChip(
                  damageType: res,
                  color: const Color(0xFFFFC107), // Amber
                  theme: theme,
                ),
              ),
              // Immunities (Green)
              ...char.immunities.map(
                (DamageType imm) => _buildDefenseChip(
                  damageType: imm,
                  color: const Color(0xFF4CAF50), // Green
                  theme: theme,
                ),
              ),
              // Vulnerabilities (Red)
              ...char.vulnerabilities.map(
                (DamageType vul) => _buildDefenseChip(
                  damageType: vul,
                  color: const Color(0xFFEF5350), // Soft Red
                  theme: theme,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Legend Popup to explain the colors
  void _showDefenseLegendDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surfaceContainer,
        title: Text("Guía de Defensa", style: theme.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildLegendRow(
              Icons.shield_outlined,
              "Resistencia",
              "Recibes la MITAD de daño.",
              const Color(0xFFFFC107),
              theme,
            ),
            const SizedBox(height: 16),
            _buildLegendRow(
              Icons.health_and_safety,
              "Inmunidad",
              "NO recibes daño.",
              const Color(0xFF4CAF50),
              theme,
            ),
            const SizedBox(height: 16),
            _buildLegendRow(
              Icons.broken_image_outlined,
              "Vulnerabilidad",
              "Recibes el DOBLE de daño.",
              const Color(0xFFEF5350),
              theme,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              "ENTENDIDO",
              style: TextStyle(color: theme.colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendRow(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    ThemeData theme,
  ) {
    return Row(
      children: <Widget>[
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefenseChip({
    required DamageType damageType,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(damageType.icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            damageType.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassivePerceptionRow(Character char, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.visibility,
                size: 18,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 10),
              Text(
                "PERCEPCIÓN PASIVA",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          Text(
            "${char.passivePerception}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required ThemeData theme,
    required String title,
    required String actionLabel,
    required VoidCallback onActionTap,
    required IconData icon,
  }) {
    return Row(
      children: <Widget>[
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(title, style: theme.textTheme.titleLarge),
        const Spacer(),
        InkWell(
          onTap: onActionTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: <Widget>[
                Text(
                  actionLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(icon, size: 14, color: theme.colorScheme.secondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(Attribute attr, Character char, ThemeData theme) {
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

    return SizedBox(
      width: 105,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: (_showSavingThrows && isProficient)
                ? theme.colorScheme.secondary
                : theme.colorScheme.secondary.withOpacity(0.15),
            width: (_showSavingThrows && isProficient) ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: <Widget>[
            Text(
              attr.abbr,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$sign$valueToShow',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            if (!_showSavingThrows)
              Text(
                score.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.secondary,
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
                  : const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsList(Character char, ThemeData theme) {
    final Set<Skill> skillsToDisplaySet = <Skill>{};

    if (_showAllSkills) {
      skillsToDisplaySet.addAll(Skill.values);
    } else {
      skillsToDisplaySet.addAll(char.expertSkills);
      skillsToDisplaySet.addAll(char.proficientSkills);
      skillsToDisplaySet.add(Skill.perception);
      skillsToDisplaySet.add(Skill.stealth);
    }

    final List<Skill> skillsList = skillsToDisplaySet.toList()
      ..sort(
        (Skill a, Skill b) => _getSkillName(a).compareTo(_getSkillName(b)),
      );

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skillsList
          .map((Skill skill) => _buildSkillChip(skill, char, theme))
          .toList(),
    );
  }

  Widget _buildSkillChip(Skill skill, Character char, ThemeData theme) {
    final bool isExpert = char.expertSkills.contains(skill);
    final bool isProficient = char.proficientSkills.contains(skill);
    final bool isTrained = isExpert || isProficient;

    final int bonus = char.getSkillBonus(skill);
    final String sign = bonus >= 0 ? '+' : '';
    final Color accentColor = theme.colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isTrained
              ? accentColor.withOpacity(0.5)
              : theme.colorScheme.onSurface.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (isExpert)
            Icon(Icons.stars, size: 14, color: accentColor)
          else if (isProficient)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: accentColor.withOpacity(0.4),
                    blurRadius: 4,
                  ),
                ],
              ),
            )
          else
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  width: 1.5,
                ),
                shape: BoxShape.circle,
              ),
            ),
          const SizedBox(width: 8),
          Text(
            _getSkillName(skill),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isTrained
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            "$sign$bonus",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isTrained ? accentColor : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  String _getSkillName(Skill skill) {
    return switch (skill) {
      Skill.acrobatics => 'ACROBACIAS',
      Skill.animalHandling => 'TRATO CON ANIMALES',
      Skill.arcana => 'ARCANO',
      Skill.athletics => 'ATLETISMO',
      Skill.deception => 'ENGAÑO',
      Skill.history => 'HISTORIA',
      Skill.insight => 'PERSPICACIA',
      Skill.intimidation => 'INTIMIDACIÓN',
      Skill.investigation => 'INVESTIGACIÓN',
      Skill.medicine => 'MEDICINA',
      Skill.nature => 'NATURALEZA',
      Skill.perception => 'PERCEPCIÓN',
      Skill.performance => 'INTERPRETACIÓN',
      Skill.persuasion => 'PERSUASIÓN',
      Skill.religion => 'RELIGIÓN',
      Skill.sleightOfHand => 'JUEGO DE MANOS',
      Skill.stealth => 'SIGILO',
      Skill.survival => 'SUPERVIVENCIA',
    };
  }
}
