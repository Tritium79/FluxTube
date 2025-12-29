import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxtube/application/application.dart';
import 'package:fluxtube/core/enums.dart';
import 'package:fluxtube/domain/search/models/newpipe/newpipe_search_resp.dart';
import 'package:fluxtube/domain/subscribes/models/subscribe.dart';
import 'package:fluxtube/domain/watch/models/basic_info.dart';
import 'package:fluxtube/generated/l10n.dart';
import 'package:fluxtube/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

import 'home_video_info_card_widget.dart';

class NewPipeSearchResultSection extends StatelessWidget {
  NewPipeSearchResultSection({
    super.key,
    required this.locals,
    required this.state,
    required this.searchQuery,
  });

  final S locals;
  final SearchState state;
  final String searchQuery;

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !(state.fetchMoreNewPipeSearchResultStatus == ApiStatus.loading) &&
          !state.isMoreNewPipeFetchCompleted) {
        BlocProvider.of<SearchBloc>(context).add(SearchEvent.getMoreSearchResult(
          query: searchQuery,
          filter: "all",
          nextPage: state.newPipeSearchResult?.nextPage,
          serviceType: YouTubeServices.newpipe.name,
        ));
      }
    });

    return BlocBuilder<SubscribeBloc, SubscribeState>(
      buildWhen: (previous, current) =>
          previous.subscribedChannels != current.subscribedChannels,
      builder: (context, subscribeState) {
        final items = state.newPipeSearchResult?.items ?? [];
        return ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (index < items.length) {
              final result = items[index];

              if (result.type == "CHANNEL") {
                final channelId = result.channelId ?? result.url?.split("/").last ?? '';
                final isSubscribed = subscribeState.subscribedChannels
                    .where((channel) => channel.id == channelId)
                    .isNotEmpty;
                return ChannelWidget(
                  channelName: result.name,
                  isVerified: result.isVerified,
                  subscriberCount: result.subscriberCount,
                  thumbnail: result.thumbnailUrl,
                  isSubscribed: isSubscribed,
                  channelId: channelId,
                  locals: locals,
                );
              } else if (result.type == "PLAYLIST") {
                final playlistId = result.url?.split('=').last ?? '';
                return PlaylistWidget(
                  playlistId: playlistId,
                  title: result.name,
                  thumbnail: result.thumbnailUrl,
                  videoCount: result.streamCount,
                  uploaderName: result.uploaderName,
                  uploaderAvatar: result.uploaderAvatarUrl,
                  onTap: () {
                    context.goNamed('playlist', pathParameters: {
                      'playlistId': playlistId,
                    });
                  },
                );
              } else if (result.type == "STREAM") {
                final videoId = result.videoId ?? '';
                final channelId = result.uploaderUrl?.split("/").last ?? '';
                final isSubscribed = subscribeState.subscribedChannels
                    .where((channel) => channel.id == channelId)
                    .isNotEmpty;
                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<WatchBloc>(context).add(
                      WatchEvent.setSelectedVideoBasicDetails(
                        details: VideoBasicInfo(
                          id: videoId,
                          title: result.name,
                          thumbnailUrl: result.thumbnailUrl,
                          channelName: result.uploaderName,
                          channelThumbnailUrl: result.uploaderAvatarUrl,
                          channelId: channelId,
                          uploaderVerified: result.uploaderVerified,
                        ),
                      ),
                    );
                    context.goNamed('watch', pathParameters: {
                      'videoId': videoId,
                      'channelId': channelId,
                    });
                  },
                  child: NewPipeSearchVideoInfoCardWidget(
                    channelId: channelId,
                    cardInfo: result,
                    isSubscribed: isSubscribed,
                    onSubscribeTap: () {
                      if (isSubscribed) {
                        BlocProvider.of<SubscribeBloc>(context)
                            .add(SubscribeEvent.deleteSubscribeInfo(id: channelId));
                      } else {
                        BlocProvider.of<SubscribeBloc>(context).add(
                          SubscribeEvent.addSubscribe(
                            channelInfo: Subscribe(
                              id: channelId,
                              channelName: result.uploaderName ?? locals.noUploaderName,
                              isVerified: result.uploaderVerified ?? false,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              } else {
                return const SizedBox();
              }
            } else {
              if (state.isMoreNewPipeFetchCompleted) {
                return const SizedBox();
              } else {
                return cIndicator(context);
              }
            }
          },
          itemCount: items.length + 1,
        );
      },
    );
  }
}
