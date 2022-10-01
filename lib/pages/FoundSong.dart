import 'package:flutter/material.dart';
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
      body: ListView(
        children: [
          ListTile(
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
                icon: Icon(Icons.arrow_back)),
            trailing: IconButton(
                tooltip: "Agregar a favoritos",
                onPressed: () {
                  if (context
                      .read<FavoritesProvider>()
                      .searchFavorite(widget.SongData)) {
                    showDialog(
                        context: context,
                        builder: ((context) => EliminarAlert(context)));
                  } else {
                    context
                        .read<FavoritesProvider>()
                        .addNewSong(widget.SongData);
                    setState(() {});
                  }
                },
                icon: context
                        .read<FavoritesProvider>()
                        .searchFavorite(widget.SongData)
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border)),
            title: Text("Here you go"),
          ),
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

  AlertDialog EliminarAlert(BuildContext context) {
    return AlertDialog(
      title: const Text("Eliminar favorito"),
      content: const Text("La cancion sera removida de tus favoritos"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancelar');
            },
            child: const Text("Cancelar")),
        TextButton(
            onPressed: () {
              context.read<FavoritesProvider>().deleteSong(widget.SongData);
              setState(() {});
              Navigator.pop(context, 'Eliminar');
            },
            child: const Text('Eliminar'))
      ],
    );
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
