import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/data/remote_data_source.dart';
import 'package:test_app/pages/bloc/pokemon_bloc.dart'; 
import 'package:test_app/pages/home_page.dart';
void main() {
  runApp(
    BlocProvider(
      create: (context) => PokemonBloc(remoteDataSource: RemoteDataSource())..add(LoadPokemon()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokémon App',
      home: const HomePage(),
    );
  }
}
