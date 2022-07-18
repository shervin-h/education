import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({required this.url, required this.title, Key? key})
      : super(key: key);

  final String url;
  final String title;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  String _currentTime = '0.0';
  String _endTime = '0.0';
  bool _isVisible = true;

  Future<void> _landscapeModeOnly() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _enableDefaultRotation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _landscapeModeOnly();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      widget.url,
    );

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(() {
      _updatePlayingTimeText();
    });
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    _enableDefaultRotation();

    super.dispose();
  }

  @override
  void deactivate() {
    _enableDefaultRotation();
    super.deactivate();
  }

  void _updatePlayingTimeText() {
    if (_controller.value.isPlaying) {
      setState(() {
        _currentTime =
            '${_controller.value.position.inMinutes}:${_controller.value.position.inSeconds.remainder(60)}';
      });
      _endTime =
          '${_controller.value.duration.inMinutes}:${_controller.value.duration.inSeconds.remainder(60)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double mediaControllerHeight = screenHeight * 0.2;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: screenHeight,
            // Use a FutureBuilder to display a loading spinner while waiting for the
            // VideoPlayerController to finish initializing.
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(_controller),
                  );
                  // return VideoPlayer(_controller);
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return Center(
                    child: CupertinoActivityIndicator(
                      color: Theme.of(context).primaryColor,
                      radius: mediaControllerHeight * 0.2,
                    ),
                  );
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSwitcher(
              child: (_isVisible)
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        vertical: mediaControllerHeight * 0.05,
                        horizontal: mediaControllerHeight * 0.1,
                      ),
                      height: mediaControllerHeight,
                      width: double.infinity,
                      // alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                onPressed: () {
                                  _controller.seekTo(
                                    Duration(
                                        seconds: _controller
                                                .value.position.inSeconds -
                                            10),
                                  );
                                },
                                icon: Icon(
                                  CupertinoIcons.backward_fill,
                                  size: mediaControllerHeight * 0.3,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                onPressed: () {
                                  // Wrap the play or pause in a call to `setState`. This ensures the
                                  // correct icon is shown.
                                  setState(
                                    () {
                                      // If the video is playing, pause it.
                                      if (_controller.value.isPlaying) {
                                        _controller.pause();
                                      } else {
                                        // If the video is paused, play it.
                                        _controller.play();
                                      }
                                    },
                                  );
                                },
                                // Display the correct icon depending on the state of the player.
                                icon: Icon(
                                  _controller.value.isPlaying
                                      ? CupertinoIcons.pause_fill
                                      : CupertinoIcons.play_fill,
                                  size: mediaControllerHeight * 0.3,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                onPressed: () {
                                  _controller.seekTo(
                                    Duration(
                                        seconds: _controller
                                                .value.position.inSeconds +
                                            10),
                                  );
                                },
                                icon: Icon(
                                  CupertinoIcons.forward_fill,
                                  size: mediaControllerHeight * 0.3,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                _currentTime,
                                style: Theme.of(context).textTheme.bodyText1!
                                    .copyWith(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                colors: VideoProgressColors(
                                    backgroundColor: Colors.grey.shade500,
                                    bufferedColor: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.5),
                                    playedColor:
                                        Theme.of(context).primaryColor),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                _endTime,
                                style: Theme.of(context).textTheme.bodyText1!
                                    .copyWith(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
              duration: const Duration(milliseconds: 500),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              child: (_isVisible)
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        vertical: mediaControllerHeight * 0.05,
                        horizontal: mediaControllerHeight * 0.1,
                      ),
                      height: mediaControllerHeight,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.headline6!
                                .copyWith(color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          IconButton(
                            icon: const Icon(
                              CupertinoIcons.right_chevron,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    )
                  : null,
              duration: const Duration(milliseconds: 500),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isVisible = !_isVisible;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: mediaControllerHeight * 0.05,
                  horizontal: mediaControllerHeight * 0.1,
                ),
                height: screenHeight * 0.6,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: screenHeight * 0.3,
              width: screenHeight * 0.3,
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AnimatedSwitcher(
                      child: (_isVisible)
                          ? IconButton(
                              alignment: Alignment.center,
                              onPressed: () {
                                setState(
                                  () {
                                    // If the video is playing, pause it.
                                    if (_controller.value.isPlaying) {
                                      _controller.pause();
                                    } else {
                                      // If the video is paused, play it.
                                      _controller.play();
                                    }
                                  },
                                );
                              },
                              iconSize: screenHeight * 0.2,
                              icon: (_controller.value.isPlaying)
                                  ? const CustomizedIconWidget(iconData: CupertinoIcons.pause)
                                  : const CustomizedIconWidget(iconData: CupertinoIcons.play),
                            )
                          : null,
                      duration: const Duration(milliseconds: 500),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomizedIconWidget extends StatelessWidget {
  const CustomizedIconWidget({
    required this.iconData,
    Key? key
  }) : super(key: key);

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8)
        ]
      ),
      child: Icon(iconData),
    );
  }
}


/*
IconButton(
                              onPressed: () {
                                setState(
                                  () {
                                    // If the video is playing, pause it.
                                    if (_controller.value.isPlaying) {
                                      _controller.pause();
                                    } else {
                                      // If the video is paused, play it.
                                      _controller.play();
                                    }
                                  },
                                );
                              },
                              icon: (_controller.value.isPlaying)
                                  ? Icon(
                                      CupertinoIcons.pause,
                                      size: screenHeight * 0.2,
                                    )
                                  : Icon(
                                      CupertinoIcons.play,
                                      size: screenHeight * 0.2,
                                    ),
                            )
 */
