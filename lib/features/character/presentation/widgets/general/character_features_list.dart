import 'package:dnd_app/features/character/domain/entities/character_feature.dart';
import 'package:dnd_app/features/character/presentation/widgets/general/feature_card.dart';
import 'package:flutter/material.dart';

class CharacterFeaturesList extends StatelessWidget {
  const CharacterFeaturesList({super.key, required this.features});

  final List<CharacterFeature> features;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: features.length,
      itemBuilder: (context, index) {
        return FeatureCard(feature: features[index]);
      },
    );
  }
}
