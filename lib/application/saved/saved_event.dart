part of 'saved_bloc.dart';

@freezed
class SavedEvent with _$SavedEvent {
  const factory SavedEvent.addVideoInfo({
    required LocalStoreVideoInfo videoInfo,
    @Default('default') String profileName,
  }) = AddVideoInfo;
  const factory SavedEvent.deleteVideoInfo({
    required String id,
    @Default('default') String profileName,
  }) = DeleteVideoInfo;
  const factory SavedEvent.getAllVideoInfoList({
    @Default('default') String profileName,
  }) = GetAllVideoInfoList;
  const factory SavedEvent.checkVideoInfo({
    required String id,
    @Default('default') String profileName,
  }) = CheckVideoInfo;
}
