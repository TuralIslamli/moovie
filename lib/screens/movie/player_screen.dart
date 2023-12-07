import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final String? title;
  final YoutubePlayerController? controller;
  final String? backdropPath;
  const PlayerScreen(
      {required this.backdropPath,
      required this.title,
      required this.controller,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    widget.controller!.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.controller!.pause();
  }

  @override
  void dispose() {
    widget.controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
        // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        //     overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
      },
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
      },
      player: YoutubePlayer(
        thumbnail: CachedNetworkImage(imageUrl: widget.backdropPath!),
        showVideoProgressIndicator: true,
        progressColors: ProgressBarColors(
            bufferedColor: Colors.grey.shade700,
            handleColor: Colors.red,
            playedColor: Colors.red),
        controller: widget.controller!,
        topActions: [
          IconButton(
            onPressed: () {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown
              ]);
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
              widget.controller!.pause();
              Navigator.pop(context);
            },
            iconSize: 30.r,
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          5.horizontalSpace,
          Expanded(
            child: Text(
              widget.title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
          )
        ],
        onEnded: (metaData) {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
          Navigator.of(context).pop();
        },
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
              child: SizedBox(
                  width: double.infinity, height: 0.9.sh, child: player)),
        );
      },
    );
  }
}
