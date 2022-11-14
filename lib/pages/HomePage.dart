import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:songfinderapp/FavoriteSongs.dart';
import 'package:songfinderapp/bloc/record_audio_bloc.dart';
import 'package:songfinderapp/pages/FoundSong.dart';
import 'package:songfinderapp/pages/Login/LoginPage.dart';
import 'package:songfinderapp/pages/Song.dart';
import 'package:songfinderapp/pages/usersongs/bloc/user_songs_provider_bloc.dart';

import '../auth/bloc/auth_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _animateit = false;
  Record record = Record();
  String recordmsg = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 46, 42, 42),
      appBar: AppBar(
          /*backgroundColor: Colors.black,
        foregroundColor: Colors.black,*/
          ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Text(
          recordmsg,
          style: TextStyle(color: Colors.white),
        ),
        BlocConsumer<RecordAudioBloc, RecordAudioState>(
            builder: ((context, state) {
          if (state is RecordAudioInitial) {
            MakeMusic();
          }
          return MakeMusic();
        }), listener: ((context, state) {
          if (state is RecordAudioErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("${state.errorMsg}")));
          }
          if (state is Recordedsomething) {
            print(state.ResponseBody.toString());
            Song song = Song.fromJson(state.ResponseBody);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FoundSong(SongData: song),
            ));
          }
        })),
        //MakeMusic(),
        IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FavoriteSongs(),
              ));
              BlocProvider.of<UserSongsProviderBloc>(context)
                  .add(getAllsongs());
            },
            icon: Icon(
              Icons.favorite,
              color: Colors.white,
            )),
        SignInButtonBuilder(
          text: 'Log out',
          fontSize: 20,
          highlightColor: Colors.redAccent[400]!,
          textColor: Colors.black,
          icon: Icons.login_sharp,
          iconColor: Colors.black,
          onPressed: () {
            BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
          },
          backgroundColor: Colors.white,
        )
      ]),
    );
  }

  AvatarGlow MakeMusic() {
    return AvatarGlow(
      glowColor: Color.fromARGB(255, 244, 54, 76),
      endRadius: 200.0,
      animate: _animateit,
      duration: Duration(milliseconds: 2000),
      repeat: true,
      showTwoGlows: true,
      repeatPauseDuration: Duration(milliseconds: 100),
      child: Material(
        // Replace this child with your own
        elevation: 8.0,
        shape: CircleBorder(),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () {
              _animateit = !_animateit;
              recordmsg = "Escuchando...";
              recordingSong();
              setState(() {});
              Timer(Duration(seconds: 4), () async {
                _animateit = !_animateit;
                recordmsg = "";

                setState(() {});
              });
            },
            icon: Icon(
              Icons.music_note_outlined,
              color: _animateit == true ? Colors.red : Colors.black,
            ),
            iconSize: 100,
          ),
          radius: 100.0,
        ),
      ),
    );
  }

  Future<void> recordingSong() async {
    Directory? appDocDir = await getExternalStorageDirectory();
    String? appPath = appDocDir?.path;
    if (await record.hasPermission()) {
      // Start recording
      await record.start(
        path: '$appPath/newTrack.m4a',
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
        samplingRate: 44100, // by default
      );
    }

// Get the state of the recorder
    bool isRecording = await record.isRecording();
    if (isRecording) {
      Timer(
        Duration(seconds: 6),
        () async {
          String? songPath = await record.stop();
          BlocProvider.of<RecordAudioBloc>(context)
              .add(SongRecordEvent(response: songPath!));
        },
      );
    }
  }
}
