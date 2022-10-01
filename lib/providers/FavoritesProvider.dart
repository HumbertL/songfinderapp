import 'package:flutter/foundation.dart';
import 'package:songfinderapp/pages/Song.dart';

class FavoritesProvider with ChangeNotifier {
  List<Song> _songslist = [];

  List<Song> get getSongList => _songslist;

  void addNewSong(Song SongObject) {
    _songslist.add(SongObject);
    notifyListeners();
  }

  void deleteSong(Song songObj) {
    _songslist.remove(songObj);

    notifyListeners();
  }

  bool searchFavorite(Song sonobj) {
    var state = false;
    if (_songslist.contains(sonobj)) state = true;
    return state;
  }
}
