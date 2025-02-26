import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';

class VideoScreen extends BaseStatefulScreenWidget {
  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _VideoScreen();
  }
}

class _VideoScreen extends BaseScreenState<VideoScreen> {
  final VideoPlayerController _controller = VideoPlayerController.networkUrl(
    Uri.parse('http://api.studiflats.com/clubvideo.mp4'),
  );
  ChewieController? _chewieController;

  @override
  void initState() {
    init();
    _controller.addListener(() {
      if (_controller.value.hasError) {
      } else if (_controller.value.isInitialized) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _controller,
            aspectRatio: 16 / 9,
            autoPlay: true,
            looping: true,
            showControls: true,
            allowFullScreen: true,
          );
        });
      }
    });

    super.initState();
  }

  Future init() async {
    Future.wait([
      _controller.initialize(),
    ]);
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "About Community Club",
        withBackButton: true,
        multiLan: false,
        onBack: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
                child: _controller.value.isInitialized
                    ? Chewie(
                        controller: _chewieController ??
                            ChewieController(
                                videoPlayerController: _controller!),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      )
                // _chewieController != null
                //     ? Chewie(
                //         controller: _chewieController ??
                //             ChewieController(videoPlayerController: _controller!),
                //       )
                //     : const Center(
                //         child: CircularProgressIndicator(),
                //       ),
                ),
          ),
        ],
      ),
    );
  }
}
