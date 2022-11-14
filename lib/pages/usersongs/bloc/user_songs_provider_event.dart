part of 'user_songs_provider_bloc.dart';

abstract class UserSongsProviderEvent extends Equatable {
  const UserSongsProviderEvent();

  @override
  List<Object> get props => [];
}

class getAllsongs extends UserSongsProviderEvent {}
