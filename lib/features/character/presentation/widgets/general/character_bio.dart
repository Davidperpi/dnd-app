import 'package:flutter/material.dart';

import '../../../domain/entities/character.dart';

class CharacterBio extends StatelessWidget {
  final Character character;

  const CharacterBio({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // --- HEADER IMAGE ---
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.secondary.withOpacity(0.2),
            ),
            image: DecorationImage(
              image: AssetImage(character.imageUrl),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.transparent,
                  // FIXED: We use the scaffold background for a perfect fade
                  theme.scaffoldBackgroundColor,
                ],
                stops: const <double>[0.6, 1.0],
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // --- SECTION TITLE ---
        Text(
          "TRASFONDO",
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 14,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 10),

        // --- DESCRIPTIVE TEXT ---
        Text(
          character.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.6,
            // Text color with theme opacity
            color: theme.colorScheme.onSurface.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
