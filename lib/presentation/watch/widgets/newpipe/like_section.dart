import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxtube/application/application.dart';
import 'package:fluxtube/core/strings.dart';
import 'package:fluxtube/domain/saved/models/local_store.dart';
import 'package:fluxtube/domain/watch/models/newpipe/newpipe_watch_resp.dart';
import 'package:fluxtube/generated/l10n.dart';
import 'package:fluxtube/presentation/settings/utils/launch_url.dart';
import 'package:fluxtube/presentation/watch/widgets/like_widgets.dart';
import 'package:share_plus/share_plus.dart';

class NewPipeLikeSection extends StatelessWidget {
  NewPipeLikeSection({
    super.key,
    required this.id,
    required this.watchInfo,
    required this.state,
    required this.pipClicked,
  });

  final String id;
  final NewPipeWatchResp watchInfo;
  final WatchState state;
  final VoidCallback pipClicked;

  final ValueNotifier<bool> _checkedBoxNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final S locals = S.of(context);
    return BlocBuilder<SavedBloc, SavedState>(
      builder: (context, savedState) {
        bool isSaved = (savedState.videoInfo?.id == id &&
                savedState.videoInfo?.isSaved == true)
            ? true
            : false;
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            return LikeRowWidget(
                like: watchInfo.likeCount ?? 0,
                dislikes: watchInfo.dislikeCount ?? 0,
                isDislikeVisible: settingsState.isDislikeVisible,
                isCommentTapped: state.isTapComments,
                isPipDesabled: settingsState.isPipDisabled,
                onTapComment: () {
                  if (state.isDescriptionTapped) {
                    BlocProvider.of<WatchBloc>(context)
                        .add(WatchEvent.tapDescription());
                  }
                  log(state.isTapComments.toString());
                  BlocProvider.of<WatchBloc>(context)
                      .add(WatchEvent.getNewPipeComments(id: id));
                },
                onTapShare: () {
                  alertboxMethod(context, locals);
                },
                isSaveTapped: isSaved,
                onTapSave: () {
                  BlocProvider.of<SavedBloc>(context).add(
                    SavedEvent.addVideoInfo(
                      videoInfo: LocalStoreVideoInfo(
                          id: id,
                          title: watchInfo.title,
                          views: watchInfo.viewCount,
                          thumbnail: watchInfo.thumbnailUrl,
                          uploadedDate: watchInfo.textualUploadDate ?? '',
                          uploaderAvatar: watchInfo.uploaderAvatarUrl,
                          uploaderName: watchInfo.uploaderName,
                          uploaderId: _extractChannelId(watchInfo.uploaderUrl),
                          uploaderSubscriberCount: watchInfo.uploaderSubscriberCount?.toString(),
                          duration: watchInfo.duration,
                          playbackPosition:
                              savedState.videoInfo?.playbackPosition,
                          uploaderVerified: watchInfo.uploaderVerified,
                          isSaved: !isSaved,
                          isLive: watchInfo.isLive,
                          isHistory: savedState.videoInfo?.isHistory),
                    ),
                  );
                },
                onTapYoutube: () async => await urlLaunchWithSettings(context, '$kYTBaseUrl$id'),
                pipClicked: pipClicked);
          },
        );
      },
    );
  }

  String? _extractChannelId(String? uploaderUrl) {
    if (uploaderUrl == null) return null;
    // Extract channel ID from URL like "https://www.youtube.com/channel/UCxxx"
    final uri = Uri.tryParse(uploaderUrl);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      final channelIndex = uri.pathSegments.indexOf('channel');
      if (channelIndex != -1 && channelIndex + 1 < uri.pathSegments.length) {
        return uri.pathSegments[channelIndex + 1];
      }
    }
    return null;
  }

  Future<dynamic> alertboxMethod(BuildContext context, S locals) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return ValueListenableBuilder(
          valueListenable: _checkedBoxNotifier,
          builder: (context, value, _) {
            return AlertDialog(
              title: Text(locals.share),
              content: Row(
                children: [
                  Checkbox(
                      value: _checkedBoxNotifier.value,
                      onChanged: (value) =>
                          _checkedBoxNotifier.value = value ?? false),
                  Text(locals.includeTitle),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(locals.share),
                  onPressed: () async {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                    if (_checkedBoxNotifier.value) {
                      await Share.share("${watchInfo.title}\n\n$kYTBaseUrl$id");
                    } else {
                      await Share.share('$kYTBaseUrl$id');
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
