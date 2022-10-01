import 'package:flutter/material.dart';
import 'package:songfinderapp/pages/FoundSong.dart';
import 'package:songfinderapp/pages/Song.dart';

class SongWidget extends StatelessWidget {
  final Song songObject;

  const SongWidget({super.key, required this.songObject});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FoundSong(SongData: songObject)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 340,
          margin: EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8)),
            child: Stack(
              children: [
                Positioned.fill(
                    child: Image.network(
                  "${songObject.spotifyImageUrl}",
                  fit: BoxFit.fill,
                )),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8))),
                    child: Column(
                      children: [
                        Text("${songObject.songtitle}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text("${songObject.artist}",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
