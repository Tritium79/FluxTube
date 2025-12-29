import 'package:flutter/material.dart';
import 'package:omni_video_player/omni_video_player.dart';

/// A reusable Omni video player widget that plays videos
/// Supports both YouTube videos (by ID) and direct network URLs
class OmniVideoPlayerWidget extends StatelessWidget {
  const OmniVideoPlayerWidget.youtube({
    super.key,
    required String videoId,
    required this.onControllerCreated,
    this.startPosition = 0,
    this.isLive = false,
  })  : _videoId = videoId,
        _networkUrl = null;

  const OmniVideoPlayerWidget.network({
    super.key,
    required String url,
    required this.onControllerCreated,
    this.startPosition = 0,
    this.isLive = false,
    bool isHls = false, // kept for API compatibility, player auto-detects
  })  : _networkUrl = url,
        _videoId = null;

  final String? _videoId;
  final String? _networkUrl;
  final void Function(OmniPlaybackController controller) onControllerCreated;
  final int startPosition;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final VideoSourceConfiguration sourceConfig;

    if (_videoId != null) {
      // YouTube mode
      sourceConfig = VideoSourceConfiguration.youtube(
        videoUrl: Uri.parse('https://www.youtube.com/watch?v=$_videoId'),
      ).copyWith(
        autoPlay: true,
        initialPosition: isLive ? Duration.zero : Duration(seconds: startPosition),
        allowSeeking: !isLive,
      );
    } else {
      // Network URL mode (for Piped/Invidious/Explode streams)
      sourceConfig = VideoSourceConfiguration.network(
        videoUrl: Uri.parse(_networkUrl!),
      ).copyWith(
        autoPlay: true,
        initialPosition: isLive ? Duration.zero : Duration(seconds: startPosition),
        allowSeeking: !isLive,
      );
    }

    // Configure UI visibility for live streams
    final uiOptions = isLive
        ? const PlayerUIVisibilityOptions(
            showSeekBar: false,
            showCurrentTime: false,
            showDurationTime: false,
            showRemainingTime: false,
            showLiveIndicator: true,
            showReplayButton: false,
            showPlaybackSpeedButton: false,
            showScrubbingThumbnailPreview: false,
            enableForwardGesture: false,
            enableBackwardGesture: false,
          )
        : const PlayerUIVisibilityOptions();

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: OmniVideoPlayer(
        configuration: VideoPlayerConfiguration(
          videoSourceConfiguration: sourceConfig,
          playerUIVisibilityOptions: uiOptions,
          liveLabel: 'LIVE',
        ),
        callbacks: VideoPlayerCallbacks(
          onControllerCreated: onControllerCreated,
        ),
      ),
    );
  }
}
