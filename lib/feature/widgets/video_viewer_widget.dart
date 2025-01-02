// ignore_for_file: unused_field

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';
import 'package:video_url_validator/video_url_validator.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoViewerWidget extends StatelessWidget {
  final String videoUrl;
  VideoViewerWidget({super.key, required this.videoUrl});

  final validator = VideoURLValidator();

  static open(BuildContext context, String videoUrl) async {
    await Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => VideoViewerWidget(
          videoUrl: videoUrl,
        ),
      ),
    )
        .then((value) async {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF031024),
      body: SafeArea(
        child: validator.validateYouTubeVideoURL(url: videoUrl)
            ? YoutubeViewerWidget(
                videoUrl: videoUrl,
              )
            : ExternalVideoViewerWidget(
                videoUrl: videoUrl,
              ),
      ),
    );
  }
}

class YoutubeViewerWidget extends BaseStatefulWidget {
  final String videoUrl;

  const YoutubeViewerWidget({super.key, required this.videoUrl});

  @override
  BaseState<YoutubeViewerWidget> baseCreateState() =>
      _YoutubeViewerWidgetState();
}

class _YoutubeViewerWidgetState extends BaseState<YoutubeViewerWidget> {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    )..addListener(listener);

    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      actionsPadding: const EdgeInsets.only(left: 16.0),
      bottomActions: [
        CurrentPosition(),
        const SizedBox(width: 10.0),
        ProgressBar(isExpanded: true),
        const SizedBox(width: 10.0),
        RemainingDuration(),
        FullScreenButton(),
      ],
    );
  }

  void listener() {
    if (mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  // ignore: unused_element
  Future<void> _openVideoInExternal() async {
    try {
      if (await canLaunchUrlString(widget.videoUrl)) {
        await launchUrlString(widget.videoUrl,
            mode: LaunchMode.externalApplication);
      } else {
        showFeedbackMessage(translate(LocalizationKeys.unableToOpenLink)!);
      }
    } catch (e) {
      showFeedbackMessage(translate(LocalizationKeys.unableToOpenLink)!);
    }
  }
}

class ExternalVideoViewerWidget extends BaseStatefulWidget {
  final String videoUrl;

  const ExternalVideoViewerWidget({super.key, required this.videoUrl});

  @override
  BaseState<ExternalVideoViewerWidget> baseCreateState() =>
      _ExternalVideoViewerWidgetState();
}

class _ExternalVideoViewerWidgetState
    extends BaseState<ExternalVideoViewerWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      autoInitialize: true,
      showControls: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.white),
              SizedBox(height: 10.h),
              Text(errorMessage, style: const TextStyle(color: Colors.white)),
              AppTextButton(
                onPressed: _openVideoInExternal,
                child: Text(
                  "${translate(LocalizationKeys.clickToOpenVideoInExternalBrowser)}\n${widget.videoUrl}",
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }

  Future<void> _openVideoInExternal() async {
    try {
      if (await canLaunchUrlString(widget.videoUrl)) {
        await launchUrlString(widget.videoUrl,
            mode: LaunchMode.externalApplication);
      } else {
        showFeedbackMessage(translate(LocalizationKeys.unableToOpenLink)!);
      }
    } catch (e) {
      showFeedbackMessage(translate(LocalizationKeys.unableToOpenLink)!);
    }
  }
}
