import 'package:dnd_app/features/character/presentation/widgets/character_inventory_tab.dart';
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () {},
          ),
          actions: <Widget>[
            IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          ],
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
                child: Text('Error: $msg'),
              ),
              CharacterLoaded(character: final Character char) => Column(
                children: <Widget>[
                  // 1. CABECERA FIJA
                  CharacterSummaryHeader(character: char),

                  const SizedBox(height: 20),

                  // 2. TABS
                  TabBar(
                    labelColor: theme.colorScheme.secondary,
                    unselectedLabelColor: theme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                    indicatorColor: theme.colorScheme.secondary,
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: Colors.transparent,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    tabs: const <Widget>[
                      Tab(text: 'GENERAL'),
                      Tab(text: 'ACCIONES'),
                      Tab(text: 'EQUIPO'),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 3. CONTENIDO CAMBIANTE
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        // CORREGIDO: Usamos el gris carbón del tema
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
                            const Center(child: Text('Próximamente: Ataques')),
                            CharacterInventoryTab(character: char),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
