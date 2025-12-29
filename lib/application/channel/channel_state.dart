part of 'channel_bloc.dart';

@freezed
class ChannelState with _$ChannelState {
  factory ChannelState({
    //
    required bool isMoreFetchCompleted,

    // PIPED

    required ApiStatus channelDetailsFetchStatus,
    required ChannelResp? pipedChannelResp,
    required ApiStatus moreChannelDetailsFetchStatus,

    // PIPED TABS
    required int selectedTabIndex,
    required ApiStatus tabContentFetchStatus,
    required TabContent? selectedTabContent,

    // INVIDIOUS

    required InvidiousChannelResp? invidiousChannelResp,
    required int invidiousPage,
  }) = _ChannelState;

  factory ChannelState.initialize() => ChannelState(
        //
        isMoreFetchCompleted: false,

        // PIPED

        pipedChannelResp: null,
        channelDetailsFetchStatus: ApiStatus.initial,

        // PIPED TABS
        selectedTabIndex: 0,
        tabContentFetchStatus: ApiStatus.initial,
        selectedTabContent: null,

        // INVIDIOUS

        invidiousChannelResp: null,
        moreChannelDetailsFetchStatus: ApiStatus.initial,
        invidiousPage: 1,
      );
}
