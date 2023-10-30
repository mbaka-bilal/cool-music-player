import 'package:cool_music_player/utils/constants.dart';
import 'package:cool_music_player/view/screens/onboarding/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    final audioSource = AudioSource.uri(
      Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/my-projects-ed284.appspot.com/o/titanium-170190.mp3?alt=media&token=5278e294-1b0d-4654-b330-0d6db2cd8e6c&_gl=1*rri1wq*_ga*MTc0NDQ5NDQuMTY5NjYzNjgyOA..*_ga_CW55HF8NVT*MTY5NzUxMjQxMi41LjEuMTY5NzUxMzE5MS40LjAuMA.."),
      tag: const MediaItem(
        id: '1',
        album: "Album name",
        title: "Song name",
        // artUri: Uri.parse('https://example.com/albumart.jpg'),
      ),
    );
    _loadAudio(audioSource);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              icon: const Icon(Icons.person_2_outlined))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Container(), _buildCard()],
      ),
    );
  }

  Card _buildCard() {
    return Card(
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                children: [
                  Text("Audio"),
                  SizedBox(
                    height: Constants.mediumSpacing,
                  ),
                  Text("0:00")
                ],
              ),
              const SizedBox(
                width: Constants.mediumSpacing,
              ),
              StreamBuilder(
                stream: player.playerStateStream,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return _buildActionsButton(playerState: snapshot.data);
                  } else if (snapshot.hasError) {
                    Fluttertoast.showToast(
                        msg: "Error occurred ${snapshot.error}");
                    return _buildActionsButton(hasError: true);
                  } else {
                    return _buildActionsButton();
                  }
                },
              ),
            ],
          ),
        ));
  }

  void _loadAudio(AudioSource source) async {
    final playlist = ConcatenatingAudioSource(children: [source]);
    try {
      await player.setAudioSource(playlist, preload: true);
    } on PlayerException catch (e) {
      debugPrint("player exception $e");
    } catch (e) {
      debugPrint("Could not start audio $e");
    }
  }

  void _audioActions({required PlayerState playerState}) {
    if (playerState.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  Widget _buildActionsButton(
      {PlayerState? playerState, bool hasError = false}) {
    return IconButton(onPressed: () {
      if (playerState != null) {
        _audioActions(playerState: playerState);
      }
    }, icon: Builder(builder: (context) {
      if (playerState == null || hasError) {
        return const Icon(
          Icons.play_arrow,
          size: 50,
        );
      }
      if (playerState.playing) {
        return const Icon(
          Icons.pause,
          size: 50,
        );
      } else {
        switch (playerState.processingState) {
          case (ProcessingState.loading || ProcessingState.buffering):
            return const CircularProgressIndicator();
          case (ProcessingState.idle || ProcessingState.completed):
            return const Icon(
              Icons.play_arrow,
              size: 50,
            );
          case ProcessingState.ready:
            return const Icon(
              Icons.pause,
              size: 50,
            );
        }
      }
    }));
  }
}
