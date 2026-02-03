import 'package:dnd_app/features/character/presentation/widgets/character_actions_tab.dart';
import 'package:dnd_app/features/character/presentation/widgets/character_inventory_tab.dart';
import 'package:dnd_app/features/character/presentation/widgets/general/character_features_list.dart';
import 'package:dnd_app/features/character/presentation/widgets/rest_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/character.dart';
import '../bloc/character_bloc.dart';
import '../widgets/character_stats_tab.dart';
import '../widgets/character_summary_header.dart';

class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CharacterBloc>(
      create: (_) => sl<CharacterBloc>()..add(GetCharacterEvent()),
      child: const CharacterView(),
    );
  }
}

class CharacterView extends StatelessWidget {
  const CharacterView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () {},
          ),
          actions: const <Widget>[RestMenuButton(), SizedBox(width: 8)],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<CharacterBloc, CharacterState>(
          builder: (BuildContext context, CharacterState state) {
            return switch (state) {
              CharacterLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              CharacterError(message: final String msg) => Center(
                  child: Text('Se ha producido un error: $msg'),
                ),
              CharacterLoaded(character: final Character char) => Container(
                  color: theme.colorScheme.surface,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      CharacterSummaryHeader(character: char),
                      const SizedBox(height: 16),
                      TabBar(
                        labelColor: theme.colorScheme.secondary,
                        unselectedLabelColor:
                            theme.colorScheme.onSurface.withOpacity(0.5),
                        indicatorColor: theme.colorScheme.secondary,
                        indicatorSize: TabBarIndicatorSize.label,
                        dividerColor: Colors.transparent,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        tabs: const <Widget>[
                          Tab(text: 'ESTADÍSTICAS'),
                          Tab(text: 'ACCIONES'),
                          Tab(text: 'INVENTARIO'),
                          Tab(text: 'RASGOS'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            child: TabBarView(
                              children: <Widget>[
                                CharacterStatsTab(character: char),
                                CharacterActionsTab(character: char),
                                CharacterInventoryTab(character: char),
                                CharacterFeaturesList(features: char.features),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
