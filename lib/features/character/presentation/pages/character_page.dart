import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/character.dart';
import '../bloc/character_bloc.dart';
import '../widgets/character_stats_tab.dart';

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
                  _buildFixedHeader(context, char, theme),

                  const SizedBox(height: 20),

                  // 2. TABS (Pestañas)
                  TabBar(
                    labelColor: theme.colorScheme.secondary, // Dorado
                    unselectedLabelColor: Colors.grey,
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

                  // 3. CONTENIDO CAMBIANTE (PANEL INFERIOR)
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        // Tono "Bronce Oscuro / Café" (Warm Dark)
                        color: Color(0xFF25201B),
                        // Bordes redondeados superiores
                        borderRadius: BorderRadius.only(
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
                            // Pestaña General (Atributos y Salvaciones)
                            CharacterStatsTab(character: char),

                            // Placeholders
                            const Center(child: Text('Próximamente: Ataques')),
                            const Center(
                              child: Text('Próximamente: Inventario'),
                            ),
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

  // Widget para la parte superior que no cambia
  Widget _buildFixedHeader(
    BuildContext context,
    Character char,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          // Nombre
          Text(
            char.name.toUpperCase(),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white, // Blanco para contraste máximo
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          // Clase y Nivel
          Text(
            '${char.race} ${char.characterClass} - NVL ${char.level}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.secondary, // Dorado
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // Sección de Combate: Escudo y Vida
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // --- ESCUDO (CA) ---
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Icon(
                    Icons.shield,
                    size: 60,
                    color: theme.colorScheme.secondary, // Dorado
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 4),
                      Text(
                        char.armorClass.toString(),
                        style: const TextStyle(
                          color: Colors.black, // Negro sobre Dorado
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          height: 1.0,
                        ),
                      ),
                      const Text(
                        "CA",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // --- BARRA DE VIDA INTERACTIVA ---
              Expanded(
                child: InkWell(
                  onTap: () => _showHealthDialog(context, char),
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'PUNTOS DE GOLPE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          // Valores de HP + Icono de edición
                          Row(
                            children: <Widget>[
                              Text(
                                '${char.currentHp} / ${char.maxHp}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.edit,
                                size: 12,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: char.healthPercentage,
                          minHeight: 12,
                          color: char.isBloodied
                              ? Colors.red[900]
                              : const Color(0xFFC62828),
                          backgroundColor: Colors.grey.withValues(alpha: 0.2),
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

  // DIÁLOGO PARA MODIFICAR VIDA
  void _showHealthDialog(BuildContext context, Character char) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E), // Fondo oscuro
        title: const Text(
          "Modificar Vida",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 24),
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            hintText: "Cantidad",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFFD700)),
            ),
          ),
        ),
        actions: <Widget>[
          // Botón DAÑO (Negativo)
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
          // Botón CURAR (Positivo)
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
