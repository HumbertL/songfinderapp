part of 'record_audio_bloc.dart';

@immutable
abstract class RecordAudioState extends Equatable {
  const RecordAudioState();

  @override
  List<Object> get props => [];
}

class RecordAudioInitial extends RecordAudioState {}

class RecordAudioErrorState extends RecordAudioState {
  final String errorMsg;

  RecordAudioErrorState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

class Recordedsomething extends RecordAudioState {
  final Map<String, dynamic> ResponseBody;

  Recordedsomething({required this.ResponseBody});
  @override
  List<Object> get props => [ResponseBody];
}
