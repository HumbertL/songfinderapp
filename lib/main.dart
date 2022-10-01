import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:songfinderapp/bloc/record_audio_bloc.dart';
import 'package:songfinderapp/pages/HomePage.dart';
import 'providers/FavoritesProvider.dart';

void main() => runApp(ChangeNotifierProvider(
    create: (context) => FavoritesProvider(), child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        theme: ThemeData.dark(),
        home: BlocProvider(
          create: (context) => RecordAudioBloc(),
          child: HomePage(),
        ));
  }
}
