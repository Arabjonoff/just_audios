import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audios/control.dart';
import 'package:rxdart/rxdart.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  late AudioPlayer _audioPlayer;

  final _playList = ConcatenatingAudioSource(children: [
    AudioSource.uri(Uri.parse( "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),),
    AudioSource.uri(Uri.parse( "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",),),
  ]);

  Stream<PositionDate> get _positionDateStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionDate>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferPosition, duration) => PositionDate(
          position: position,
          bufferPosition: bufferPosition,
          duration: duration ??Duration.zero,
        ),
      );

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: StreamBuilder(
                stream: _positionDateStream,
                  builder: (context,snapshot){
                  final positionDate = snapshot.data;
                  return ProgressBar(
                    barHeight: 8,
                    progress: positionDate?.position??Duration.zero,
                    buffered: positionDate?.bufferPosition??Duration.zero,
                    total: positionDate?.duration??Duration.zero,
                    onSeek: _audioPlayer.seek
                  );
              }),
            ),
            Control(audioPlayer: _audioPlayer)
          ],
        ),
      ),
    );
  }

  Future<void> _init()async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(_playList);
  }
}

class PositionDate {
  final Duration position;
  final Duration bufferPosition;
  final Duration duration;

  PositionDate({
    required this.position,
    required this.bufferPosition,
    required this.duration,
  });
}
