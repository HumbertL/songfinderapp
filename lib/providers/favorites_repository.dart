import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/Song.dart';

class FavoritesRepository {
  Future<bool> searchFavoriteSong(Song _song) async {
    String songtitle = _song.songtitle;
    var state = false;
    // traernos el document con el id de mi usuario
    var queryUser = await FirebaseFirestore.instance
        .collection("user")
        .doc("${FirebaseAuth.instance.currentUser!.uid}");
    // sacar data del documento
    var docsRef = await queryUser.get();
    var listIds = docsRef.data()?["Favorites"];
    var allsongs =
        await FirebaseFirestore.instance.collection("favorites").get();
    var songfound = allsongs.docs.where((doc) =>
        listIds.contains(doc.id) && doc.data()["songtitle"] == _song.songtitle);
    if (songfound != null) {
      state = true;
    }
    return state;
  }

  bool searchSongInDB(Song song) {
    bool doesItExist = false;
    var songitself = FirebaseFirestore.instance
        .collection("favorites")
        .where("songtitle", isEqualTo: song.songtitle)
        .get();

    return doesItExist;
  }
}
