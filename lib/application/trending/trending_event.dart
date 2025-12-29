part of 'trending_bloc.dart';

@freezed
class TrendingEvent with _$TrendingEvent {
  const factory TrendingEvent.getTrendingData(
      {required String serviceType, required String region}) = GetTrendingData;
  const factory TrendingEvent.getForcedTrendingData(
      {required String serviceType,
      required String region}) = GetForcedTrendingData;
  const factory TrendingEvent.getHomeFeedData(
      {required List<Subscribe> channels}) = GetHomeFeedData;
  const factory TrendingEvent.getForcedHomeFeedData(
      {required List<Subscribe> channels}) = GetForcedHomeFeedData;
  // NewPipe feed
  const factory TrendingEvent.getNewPipeHomeFeedData(
      {required List<Subscribe> channels}) = GetNewPipeHomeFeedData;
  const factory TrendingEvent.getForcedNewPipeHomeFeedData(
      {required List<Subscribe> channels}) = GetForcedNewPipeHomeFeedData;
}
