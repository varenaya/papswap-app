// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final file;

  final link;

  const VideoWidget({Key? key, this.file, this.link}) : super(key: key);

  @override
  VideoWidgetState createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;
  bool _muted = false;

  late Widget videoStatusAnimation;

  @override
  void initState() {
    super.initState();

    videoStatusAnimation = const SizedBox();

    _controller = widget.link == null
        ? VideoPlayerController.file(widget.file)
        : VideoPlayerController.network(widget.link)
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        Timer(const Duration(milliseconds: 0), () {
          if (!mounted) return;

          setState(() {});
          _controller.pause();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _controller.value.isInitialized
      ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio, child: videoPlayer())
      : Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey.shade200,
          ),
        );

  Widget videoPlayer() => Stack(
        children: <Widget>[
          video(),
          Align(
            alignment: Alignment.bottomCenter,
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              padding: const EdgeInsets.all(16.0),
            ),
          ),
          Center(child: videoStatusAnimation),
          Positioned(
              bottom: 27,
              left: 15,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black54,
                ),
                child: Text(
                  (_controller.value.duration).toString().substring(2, 7),
                  style: const TextStyle(color: Colors.white),
                ),
              )),
          Positioned(
            right: 15,
            bottom: 27,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _muted = !_muted;
                });
                _muted
                    ? _controller.setVolume(0.0)
                    : _controller.setVolume(1.0);
              },
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.black54,
                child: _muted
                    ? const Icon(
                        Icons.volume_off,
                        size: 20,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.volume_up,
                        size: 20,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
        ],
      );

  Widget video() => GestureDetector(
        child: VideoPlayer(_controller),
        onTap: () {
          if (!_controller.value.isInitialized) {
            return;
          }
          if (_controller.value.isPlaying) {
            videoStatusAnimation =
                const FadeAnimation(child: Icon(Icons.pause, size: 50.0));
            _controller.pause();
          } else {
            videoStatusAnimation =
                const FadeAnimation(child: Icon(Icons.play_arrow, size: 50.0));
            _controller.play();
          }
        },
      );
}

class FadeAnimation extends StatefulWidget {
  const FadeAnimation(
      {Key? key,
      required this.child,
      this.duration = const Duration(milliseconds: 1000)})
      : super(key: key);

  final Widget child;
  final Duration duration;

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => animationController.isAnimating
      ? Opacity(
          opacity: 1.0 - animationController.value,
          child: widget.child,
        )
      : Container();
}
