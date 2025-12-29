import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluxtube/application/application.dart';
import 'package:fluxtube/domain/saved/models/local_store.dart';
import 'package:fluxtube/domain/watch/models/newpipe/newpipe_stream.dart';
import 'package:fluxtube/domain/watch/models/newpipe/newpipe_watch_resp.dart';
import 'package:fluxtube/generated/l10n.dart';

class NewPipeVideoPlayerWidget extends StatefulWidget {
  const NewPipeVideoPlayerWidget({
    super.key,
    required this.watchInfo,
    required this.videoId,
    required this.playbackPosition,
    this.defaultQuality = "720p",
    this.isSaved = false,
    this.isHlsPlayer = false,
    this.videoFitMode = "contain",
    this.skipInterval = 10,
    this.isAudioFocusEnabled = true,
  });

  final NewPipeWatchResp watchInfo;
  final String videoId;
  final String defaultQuality;
  final int playbackPosition;
  final bool isSaved;
  final bool isHlsPlayer;
  final String videoFitMode;
  final int skipInterval;
  final bool isAudioFocusEnabled;

  @override
  State<NewPipeVideoPlayerWidget> createState() =>
      _NewPipeVideoPlayerWidgetState();
}

class _NewPipeVideoPlayerWidgetState extends State<NewPipeVideoPlayerWidget> {
  BetterPlayerController? _betterPlayerController;
  NewPipeVideoStream? selectedVideoTrack;
  late final List<NewPipeVideoStream> availableVideoTracks;
  late final double aspectRatio;
  late final SavedBloc _savedBloc;
  late final WatchBloc _watchBloc;
  BetterPlayerDataSource? betterPlayerDataSource;

  @override
  void initState() {
    super.initState();

    _savedBloc = BlocProvider.of<SavedBloc>(context);
    _watchBloc = BlocProvider.of<WatchBloc>(context);
    // Combine video streams and video-only streams for selection
    availableVideoTracks = [
      ...(widget.watchInfo.videoStreams ?? []),
    ];
    aspectRatio = _selectAspectRatio();
    selectedVideoTrack = _selectVideoTrack();
    _setupPlayer(widget.playbackPosition);
  }

