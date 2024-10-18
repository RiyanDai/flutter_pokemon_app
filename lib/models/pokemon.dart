 

class DataPokemon {
  final List<Pokemon> data;

  DataPokemon({
    required this.data,
  });

  factory DataPokemon.fromJson(Map<String, dynamic> json) {
    return DataPokemon(
      data: List<Pokemon>.from(
        json['results'].map((pokemon) => Pokemon.fromJson(pokemon)),
      ),
    );
  }
}


class Pokemon {
  final String name;
  final String spriteUrl;
  final int height;
  final int weight;
  final Map<String, int> stats;

  Pokemon({
    required this.name,
    required this.spriteUrl,
    required this.height,
    required this.weight,
    required this.stats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Map stats
    Map<String, int> stats = {};
    for (var stat in json['stats']) {
      String statName = stat['stat']['name'];
      int baseStat = stat['base_stat'];
      stats[statName] = baseStat;
    }

    return Pokemon(
      name: json['name'],
      spriteUrl: json['sprites']['front_default'] ?? '',
      height: json['height'],
      weight: json['weight'],
      stats: stats,
    );
  }
}