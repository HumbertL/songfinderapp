import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'user_songs_provider_event.dart';
part 'user_songs_provider_state.dart';

class UserSongsProviderBloc
    extends Bloc<UserSongsProviderEvent, UserSongsProviderState> {
  UserSongsProviderBloc() : super(UserSongsProviderInitial()) {
    on<getAllsongs>(_songsfromDatabase);
  }
  FutureOr<void> _songsfromDatabase(event, emit) async {
    emit(SongsLoading());
    try {
      // traernos el document con el id de mi usuario
      var queryUser = await FirebaseFirestore.instance
          .collection("songfinderusers")
          .doc("${FirebaseAuth.instance.currentUser!.uid}");
      // sacar data del documento
      var docsRef = await queryUser.get();
      var listIds = docsRef.data()?["Favorites"];

      // query para sacar docs de fshare
      var queryFotos =
          await FirebaseFirestore.instance.collection("favorites").get();

      // filtrar con Dart la info necesaria usando con referencia la lista de isd del user actual
      var myDisabledContentList = queryFotos.docs
          .where((doc) => listIds.contains(doc.id))
          .map((doc) => doc.data().cast<String, dynamic>())
          .toList();

      // lista de documentos filtrados del usuario con datos en espera
      emit(UserSongsSuccess(myDisabledContentList));
    } catch (e) {
      emit(NoSongsAvailable());
    }
  }
}
