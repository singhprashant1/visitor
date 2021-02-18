import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerr extends StatefulWidget {
  @override
  _VideoPlayerrState createState() => _VideoPlayerrState();
}

class _VideoPlayerrState extends State<VideoPlayerr> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(
        "http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4");
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player"),
      ),
      body: Container(
          decoration: BoxDecoration(color: Colors.black),
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Chewie(controller: chewieController)),
    );
  }
}
