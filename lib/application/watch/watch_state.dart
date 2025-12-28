part of 'watch_bloc.dart';

@freezed
class WatchState with _$WatchState {
  const factory WatchState({
    //
    String? oldId,
    required bool isTapComments,
    required bool isDescriptionTapped,
    required bool isPipEnabled,
    required String title,
    required int playBack,
    VideoBasicInfo? selectedVideoBasicDetails,

    // PIPED
    required WatchResp watchResp,
    required CommentsResp comments,
    required CommentsResp commentReplies,
    required ApiStatus fetchWatchInfoStatus,
    required ApiStatus fetchCommentsStatus,
    required ApiStatus fetchCommentRepliesStatus,
    required ApiStatus fetchMoreCommentsStatus,
    required bool isMoreCommentsFetchCompleted,
    required ApiStatus fetchMoreCommentRepliesStatus,
    required bool isMoreReplyCommentsFetchCompleted,

    //EXPLODE
    
    required ExplodeWatchResp explodeWatchResp,
    required ApiStatus fetchExplodeWatchInfoStatus,
    required ApiStatus fetchSubtitlesStatus,
    required List<Map<String, String>> subtitles,
    String? liveStreamUrl,
    required ApiStatus fetchExplodeLiveStreamStatus,
    List<MyRelatedVideo>? relatedVideos,
    required ApiStatus fetchExplodedRelatedVideosStatus,
    List<MyMuxedStreamInfo>? muxedStreams,
    required ApiStatus fetchExplodeMuxedStreamsStatus,

    // INVIDIOUS

    required InvidiousWatchResp invidiousWatchResp,
    required ApiStatus fetchInvidiousWatchInfoStatus,
    required InvidiousCommentsResp invidiousComments,
    required ApiStatus fetchInvidiousCommentsStatus,
    required InvidiousCommentsResp invidiousCommentReplies,
    required ApiStatus fetchInvidiousCommentRepliesStatus,
    required ApiStatus fetchMoreInvidiousCommentsStatus,
    required bool isMoreInvidiousCommentsFetchCompleted,
    required ApiStatus fetchMoreInvidiousCommentRepliesStatus,
    required bool isMoreInvidiousReplyCommentsFetchCompleted,

  }) = _Initial;

  factory WatchState.initialize() => WatchState(
        //
        oldId: null,
        isTapComments: false,
        isDescriptionTapped: false,
        isPipEnabled: false,
        title: '',
        liveStreamUrl: null,
        selectedVideoBasicDetails: null,
        playBack: 0,

    // PIPED

        watchResp: WatchResp(),
        comments: CommentsResp(),
        commentReplies: CommentsResp(),
        fetchWatchInfoStatus: ApiStatus.initial,
        fetchCommentsStatus: ApiStatus.initial,
        fetchCommentRepliesStatus: ApiStatus.initial,
        isMoreCommentsFetchCompleted: false,
        fetchMoreCommentsStatus: ApiStatus.initial,
        fetchMoreCommentRepliesStatus: ApiStatus.initial,
        isMoreReplyCommentsFetchCompleted: false,
        
        // EXPLODE
        
        explodeWatchResp: ExplodeWatchResp.initial(),
        fetchExplodeWatchInfoStatus: ApiStatus.initial,
        fetchSubtitlesStatus: ApiStatus.initial,
        subtitles: [],
        fetchExplodeLiveStreamStatus: ApiStatus.initial,
        relatedVideos: null,
        fetchExplodedRelatedVideosStatus: ApiStatus.initial,
        muxedStreams: null,
        fetchExplodeMuxedStreamsStatus: ApiStatus.initial,

        // INVIDIOUS
        invidiousWatchResp: InvidiousWatchResp(),
        fetchInvidiousWatchInfoStatus: ApiStatus.initial,
        invidiousComments: InvidiousCommentsResp(),
        fetchInvidiousCommentsStatus: ApiStatus.initial,
        invidiousCommentReplies: InvidiousCommentsResp(),
        fetchInvidiousCommentRepliesStatus: ApiStatus.initial,
        fetchMoreInvidiousCommentsStatus: ApiStatus.initial,
        isMoreInvidiousCommentsFetchCompleted: false,
        fetchMoreInvidiousCommentRepliesStatus: ApiStatus.initial,
        isMoreInvidiousReplyCommentsFetchCompleted: false,

      );
}
