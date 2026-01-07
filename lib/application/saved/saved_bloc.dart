import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxtube/application/settings/settings_bloc.dart';
import 'package:fluxtube/core/enums.dart';
import 'package:fluxtube/domain/core/failure/main_failure.dart';
import 'package:fluxtube/domain/saved/saved_services.dart';
import 'package:fluxtube/domain/user_preferences/models/user_preferences.dart';
import 'package:fluxtube/domain/user_preferences/user_preferences_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/saved/models/local_store.dart';

part 'saved_event.dart';
part 'saved_state.dart';
part 'saved_bloc.freezed.dart';

@injectable
class SavedBloc extends Bloc<SavedEvent, SavedState> {
  final SavedServices _savedServices;
  final UserPreferencesService _userPreferencesService;
  final SettingsBloc _settingsBloc;

  SavedBloc(
    this._savedServices,
    this._userPreferencesService,
    this._settingsBloc,
  ) : super(SavedState.initialize()) {
    // get all videos from local storage
    on<GetAllVideoInfoList>((event, emit) async {
      //initial loading go ui
      emit(state.copyWith(savedVideosFetchStatus: ApiStatus.loading));

      //get video list
      final _result =
          await _savedServices.getVideoInfoList(profileName: event.profileName);
      final _state = _result.fold(
          (MainFailure f) =>
              state.copyWith(savedVideosFetchStatus: ApiStatus.error),
          (List<LocalStoreVideoInfo> resp) {
        final List<LocalStoreVideoInfo> historyVideos =
            resp.where((e) => e.isHistory ?? false).toList();
        final List<LocalStoreVideoInfo> savedVideos =
            resp.where((e) => e.isSaved ?? false).toList();

        return state.copyWith(
            savedVideosFetchStatus: ApiStatus.loaded,
            localSavedVideos: savedVideos,
            localSavedHistoryVideos: historyVideos);
      });

      // update to ui
      emit(_state);
    });

    // add video data to local storage
    on<AddVideoInfo>((event, emit) async {
      // Don't emit loading state here - it causes the saved screen to flicker
      // The add operation is quick and doesn't need a loading indicator

      //add video info
      final _result = await _savedServices.addVideoInfo(
          videoInfo: event.videoInfo, profileName: event.profileName);
      final _state = _result.fold(
          (MainFailure f) =>
              state.copyWith(savedVideosFetchStatus: ApiStatus.error),
          (List<LocalStoreVideoInfo> resp) {
        final List<LocalStoreVideoInfo> historyVideos =
            resp.where((e) => e.isHistory ?? false).toList();
        final List<LocalStoreVideoInfo> savedVideos =
            resp.where((e) => e.isSaved ?? false).toList();

        return state.copyWith(
            savedVideosFetchStatus: ApiStatus.loaded,
            localSavedVideos: savedVideos,
            localSavedHistoryVideos: historyVideos);
      });

      // update to ui
      emit(_state);
      // Add CheckVideoInfo event to verify and update the state
      add(CheckVideoInfo(
          id: event.videoInfo.id, profileName: event.profileName));
    });

    // delete video data from local storage
    on<DeleteVideoInfo>((event, emit) async {
      // Don't emit loading state here - it causes the saved screen to flicker
      // The delete operation is quick and doesn't need a loading indicator

      //delete video info
      final _result = await _savedServices.deleteVideoInfo(
          id: event.id, profileName: event.profileName);
      final _state = _result.fold(
          (MainFailure f) =>
              state.copyWith(savedVideosFetchStatus: ApiStatus.error),
          (List<LocalStoreVideoInfo> resp) {
        final List<LocalStoreVideoInfo> historyVideos =
            resp.where((e) => e.isHistory ?? false).toList();
        final List<LocalStoreVideoInfo> savedVideos =
            resp.where((e) => e.isSaved ?? false).toList();

        return state.copyWith(
            savedVideosFetchStatus: ApiStatus.loaded,
            localSavedVideos: savedVideos,
            localSavedHistoryVideos: historyVideos);
      });

      // update to ui
      emit(_state);
      add(CheckVideoInfo(id: event.id, profileName: event.profileName));
    });

    // check the playing video present in the saved video
    on<CheckVideoInfo>((event, emit) async {
      // Don't clear videoInfo before the async call - this causes the UI to flicker
      // and show as unsaved briefly before the actual state is retrieved
      final _result = await _savedServices.checkVideoInfo(
          id: event.id, profileName: event.profileName);
      final _state = _result.fold(
          (MainFailure f) => state.copyWith(videoInfo: null),
          (LocalStoreVideoInfo resp) => state.copyWith(videoInfo: resp));

      // update to ui
      emit(_state);
    });

    // Track video watch for recommendations
    on<TrackVideoWatch>((event, emit) async {
      await _userPreferencesService.trackInteraction(
        entityId: event.videoId,
        type: InteractionType.videoWatch,
        weight: 1,
        profileName: _settingsBloc.state.currentProfile,
      );
    });

    // Track search for recommendations
    on<TrackSearch>((event, emit) async {
      await _userPreferencesService.trackInteraction(
        entityId: event.query,
        type: InteractionType.search,
        weight: 1,
        profileName: _settingsBloc.state.currentProfile,
      );
    });

    // Update playback position without affecting isSaved state
    // This prevents race condition where history updates overwrite manual save
    on<UpdatePlaybackPosition>((event, emit) async {
      // First, check if the video already exists in the database
      final existingResult = await _savedServices.checkVideoInfo(
          id: event.videoInfo.id, profileName: event.profileName);

      // Preserve the existing isSaved state if the video exists
      final videoInfoToSave = existingResult.fold(
        // Video doesn't exist, use the provided info
        (_) => event.videoInfo,
        // Video exists, preserve its isSaved state
        (existingVideo) {
          // Create new video info with preserved isSaved state
          return LocalStoreVideoInfo(
            id: event.videoInfo.id,
            title: event.videoInfo.title,
            views: event.videoInfo.views,
            thumbnail: event.videoInfo.thumbnail,
            uploadedDate: event.videoInfo.uploadedDate,
            uploaderName: event.videoInfo.uploaderName,
            uploaderId: event.videoInfo.uploaderId,
            uploaderAvatar: event.videoInfo.uploaderAvatar,
            uploaderSubscriberCount: event.videoInfo.uploaderSubscriberCount,
            duration: event.videoInfo.duration,
            uploaderVerified: event.videoInfo.uploaderVerified,
            // Preserve existing isSaved state - this is the key fix!
            isSaved: existingVideo.isSaved,
            isHistory: event.videoInfo.isHistory,
            isLive: event.videoInfo.isLive,
            playbackPosition: event.videoInfo.playbackPosition,
            profileName: event.profileName,
          );
        },
      );

      // Save the video info
      final result = await _savedServices.addVideoInfo(
          videoInfo: videoInfoToSave, profileName: event.profileName);

      final newState = result.fold(
          (MainFailure f) =>
              state.copyWith(savedVideosFetchStatus: ApiStatus.error),
          (List<LocalStoreVideoInfo> resp) {
        final List<LocalStoreVideoInfo> historyVideos =
            resp.where((e) => e.isHistory ?? false).toList();
        final List<LocalStoreVideoInfo> savedVideos =
            resp.where((e) => e.isSaved ?? false).toList();

        // Update videoInfo directly here to avoid extra CheckVideoInfo call
        // which causes UI flickering
        return state.copyWith(
            savedVideosFetchStatus: ApiStatus.loaded,
            localSavedVideos: savedVideos,
            localSavedHistoryVideos: historyVideos,
            videoInfo: videoInfoToSave);
      });

      emit(newState);
      // Don't dispatch CheckVideoInfo here - we already have the correct videoInfo
      // from the save operation. Dispatching it causes unnecessary state updates
      // and UI flickering.
    });
  }
}
