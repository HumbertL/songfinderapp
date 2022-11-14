part of 'user_songs_provider_bloc.dart';

abstract class UserSongsProviderState extends Equatable {
  const UserSongsProviderState();

  @override
  List<Object> get props => [];
}

class UserSongsProviderInitial extends UserSongsProviderState {}

class UserSongsSuccess extends UserSongsProviderState {
  final List<Map<String, dynamic>> mySongs;

  UserSongsSuccess(this.mySongs);
  @override
  List<Object> get props => [mySongs];
}

class NoSongsAvailable extends UserSongsProviderState {}

class SongError extends UserSongsProviderState {}

class SongsLoading extends UserSongsProviderState {}
