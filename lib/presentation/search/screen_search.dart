import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxtube/application/application.dart';
import 'package:fluxtube/core/colors.dart';
import 'package:fluxtube/core/enums.dart';
import 'package:fluxtube/generated/l10n.dart';
import 'package:fluxtube/widgets/widgets.dart';

import 'widgets/widgets.dart';

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({super.key});

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  final TextEditingController _textEditingController = TextEditingController();
  String _selectedFilter = 'all';

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onFilterChanged(String filter, String serviceType) {
    setState(() {
      _selectedFilter = filter;
    });
    if (_textEditingController.text.isNotEmpty) {
      BlocProvider.of<SearchBloc>(context).add(SearchEvent.getSearchResult(
        query: _textEditingController.text,
        filter: filter,
        serviceType: serviceType,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locals = S.of(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: kBlackColor,
        title: SearchBarSection(
            textEditingController: _textEditingController,
            theme: theme,
            selectedFilter: _selectedFilter),
      ),
      body: SafeArea(child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) =>
            previous.ytService != current.ytService,
        builder: (context, settingsState) {
          return Column(
            children: [
              // Search Filters - different for Piped vs Invidious
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                  children: settingsState.ytService == YouTubeServices.invidious.name
                      ? [
                          // Invidious filters (uses 'type' parameter)
                          _buildFilterChip(locals.filterAll, 'all', settingsState.ytService),
                          const SizedBox(width: 8),
                          _buildFilterChip(locals.filterVideos, 'video', settingsState.ytService),
                          const SizedBox(width: 8),
                          _buildFilterChip(locals.filterChannels, 'channel', settingsState.ytService),
                          const SizedBox(width: 8),
                          _buildFilterChip(locals.filterPlaylists, 'playlist', settingsState.ytService),
                        ]
                      : [
                          // Piped filters (uses 'filter' parameter)
                          _buildFilterChip(locals.filterAll, 'all', settingsState.ytService),
                          const SizedBox(width: 8),
                          _buildFilterChip(locals.filterVideos, 'videos', settingsState.ytService),
                          const SizedBox(width: 8),
                          _buildFilterChip(locals.filterChannels, 'channels', settingsState.ytService),
                          const SizedBox(width: 8),
                          _buildFilterChip(locals.filterPlaylists, 'playlists', settingsState.ytService),
                          const SizedBox(width: 8),
                          _buildFilterChip(locals.filterMusic, 'music_songs', settingsState.ytService),
                        ],
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  buildWhen: (previous, current) =>
                      previous.isSuggestionDisplay != current.isSuggestionDisplay ||
                      previous.fetchSuggestionStatus != current.fetchSuggestionStatus ||
                      previous.fetchSearchResultStatus != current.fetchSearchResultStatus ||
                      previous.suggestions != current.suggestions ||
                      previous.result != current.result,
                  builder: (context, state) {
                    // INVIDIOUS
                    if (settingsState.ytService == YouTubeServices.invidious.name) {
                      if (state.isSuggestionDisplay == true &&
                          state.fetchSuggestionStatus == ApiStatus.loaded &&
                          (state.fetchSearchResultStatus == ApiStatus.loading ||
                              state.fetchSearchResultStatus == ApiStatus.loaded) &&
                          state.suggestions.isNotEmpty &&
                          _textEditingController.text.isNotEmpty) {
                        return SearchSuggestionSection(
                          textEditingController: _textEditingController,
                          state: state,
                        );
                      } else if (state.fetchSearchResultStatus == ApiStatus.loading ||
                          state.fetchSearchResultStatus == ApiStatus.initial) {
                        return cIndicator(context);
                      } else if (state.isSuggestionDisplay ||
                          _textEditingController.text.isEmpty) {
                        return Container();
                      } else if (state.fetchSearchResultStatus == ApiStatus.error ||
                          state.result == null ||
                          state.result!.items.isEmpty) {
                        return ErrorRetryWidget(
                          lottie: 'assets/cup.zip',
                          onTap: () => BlocProvider.of<SearchBloc>(context).add(
                              SearchEvent.getSearchResult(
                                  query: _textEditingController.text,
                                  filter: _selectedFilter,
                                  serviceType: settingsState.ytService)),
                        );
                      } else {
                        return SearcheResultSection(
                          locals: locals,
                          state: state,
                          searchQuery: _textEditingController.text,
                        );
                      }
                    } else {
                      // PIPED API
                      if (state.isSuggestionDisplay == true &&
                          state.fetchSuggestionStatus == ApiStatus.loaded &&
                          (state.fetchSearchResultStatus == ApiStatus.initial ||
                              state.fetchSearchResultStatus == ApiStatus.loading ||
                              state.fetchSearchResultStatus == ApiStatus.loaded) &&
                          state.suggestions.isNotEmpty &&
                          _textEditingController.text.isNotEmpty) {
                        return SearchSuggestionSection(
                          textEditingController: _textEditingController,
                          state: state,
                        );
                      } else if (state.fetchSearchResultStatus == ApiStatus.loading ||
                          (_textEditingController.text.trim().isNotEmpty &&
                              state.fetchSearchResultStatus == ApiStatus.initial)) {
                        return cIndicator(context);
                      } else if (_textEditingController.text.trim().isEmpty &&
                          state.fetchSearchResultStatus == ApiStatus.initial) {
                        return const SizedBox();
                      } else if (state.isSuggestionDisplay ||
                          _textEditingController.text.isEmpty) {
                        return Container();
                      } else if (state.fetchSearchResultStatus == ApiStatus.error ||
                          state.result == null ||
                          state.result!.items.isEmpty) {
                        return ErrorRetryWidget(
                          lottie: 'assets/cup.zip',
                          onTap: () => BlocProvider.of<SearchBloc>(context).add(
                              SearchEvent.getSearchResult(
                                  query: _textEditingController.text,
                                  filter: _selectedFilter,
                                  serviceType: settingsState.ytService)),
                        );
                      } else {
                        return SearcheResultSection(
                          locals: locals,
                          state: state,
                          searchQuery: _textEditingController.text,
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          );
        },
      )),
    );
  }

  Widget _buildFilterChip(String label, String filter, String serviceType) {
    final isSelected = _selectedFilter == filter;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? (isDarkMode ? kWhiteColor : kWhiteColor)
              : (isDarkMode ? kWhiteColor.withValues(alpha: 0.8) : kBlackColor),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => _onFilterChanged(filter, serviceType),
      backgroundColor: isDarkMode
          ? kWhiteColor.withValues(alpha: 0.1)
          : kGreyOpacityColor,
      selectedColor: kRedColor,
      checkmarkColor: kWhiteColor,
      side: BorderSide(
        color: isSelected
            ? kRedColor
            : (isDarkMode ? kWhiteColor.withValues(alpha: 0.3) : kGreyColor!.withValues(alpha: 0.3)),
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      showCheckmark: false,
    );
  }
}
