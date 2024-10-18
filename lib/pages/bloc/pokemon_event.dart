part of 'pokemon_bloc.dart';

@immutable
sealed class PokemonEvent {}

final class LoadPokemon extends PokemonEvent {}

 
final class LoadPokemonDetail extends PokemonEvent {
  final String idOrName;  

  LoadPokemonDetail(this.idOrName);
}


