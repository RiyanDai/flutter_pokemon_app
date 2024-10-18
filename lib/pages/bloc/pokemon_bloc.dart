import 'package:bloc/bloc.dart';
import 'package:test_app/data/remote_data_source.dart';
import 'package:test_app/models/pokemon.dart';
import 'package:meta/meta.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final RemoteDataSource remoteDataSource;

  PokemonBloc({required this.remoteDataSource}) : super(PokemonInitial()) {
    on<LoadPokemon>((event, emit) async {
      emit(PokemonLoading());
      try {
        final List<Pokemon> pokemons = await remoteDataSource.getPokemons();  
        emit(PokemonLoaded(pokemons)); 
      } catch (error) {
        emit(PokemonError(error.toString()));  
      }
    });
    

    // Handler untuk memuat detail Pokémon
    on<LoadPokemonDetail>((event, emit) async {
      emit(PokemonLoading());
      try {
        final Pokemon pokemon = await remoteDataSource.getPokemonDetail(event.idOrName);
        emit(PokemonDetailLoaded(pokemon));
      } catch (error) {
        emit(PokemonError(error.toString()));
      }
    });

  }
}