  @override
  void dispose() {
    _updateVideoHistory();
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: _betterPlayerController != null
          ? BetterPlayer(controller: _betterPlayerController!)
          : const Center(child: CircularProgressIndicator()),
    );
  }

  double _selectAspectRatio() {
    final firstStream = widget.watchInfo.videoStreams?.firstOrNull;
    if (firstStream != null && firstStream.width != null && firstStream.height != null) {
      return firstStream.width! / firstStream.height!;
    }
    return 16 / 9;
  }

  NewPipeVideoStream? _selectVideoTrack() {
    if (availableVideoTracks.isEmpty || widget.isHlsPlayer) {
      return null;
    }

    // Filter to get only muxed streams (non video-only)
    final muxedTracks = availableVideoTracks.where((v) => v.isVideoOnly != true).toList();
    if (muxedTracks.isEmpty) return null;

    NewPipeVideoStream? defaultTrack;
    for (var video in muxedTracks) {
      if (video.resolution == widget.defaultQuality) {
        defaultTrack = video;
        break;
      }
    }

    if (defaultTrack == null) {
      final defaultQualityValue =
          int.tryParse(widget.defaultQuality.replaceAll('p', '')) ?? 0;

      int smallestDifference = double.maxFinite.toInt();
      for (var track in muxedTracks) {
        int trackQualityValue =
            int.tryParse(track.resolution?.replaceAll('p', '') ?? '0') ?? 0;
        int difference = (trackQualityValue - defaultQualityValue).abs();

        if (difference < smallestDifference) {
          smallestDifference = difference;
          defaultTrack = track;
        }
      }
    }

    return defaultTrack ?? muxedTracks.firstOrNull;
  }

  void _setupPlayer(int startPosition) {
    String? videoUrl;
    BetterPlayerVideoFormat videoFormat = BetterPlayerVideoFormat.other;

    final bool isLive = widget.watchInfo.isLive == true;

    // For live streams, prefer HLS
    if (isLive && widget.watchInfo.hlsUrl != null) {
      videoUrl = widget.watchInfo.hlsUrl;
      videoFormat = BetterPlayerVideoFormat.hls;
    } else if (widget.isHlsPlayer && widget.watchInfo.dashMpdUrl != null) {
      videoUrl = widget.watchInfo.dashMpdUrl;
      videoFormat = BetterPlayerVideoFormat.dash;
    } else if (selectedVideoTrack?.url != null) {
      videoUrl = selectedVideoTrack!.url;
      videoFormat = BetterPlayerVideoFormat.other;
    } else if (widget.watchInfo.hlsUrl != null) {
      videoUrl = widget.watchInfo.hlsUrl;
      videoFormat = BetterPlayerVideoFormat.hls;
    } else if (widget.watchInfo.dashMpdUrl != null) {
      videoUrl = widget.watchInfo.dashMpdUrl;
      videoFormat = BetterPlayerVideoFormat.dash;
    }

    if (videoUrl == null) {
      _showNoVideoAvailableToast();
      return;
    }

    betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrl,
      subtitles: _createSubtitles(),
      liveStream: isLive,
      videoFormat: videoFormat,
    );

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        controlsConfiguration: BetterPlayerControlsConfiguration(
          controlBarColor: Colors.black26,
          iconsColor: Colors.white,
          playIcon: Icons.play_arrow_outlined,
          progressBarPlayedColor: Colors.indigo,
          progressBarHandleColor: Colors.indigo,
          controlBarHeight: 40,
          loadingColor: Colors.red,
          overflowModalColor: Colors.black54,
          overflowModalTextColor: Colors.white,
          overflowMenuIconsColor: Colors.white,
          skipForwardIcon: Icons.forward_10,
          skipBackIcon: Icons.replay_10,
          forwardSkipTimeInMilliseconds: widget.skipInterval * 1000,
          backwardSkipTimeInMilliseconds: widget.skipInterval * 1000,
        ),
        autoPlay: true,
        startAt: isLive ? Duration.zero : Duration(seconds: startPosition),
        aspectRatio: aspectRatio,
        allowedScreenSleep: false,
        expandToFill: false,
        autoDispose: true,
        fit: _getBoxFit(widget.videoFitMode),
        handleLifecycle: widget.isAudioFocusEnabled,
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );

    if (mounted) {
      setState(() {});
    }
  }

  void _showNoVideoAvailableToast() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Fluttertoast.showToast(
        msg: S.of(context).noVideoAvailableChangedToHls,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    });
  }

  List<BetterPlayerSubtitlesSource>? _createSubtitles() {
    final subtitles = widget.watchInfo.subtitles;
    if (subtitles == null || subtitles.isEmpty) return null;

    return subtitles.map((sub) {
      return BetterPlayerSubtitlesSource(
        type: BetterPlayerSubtitlesSourceType.network,
        name: sub.languageCode ?? 'Unknown',
        urls: [sub.url ?? ''],
      );
    }).toList();
  }

  BoxFit _getBoxFit(String fitMode) {
    switch (fitMode) {
      case 'cover':
        return BoxFit.cover;
      case 'fill':
        return BoxFit.fill;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'contain':
      default:
        return BoxFit.contain;
    }
  }

  void _updateVideoHistory() async {
    final currentPosition =
        _betterPlayerController?.videoPlayerController?.value.position;

    _watchBloc.add(WatchEvent.updatePlayBack(playBack: currentPosition?.inSeconds));

    if (currentPosition != null && widget.videoId.isNotEmpty) {
      final videoInfo = LocalStoreVideoInfo(
        id: widget.videoId,
        title: widget.watchInfo.title,
        views: widget.watchInfo.viewCount,
        thumbnail: widget.watchInfo.thumbnailUrl,
        uploadedDate: widget.watchInfo.textualUploadDate ?? '',
        uploaderAvatar: widget.watchInfo.uploaderAvatarUrl,
        uploaderName: widget.watchInfo.uploaderName,
        uploaderId: _extractChannelId(widget.watchInfo.uploaderUrl),
        uploaderSubscriberCount: widget.watchInfo.uploaderSubscriberCount?.toString() ?? '0',
        duration: widget.watchInfo.duration,
        uploaderVerified: widget.watchInfo.uploaderVerified,
        isHistory: true,
        isLive: widget.watchInfo.isLive,
        isSaved: widget.isSaved,
        playbackPosition: currentPosition.inSeconds,
      );

      _savedBloc.add(SavedEvent.addVideoInfo(videoInfo: videoInfo));
    }
  }

  String? _extractChannelId(String? uploaderUrl) {
    if (uploaderUrl == null) return null;
    final uri = Uri.tryParse(uploaderUrl);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      final channelIndex = uri.pathSegments.indexOf('channel');
      if (channelIndex != -1 && channelIndex + 1 < uri.pathSegments.length) {
        return uri.pathSegments[channelIndex + 1];
      }
    }
    return null;
  }
}
