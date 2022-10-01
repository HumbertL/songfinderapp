part of 'record_audio_bloc.dart';

@immutable
abstract class RecordAudioEvent extends Equatable {
  const RecordAudioEvent();

  @override
  List<Object> get props => [];
}

class SongRecordEvent extends RecordAudioEvent {
  final String response;

  SongRecordEvent({required this.response});
  @override
  List<Object> get props => [response];
}
