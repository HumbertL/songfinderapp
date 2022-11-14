import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

part 'record_audio_event.dart';
part 'record_audio_state.dart';

class RecordAudioBloc extends Bloc<RecordAudioEvent, RecordAudioState> {
  Record record = Record();

  RecordAudioBloc() : super(RecordAudioInitial()) {
    on<SongRecordEvent>(_recordingshit);
  }

  FutureOr<void> _recordingshit(SongRecordEvent event, emit) async {
    //_checkForSong(event.response);
    /*dynamic afuckisong = await _checkForSong(event.response);
    if (afuckisong == null) {
      print("Nothing happened");
      emit(RecordAudioErrorState(errorMsg: "Fucked up baby"));
    } else {
      print("Song found");
      emit(Recordedsomething(ResponseBody: afuckisong));
    }*/

    File song = File(event.response);
    String ActualSong = _makeItAFile(song);
    dynamic response = await _POSTSong(ActualSong);
    dynamic Songitself = response["result"];
    if (response["status"] == "success" && response["result"] != null) {
      print(Songitself);
      emit(Recordedsomething(ResponseBody: Songitself));
    } else {
      emit(RecordAudioErrorState(errorMsg: "No se encontro ninguna cancion!"));
    }
  }

  String _makeItAFile(File file) {
    Uint8List fileBytes = file.readAsBytesSync();
    String base64String = base64Encode(fileBytes);
    return base64String;
  }

  Future<dynamic> _POSTSong(String file) async {
    var url = Uri.parse('https://api.audd.io/');
    var response = await post(url, body: {
      'api_token': 'aa7007bc784bad05208b069888f0e9d3',
      'return': 'apple_music,spotify,deezer',
      'audio': file,
      'method': 'recognize',
    });
    if (response.statusCode == 200) {
      //print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      throw Exception('No json :(');
    }
  }

  Future<void> _checkForSong(String filepath) async {
    File song = File(filepath);
    String ActualSong = _makeItAFile(song);
    dynamic response = await _POSTSong(ActualSong);
    dynamic Songitself = response["result"];
    print(Songitself);
  }
}
