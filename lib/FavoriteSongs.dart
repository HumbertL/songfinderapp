import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:songfinderapp/pages/Song.dart';
import 'package:songfinderapp/pages/SongWidget.dart';
import 'package:songfinderapp/pages/usersongs/bloc/user_songs_provider_bloc.dart';
import 'package:songfinderapp/providers/FavoritesProvider.dart';

class FavoriteSongs extends StatelessWidget {
  const FavoriteSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<UserSongsProviderBloc, UserSongsProviderState>(
          builder: (context, state) {
            if (state is SongsLoading) {
              return ListView.builder(
                itemCount: 15,
                itemBuilder: (BuildContext context, int index) {
                  return PlayStoreShimmer();
                },
              );
            } else if (state is NoSongsAvailable) {
              return Center(
                child: Text("Nada disponible"),
              );
            } else if (state is UserSongsSuccess) {
              return ListView.builder(
                itemCount: state.mySongs.length,
                itemBuilder: (BuildContext context, int index) {
                  var song = Song.fromDocument(state.mySongs[index]);
                  return SongWidget(songObject: song);
                },
              );
            }
            return Center();
          },
          listener: (context, state) {},
        ));
  }
}
