part of 'download_bloc.dart';

@freezed
class DownloadState with _$DownloadState {
  const factory DownloadState({
    /// Status of fetching download options
    required ApiStatus fetchOptionsStatus,

    /// Status of fetching downloads list
    required ApiStatus fetchDownloadsStatus,

    /// Available download options for current video
    DownloadOptions? downloadOptions,

    /// All downloads
    required List<DownloadItem> allDownloads,

    /// Completed downloads
    required List<DownloadItem> completedDownloads,

    /// Active (currently downloading) downloads
    required List<DownloadItem> activeDownloads,

    /// Pending or paused downloads
    required List<DownloadItem> pendingDownloads,

    /// Error message if any
    String? errorMessage,

    /// Title of the failed download (for snackbar display)
    String? failedDownloadTitle,
  }) = _DownloadState;

  factory DownloadState.initial() => const DownloadState(
        fetchOptionsStatus: ApiStatus.initial,
        fetchDownloadsStatus: ApiStatus.initial,
        downloadOptions: null,
        allDownloads: [],
        completedDownloads: [],
        activeDownloads: [],
        pendingDownloads: [],
        errorMessage: null,
        failedDownloadTitle: null,
      );
}
