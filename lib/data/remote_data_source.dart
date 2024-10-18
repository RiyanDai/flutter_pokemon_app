import 'package:test_app/models/pokemon.dart';
import 'package:dio/dio.dart';

 

class RemoteDataSource {
  final dio = Dio(BaseOptions(baseUrl: "https://pokeapi.co/api/v2"));
 
  Future<List<Pokemon>> getPokemons() async {
    try {
      final response = await dio.get("/pokemon");
      final List<dynamic> results = response.data['results'];

      List<Pokemon> pokemons = [];
      for (var pokemon in results) {
      
        final detailsResponse = await dio.get(pokemon['url']);
        final pokemonDetail = Pokemon.fromJson(detailsResponse.data);
        pokemons.add(pokemonDetail);
      }
      return pokemons;
    } catch (error) {
      throw Exception("Failed to load Pokémon: $error");
    }
  }
 
  Future<Pokemon> getPokemonDetail(String idOrName) async {
    try {
      final response = await dio.get("/pokemon/$idOrName");
      return Pokemon.fromJson(response.data);
    } catch (error) {
      throw Exception("Failed to load Pokémon detail: $error");
    }
  }
}