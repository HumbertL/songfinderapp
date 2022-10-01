import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songfinderapp/pages/SongWidget.dart';
import 'package:songfinderapp/providers/FavoritesProvider.dart';

class FavoriteSongs extends StatelessWidget {
  const FavoriteSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
            itemCount: context.watch<FavoritesProvider>().getSongList.length,
            itemBuilder: (BuildContext context, index) {
              var favoritesong =
                  context.read<FavoritesProvider>().getSongList[index];
              return SongWidget(songObject: favoritesong);
            }));
  }
}
