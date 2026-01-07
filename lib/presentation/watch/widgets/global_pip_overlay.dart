import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxtube/application/application.dart';
import 'package:fluxtube/core/player/global_player_controller.dart';
import 'package:fluxtube/presentation/watch/widgets/pip_video_widget.dart';

/// Global key for the PiP widget to maintain its state across route changes
final GlobalKey<State<PipVideoWidget>> _pipWidgetKey = GlobalKey<State<PipVideoWidget>>();

/// Global PiP overlay that shows the PiP player above all routes
/// This ensures PiP works regardless of which screen the user navigates to
class GlobalPipOverlay extends StatefulWidget {
  final Widget child;

  const GlobalPipOverlay({
    super.key,
    required this.child,
  });

  @override
  State<GlobalPipOverlay> createState() => _GlobalPipOverlayState();
}

class _GlobalPipOverlayState extends State<GlobalPipOverlay> {
  final GlobalPlayerController _globalPlayer = GlobalPlayerController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          previous.isPipDisabled != current.isPipDisabled,
      builder: (context, settingsState) {
        return BlocBuilder<WatchBloc, WatchState>(
          buildWhen: (previous, current) =>
              previous.isPipEnabled != current.isPipEnabled ||
              previous.selectedVideoBasicDetails != current.selectedVideoBasicDetails,
          builder: (context, watchState) {
            // Listen to global player controller for state changes
            return ListenableBuilder(
              listenable: _globalPlayer,
              builder: (context, _) {
                final shouldShowPip = watchState.isPipEnabled &&
                    !settingsState.isPipDisabled &&
                    watchState.selectedVideoBasicDetails != null &&
                    _globalPlayer.hasActivePlayer;

                // Keep PiP widget in tree when we have video data to maintain state
                // This prevents widget recreation during navigation which would lose
                // position state and potentially cause visual glitches
                final hasPipData = watchState.selectedVideoBasicDetails != null &&
                    _globalPlayer.hasActivePlayer;

                return Stack(
                  children: [
                    // Main app content
                    widget.child,

                    // PiP overlay - always in tree when data is available
                    // Visibility is controlled by isVisible parameter to maintain state
                    if (hasPipData)
                      PipVideoWidget(
                        key: _pipWidgetKey,
                        videoId: watchState.selectedVideoBasicDetails!.id,
                        channelId: watchState.selectedVideoBasicDetails!.channelId ?? '',
                        title: watchState.selectedVideoBasicDetails!.title ?? '',
                        thumbnailUrl: watchState.selectedVideoBasicDetails!.thumbnailUrl,
                        isVisible: shouldShowPip,
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
