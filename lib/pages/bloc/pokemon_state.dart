  part of 'pokemon_bloc.dart';

  @immutable
  sealed class PokemonState {}

  final class PokemonInitial extends PokemonState {}

  final class PokemonLoading extends PokemonState {}

  final class PokemonLoaded extends PokemonState {
    final List<Pokemon> pokemons;
    PokemonLoaded(this.pokemons);

  }

 
  final class PokemonDetailLoaded extends PokemonState {
    final Pokemon pokemon;
    PokemonDetailLoaded(this.pokemon);
  }


  final class PokemonError extends PokemonState {
    final String error;
    PokemonError(this.error);
  }


