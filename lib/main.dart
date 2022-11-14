import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:songfinderapp/bloc/record_audio_bloc.dart';
import 'package:songfinderapp/pages/HomePage.dart';
import 'package:songfinderapp/pages/Login/LoginPage.dart';
import 'package:songfinderapp/pages/usersongs/bloc/user_songs_provider_bloc.dart';
import 'auth/bloc/auth_bloc.dart';
import 'providers/FavoritesProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    BlocProvider(
      create: (context) => AuthBloc()..add(VerifyAuthEvent()),
    ),
    BlocProvider(create: (context) => RecordAudioBloc()),
    BlocProvider(
      create: (context) => UserSongsProviderBloc(),
    ),
    ChangeNotifierProvider(create: (context) => FavoritesProvider())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData.dark(),
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Favor de autenticarse"),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthSuccessState) {
            return HomePage();
          } else if (state is UnAuthState ||
              state is AuthErrorState ||
              state is SignOutSuccessState) {
            return LoginPage();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
