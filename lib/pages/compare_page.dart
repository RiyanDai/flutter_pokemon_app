import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/data/remote_data_source.dart';
import 'package:test_app/pages/bloc/pokemon_bloc.dart';
import 'package:test_app/models/pokemon.dart';
import 'package:fl_chart/fl_chart.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  Pokemon? _selectedPokemon1;
  Pokemon? _selectedPokemon2;

  void _showPokemonListDialog(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocBuilder<PokemonBloc, PokemonState>(
          builder: (context, state) {
            if (state is PokemonLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PokemonLoaded) {
              final pokemons = state.pokemons;
              return ListView.builder(
                itemCount: pokemons.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(pokemons[i].name,
                        style: const TextStyle(color: Colors.black)),  
                    onTap: () {
                      setState(() {
                        if (index == 1) {
                          _selectedPokemon1 = pokemons[i];
                        } else {
                          _selectedPokemon2 = pokemons[i];
                        }
                      });
                      Navigator.pop(context);  
                    },
                  );
                },
              );
            }
            return const Center(child: Text("Error loading Pokémon"));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Compare Pokémon',
                  style: TextStyle(color: Colors.white, fontSize: 35)),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPokemonSelectionCard(1, _selectedPokemon1, Colors.blue),
                  _buildPokemonSelectionCard(2, _selectedPokemon2, Colors.red),
                ],
              ),
              const SizedBox(height: 20),
              if (_selectedPokemon1 != null && _selectedPokemon2 != null) ...[
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              final titles = {
                                0: 'A',
                                1: 'B',
                              };

                              for (int i = 0; i < _selectedPokemon1!.stats.length; i++) {
                                titles[i + 2] = String.fromCharCode(67 + i);
                              }

                              return Text(titles[value.toInt()] ?? '');
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      barGroups: _createBarGroups(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Legend:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    const Text('A = Height',
                        style: TextStyle(color: Colors.white)),
                    const Text('B = Weight',
                        style: TextStyle(color: Colors.white)),
                    ..._selectedPokemon1!.stats.keys.map((key) {
                      final index = _selectedPokemon1!.stats.keys.toList().indexOf(key) + 2;
                      return Text('${String.fromCharCode(67 + index)} = $key',
                          style: const TextStyle(color: Colors.white));
                    }).toList(),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue.withOpacity(0.5),
    );
  }

  Widget _buildPokemonSelectionCard(int index, Pokemon? selectedPokemon, Color color) {
    return GestureDetector(
      onTap: () => _showPokemonListDialog(index),
      child: Card(
        elevation: 4,
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selectedPokemon != null) ...[
                Image.network(
                  selectedPokemon.spriteUrl,
                  height: 100,
                ),
                const SizedBox(height: 8),
                Text(
                  selectedPokemon.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ] else ...[
                const Text(
                  "Select Pokémon",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: _selectedPokemon1!.height.toDouble(),
            color: Colors.blue,
          ),
          BarChartRodData(
            toY: _selectedPokemon2!.height.toDouble(),
            color: Colors.red,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: _selectedPokemon1!.weight.toDouble(),
            color: Colors.blue,
          ),
          BarChartRodData(
            toY: _selectedPokemon2!.weight.toDouble(),
            color: Colors.red,
          ),
        ],
      ),
      ..._selectedPokemon1!.stats.entries.map((entry) {
        return BarChartGroupData(
          x: _selectedPokemon1!.stats.keys.toList().indexOf(entry.key) + 2,
          barRods: [
            BarChartRodData(
              toY: entry.value.toDouble(),
              color: Colors.blue,
            ),
            BarChartRodData(
              toY: _selectedPokemon2!.stats[entry.key]?.toDouble() ?? 0,
              color: Colors.red,
            ),
          ],
        );
      }).toList(),
    ];
  }
}
