import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Control extends StatelessWidget {
  final AudioPlayer audioPlayer;
  const Control({Key? key, required this.audioPlayer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(onPressed: (){
          audioPlayer.seekToPrevious();
        }, icon: Icon(Icons.skip_previous)),
        StreamBuilder(
          stream: audioPlayer.playerStateStream,
            builder: (context,snapshot){
            final playState = snapshot.data;
            final playing = playState?.playing;
            final progressState = playState?.processingState;
            if(!(playing??false)){
              return IconButton(onPressed: (){
                audioPlayer.play();
              }, icon: Icon(Icons.play_arrow_rounded));
            }
            else if(progressState != ProcessingState.completed){
              return IconButton(onPressed: (){
                audioPlayer.pause();
              }, icon: Icon(Icons.pause));
            }
            return IconButton(onPressed: (){
            }, icon: Icon(Icons.play_arrow_rounded));
        }),
        IconButton(onPressed: (){
          audioPlayer.seekToNext();
        }, icon: Icon(Icons.skip_next)),
      ],
    );
  }
}
