part of 'trending_bloc.dart';

@freezed
class TrendingState with _$TrendingState {
  const factory TrendingState({
    required String lastUsedRegion,

    // PIPED
    required List<TrendingResp> trendingResult,
    required List<TrendingResp> feedResult,
    required ApiStatus fetchTrendingStatus,
    required ApiStatus fetchFeedStatus,

    // INVIDIOUS

    required ApiStatus fetchInvidiousTrendingStatus,
    required List<InvidiousTrendingResp> invidiousTrendingResult,

    // NEWPIPE

    required ApiStatus fetchNewPipeTrendingStatus,
    required List<NewPipeTrendingResp> newPipeTrendingResult,
  }) = _Initial;

  factory TrendingState.initialize() => const TrendingState(
        lastUsedRegion: 'IN',

        // PIPED

        trendingResult: [],
        feedResult: [],
        fetchTrendingStatus: ApiStatus.initial,
        fetchFeedStatus: ApiStatus.initial,

        // INVIDIOUS

        fetchInvidiousTrendingStatus: ApiStatus.initial,
        invidiousTrendingResult: [],

        // NEWPIPE

        fetchNewPipeTrendingStatus: ApiStatus.initial,
        newPipeTrendingResult: [],
      );
}
