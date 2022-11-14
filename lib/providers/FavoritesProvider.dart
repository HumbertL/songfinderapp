import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:songfinderapp/pages/Song.dart';

class FavoritesProvider with ChangeNotifier {
  Future<void> searchSong(Song songobject) async {
    var songexists = await FirebaseFirestore.instance
        .collection("favorites")
        .where("songtitle", isEqualTo: songobject.songtitle)
        .get();
    if (songexists.size > 0) {
      print("Cancion encontrada");
      print(songexists.docs.first.id);
    } else
      print("No encontrada");
  }

  Future<dynamic> searchForSong(Song songobject) async {
    var songexists = await FirebaseFirestore.instance
        .collection("favorites")
        .where("songtitle", isEqualTo: songobject.songtitle)
        .get();
    if (songexists.size > 0) {
      return songexists.docs.first.id;
    } else
      return null;
  }

  void addNewSong(Song SongObject) async {
    dynamic songfound = await searchForSong(SongObject);
    bool isafavorite = await isAlreadyInFavorites(SongObject);
    if (isafavorite) {
      print("Already there");
    } else if (songfound != null) {
      print("cancion ya esta en la base de datos pero no en favoritos");
      _updateUserSongWithSong(SongObject);
    } else {
      print("cancion no esta en la base de datos");
      saveSong(SongObject);
    }
  }

  Future<void> deleteSong(Song songobject) async {
    var songexists = await FirebaseFirestore.instance
        .collection("favorites")
        .where("songtitle", isEqualTo: songobject.songtitle)
        .get();
    String songId = songexists.docs.first.id;
    //traer el user
    var queryUser = await FirebaseFirestore.instance
        .collection('songfinderusers')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    var docsRef = await queryUser.get();
    List<dynamic> listIds = docsRef.data()?["Favorites"];
    listIds.removeWhere((item) => item == songId);
    //agregar el nuevo id a la lista
    await queryUser.update({"Favorites": listIds});
    print("fucking añadido");
  }

  Future<bool> saveSong(Song songobject) async {
    CollectionReference favoritesongs =
        FirebaseFirestore.instance.collection("favorites");
    try {
      var songRef = await favoritesongs.add({
        'album': songobject.album,
        "songLink": songobject.songLink,
        "songtitle": songobject.songtitle,
        "spotifyimageurl": songobject.spotifyImageUrl,
        "Applesonglink": songobject.AppleSongLink,
        "artist": songobject.artist,
        "releaseDate": songobject.releaseDate,
        "spotifySonglink": songobject.spotifySongLink
      });
      print("Great success");
      return await _updateUserSongs(songRef.id);

      //subir that shit
    } catch (e) {
      return false;
      print("Oh hell na spunchbob");
    }
  }

  Future<void> isInfavorites(Song songobject) async {
    var songexists = await FirebaseFirestore.instance
        .collection("favorites")
        .where("songtitle", isEqualTo: songobject.songtitle)
        .get();
    String songId = songexists.docs.first.id;
    print(songId);
    //traer el user
    var queryUser = await FirebaseFirestore.instance
        .collection('songfinderusers')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    var docsRef = await queryUser.get();
    List<dynamic> listIds = docsRef.data()?["Favorites"];
    List<String> userfavorites = listIds.cast<String>();
    print(userfavorites.toString());
    print(userfavorites.contains(songId));
  }

  Future<bool> isAlreadyInFavorites(Song songobject) async {
    try {
      var songexists = await FirebaseFirestore.instance
          .collection("favorites")
          .where("songtitle", isEqualTo: songobject.songtitle)
          .get();
      if (songexists == null) {
        return false;
      }
      dynamic songId = songexists.docs.first.id;
      //traer el user
      var queryUser = await FirebaseFirestore.instance
          .collection('songfinderusers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      var docsRef = await queryUser.get();
      List<dynamic> listIds = docsRef.data()?["Favorites"];
      List<String> userfavorites = listIds.cast<String>();

      return userfavorites.contains(songId as String);
    } catch (e) {
      return false;
    }
  }

  Future<void> _updateUserSongWithSong(Song songobject) async {
    try {
      //traer la cancion
      var songexists = await FirebaseFirestore.instance
          .collection("favorites")
          .where("songtitle", isEqualTo: songobject.songtitle)
          .get();
      String songId = songexists.docs.first.id;
      //traer el user
      var queryUser = await FirebaseFirestore.instance
          .collection('songfinderusers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      var docsRef = await queryUser.get();
      List<dynamic> listIds = docsRef.data()?["Favorites"];
      listIds.add(songId);
      //agregar el nuevo id a la lista
      await queryUser.update({"Favorites": listIds});
      print("fucking añadido");
    } catch (e) {}
  }

  Future<bool> _updateUserSongs(String FavoriteSongId) async {
    try {
      //traer el user
      var queryUser = await FirebaseFirestore.instance
          .collection('songfinderusers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      var docsRef = await queryUser.get();
      List<dynamic> listIds = docsRef.data()?["Favorites"];
      listIds.add(FavoriteSongId);
      //agregar el nuevo id a la lista
      await queryUser.update({"Favorites": listIds});
      return true;
    } catch (e) {
      return false;
    }
  }

  bool searchFavorite(Song songobject) {
    return true;
  }
}
