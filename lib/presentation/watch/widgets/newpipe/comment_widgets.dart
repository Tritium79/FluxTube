import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxtube/application/watch/watch_bloc.dart';
import 'package:fluxtube/core/colors.dart';
import 'package:fluxtube/core/constants.dart';
import 'package:fluxtube/core/enums.dart';
import 'package:fluxtube/core/operations/math_operations.dart';
import 'package:fluxtube/generated/l10n.dart';
import 'package:fluxtube/presentation/watch/widgets/shimmer_comment_widgets.dart';
import 'package:fluxtube/widgets/indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:rich_readmore/rich_readmore.dart';
import 'package:simple_html_css/simple_html_css.dart';

class NewPipeCommentSection extends StatelessWidget {
  NewPipeCommentSection({
    super.key,
    required this.state,
    required this.height,
    required this.locals,
    required this.videoId,
  });

  final WatchState state;
  final double height;
  final S locals;
  final String videoId;

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !(state.fetchMoreNewPipeCommentsStatus == ApiStatus.loading) &&
          !state.isMoreNewPipeCommentsFetchCompleted) {
        BlocProvider.of<WatchBloc>(context).add(
            WatchEvent.getMoreNewPipeComments(
                id: videoId, nextPage: state.newPipeComments.nextPage));
      }
    });

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: LimitedBox(
        maxHeight: height * 0.45,
        child: (state.fetchNewPipeCommentsStatus == ApiStatus.initial ||
                state.fetchNewPipeCommentsStatus == ApiStatus.loading)
            ? const ShimmerCommentWidget()
            : state.fetchNewPipeCommentsStatus == ApiStatus.error
                ? Center(
                    child: ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<WatchBloc>(context)
                              .add(WatchEvent.getNewPipeComments(id: videoId));
                        },
                        child: Text(locals.retry)),
                  )
                : state.newPipeComments.isDisabled == true
                    ? Center(child: Text(locals.commentsDisabled))
                    : state.newPipeComments.comments?.isEmpty == true
                        ? Center(child: Text(locals.noCommentsFound))
                        : ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              final comments = state.newPipeComments.comments ?? [];
                              if (index < comments.length) {
                                final comment = comments[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    NewPipeCommentWidget(
                                      author: comment.authorName ?? locals.commentAuthorNotFound,
                                      text: comment.text ?? '',
                                      likes: comment.likeCount ?? 0,
                                      authorImageUrl: comment.authorAvatarUrl ?? '',
                                      isPinned: comment.isPinned ?? false,
                                      isHearted: comment.isHearted ?? false,
                                      onProfileTap: () {
                                        final channelId = _extractChannelId(comment.authorUrl);
                                        if (channelId != null) {
                                          context.pushNamed('channel', pathParameters: {
                                            'channelId': channelId,
                                          }, queryParameters: {
                                            'avatarUrl': comment.authorAvatarUrl,
                                          });
                                        }
                                      },
                                    ),
                                    if (comment.replyCount != null && comment.replyCount! > 0)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 70, top: 4),
                                        child: TextButton(
                                          onPressed: () {
                                            // TODO: Implement replies when NewPipe supports it
                                            // For now show a message
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(locals.repliesNotSupported),
                                                duration: const Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "${formatCount(comment.replyCount.toString())} ${locals.repliesPlural(comment.replyCount ?? 0)}",
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              } else {
                                if (state.isMoreNewPipeCommentsFetchCompleted) {
                                  return const SizedBox();
                                } else {
                                  return cIndicator(context);
                                }
                              }
                            },
                            separatorBuilder: (context, index) => kHeightBox15,
                            itemCount: (state.newPipeComments.comments?.length ?? 0) + 1,
                          ),
      ),
    );
  }

  String? _extractChannelId(String? url) {
    if (url == null) return null;
    final uri = Uri.tryParse(url);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      final channelIndex = uri.pathSegments.indexOf('channel');
      if (channelIndex != -1 && channelIndex + 1 < uri.pathSegments.length) {
        return uri.pathSegments[channelIndex + 1];
      }
    }
    return null;
  }
}

class NewPipeCommentWidget extends StatelessWidget {
  const NewPipeCommentWidget({
    super.key,
    required this.author,
    required this.text,
    required this.likes,
    required this.authorImageUrl,
    this.isPinned = false,
    this.isHearted = false,
    this.onProfileTap,
  });

  final String authorImageUrl;
  final String author;
  final String text;
  final int likes;
  final bool isPinned;
  final bool isHearted;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    final S locals = S.of(context);
    var formattedLikes = formatCount(likes.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pinned indicator
        if (isPinned)
          Padding(
            padding: const EdgeInsets.only(left: 60, bottom: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.push_pin, size: 14, color: kGreyColor),
                const SizedBox(width: 4),
                Text(
                  locals.pinned,
                  style: TextStyle(color: kGreyColor, fontSize: 12),
                ),
              ],
            ),
          ),
        // Main comment row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            GestureDetector(
              onTap: onProfileTap,
              child: CircleAvatar(
                radius: 18,
                backgroundImage: authorImageUrl.isNotEmpty
                    ? NetworkImage(authorImageUrl)
                    : null,
                child: authorImageUrl.isEmpty
                    ? const Icon(Icons.person, size: 18)
                    : null,
              ),
            ),
            kWidthBox15,
            // Author name and comment text
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    author,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: kGreyColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichReadMoreText(
                    HTML.toTextSpan(
                      context,
                      text,
                      defaultTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    settings: LineModeSettings(
                      trimLines: 3,
                      trimCollapsedText: ' ${locals.readMoreText}',
                      trimExpandedText: ' ${locals.showLessText}',
                      moreStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      lessStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Likes and heart column
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isHearted)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 16,
                    ),
                  ),
                Icon(
                  CupertinoIcons.hand_thumbsup,
                  size: 16,
                  color: kGreyColor,
                ),
                const SizedBox(height: 2),
                Text(
                  formattedLikes,
                  style: TextStyle(
                    fontSize: 12,
                    color: kGreyColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
