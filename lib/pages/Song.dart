import 'dart:convert';

class Song {
  final String artist;
  final String album;
  final String songtitle;
  final String spotifyImageUrl;
  final String releaseDate;
  final String spotifySongLink;
  final String AppleSongLink;
  final String songLink;

  Song(
      this.artist,
      this.songtitle,
      this.album,
      this.releaseDate,
      this.spotifyImageUrl,
      this.spotifySongLink,
      this.AppleSongLink,
      this.songLink);

  Song.fromDocument(Map<String, dynamic> document)
      : artist = document['artist']! as String,
        spotifyImageUrl = document['spotifyimageurl']! as String,
        songtitle = document['songtitle']! as String,
        album = document['album']! as String,
        spotifySongLink = document['spotifySonglink'] != null
            ? document['spotifySonglink'] as String
            : "null",
        AppleSongLink = document['Applesonglink']! as String,
        releaseDate = document['releaseDate'] != null
            ? document['releaseDate'] as String
            : "",
        songLink = document['songLink']! as String;

  Song.fromJson(Map<String, dynamic> json)
      : artist = json['artist'],
        songtitle = json['title'],
        spotifyImageUrl = json["spotify"] != null
            ? json["spotify"]["album"]["images"][0]["url"] as String
            : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUrgu4a7W_OM8LmAuN7Prk8dzWXm7PVB_FmA&usqp=CAU",
        album = json["album"],
        releaseDate = json["release_date"] != null ? json["release_date"] : "",
        spotifySongLink = json['spotify'] != null ? json['spotify']['uri'] : "",
        AppleSongLink =
            json['apple_music'] != null ? json['apple_music']['url'] : "",
        songLink = json['song_link'];
}
