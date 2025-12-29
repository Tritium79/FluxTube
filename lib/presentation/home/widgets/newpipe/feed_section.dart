import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxtube/application/application.dart';
import 'package:fluxtube/core/constants.dart';
import 'package:fluxtube/domain/subscribes/models/subscribe.dart';
import 'package:fluxtube/domain/watch/models/basic_info.dart';
import 'package:fluxtube/generated/l10n.dart';
import 'package:fluxtube/presentation/trending/widgets/newpipe/home_video_info_card_widget.dart';
import 'package:go_router/go_router.dart';

class NewPipeFeedVideoSection extends StatelessWidget {
  const NewPipeFeedVideoSection({
    super.key,
    required this.locals,
    required this.trendingState,
    required this.subscribeState,
  });

  final S locals;
  final TrendingState trendingState;
  final SubscribeState subscribeState;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => kHeightBox10,
      itemBuilder: (context, index) {
        final feed = trendingState.newPipeFeedResult[index];
        final String? videoId = feed.videoId;

        if (videoId == null) {
          return const SizedBox.shrink();
        }

        final String channelId = feed.uploaderUrl?.split("/").last ?? '';
        final bool isSubscribed = subscribeState.subscribedChannels
            .where((channel) => channel.id == channelId)
            .isNotEmpty;
        return GestureDetector(
          onTap: () {
            BlocProvider.of<WatchBloc>(context).add(
                WatchEvent.setSelectedVideoBasicDetails(
                    details: VideoBasicInfo(
                        id: videoId,
                        title: feed.name,
                        thumbnailUrl: feed.thumbnailUrl,
                        channelName: feed.uploaderName,
                        channelThumbnailUrl: feed.uploaderAvatarUrl,
                        channelId: channelId,
                        uploaderVerified: feed.uploaderVerified)));
            context.goNamed('watch', pathParameters: {
              'videoId': videoId,
              'channelId': channelId,
            });
          },
          child: NewPipeTrendingVideoInfoCardWidget(
            channelId: channelId,
            cardInfo: feed,
            isSubscribed: isSubscribed,
            onSubscribeTap: () => _onSubscribeTapped(
                context, isSubscribed, channelId, feed, locals),
          ),
        );
      },
      itemCount: trendingState.newPipeFeedResult.length,
    );
  }
}

_onSubscribeTapped(context, isSubscribed, channelId, channelDetails, locals) {
  if (isSubscribed) {
    BlocProvider.of<SubscribeBloc>(context)
        .add(SubscribeEvent.deleteSubscribeInfo(id: channelId));
  } else {
    BlocProvider.of<SubscribeBloc>(context).add(SubscribeEvent.addSubscribe(
        channelInfo: Subscribe(
            id: channelId,
            channelName: channelDetails.uploaderName ?? locals.noUploaderName,
            isVerified: channelDetails.uploaderVerified ?? false)));
  }
}
