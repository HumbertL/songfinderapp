import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:songfinderapp/pages/HomePage.dart';
import 'package:songfinderapp/pages/SongWidget.dart';
import 'package:songfinderapp/providers/FavoritesProvider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Song.dart';

class FoundSong extends StatefulWidget {
  final Song SongData;
  const FoundSong({
    Key? key,
    required this.SongData,
  }) : super(key: key);

  @override
  State<FoundSong> createState() => _FoundSongState();
}

class _FoundSongState extends State<FoundSong> {
  @override
  Widget build(BuildContext context) {
    bool isitafavorite;

    return Scaffold(
      appBar: AppBar(
        title: Text("Here you go"),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: (() {
                  FavoriteorNot(context, widget.SongData);
                }),
                child: const Icon(Icons.favorite),
              ))
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network("${widget.SongData.spotifyImageUrl}"),
          ),
          SongDetailText("${widget.SongData.songtitle}", 25),
          SongDetailText("${widget.SongData.album}", 20),
          SongDetailSubtitleText(texto: "${widget.SongData.artist}", size: 15),
          SongDetailSubtitleText(
              texto: "${widget.SongData.releaseDate}", size: 10),
          Divider(),
          Text(
            "Abrir con",
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              openInAppButton(
                  url: "${widget.SongData.spotifySongLink}",
                  tooltiptext: "Abrir en spotify",
                  iconlogo: Icon(FontAwesomeIcons.spotify)),
              openInAppButton(
                  url: "${widget.SongData.songLink}",
                  tooltiptext: "Abrir en Deezer",
                  iconlogo: Icon(FontAwesomeIcons.recordVinyl)),
              openInAppButton(
                  url: "${widget.SongData.AppleSongLink}",
                  tooltiptext: "Abrir en apple music",
                  iconlogo: Icon(FontAwesomeIcons.apple))
            ],
          )
        ],
      ),
    );
  }

  Future<void> FavoriteorNot(BuildContext context, Song songobject) async {
    bool isitafavorite = await context
        .read<FavoritesProvider>()
        .isAlreadyInFavorites(songobject);
    if (isitafavorite == true) {
      FavoriteWarningDialog(context, songobject);
    } else {
      context.read<FavoritesProvider>().addNewSong(songobject);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          content: Text("Canción agregada a favoritos"),
        ));
    }
  }

  void FavoriteWarningDialog(BuildContext context, songData) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Eliminar de favoritos?"),
              content: const Text(
                  "La canción será eliminada de tus favoritos. ¿Quieres continuar?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancelar")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<FavoritesProvider>().deleteSong(songData);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                          content: Text("Canción eliminada de favoritos."),
                        ));
                    },
                    child: const Text("Eliminar")),
              ],
            ));
  }

  Text SongDetailSubtitleText({required String texto, required double size}) {
    return Text(
      texto,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: size,
      ),
    );
  }

  Text SongDetailText(String textitself, double size) {
    return Text(
      textitself,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: size),
    );
  }

  IconButton openInAppButton(
      {required String url,
      required String tooltiptext,
      required Icon iconlogo}) {
    return IconButton(
      onPressed: () {
        _openLink(url);
      },
      icon: iconlogo,
      tooltip: tooltiptext,
    );
  }

  Future<void> _openLink(String url) async {
    Uri uri = Uri.parse(url);
    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri);
    // } else {
    //   print('Could not launch $uri');
    // }
    if (!await launchUrl(uri)) throw 'Timeout';
  }
}
