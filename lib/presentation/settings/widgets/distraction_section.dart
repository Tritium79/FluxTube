import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxtube/application/settings/settings_bloc.dart';
import 'package:fluxtube/core/constants.dart';
import 'package:fluxtube/core/enums.dart';
import 'package:fluxtube/generated/l10n.dart';

class DistractionFreeSettingsSection extends StatelessWidget {
  const DistractionFreeSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final S locals = S.of(context);
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          previous.isHideComments != current.isHideComments ||
          previous.isHideRelated != current.isHideRelated ||
          previous.homeFeedMode != current.homeFeedMode,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locals.distractionFree,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 16),
            ),
            kHeightBox10,
            ListTile(
              title: Text(locals.hideComments,
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(locals.hideCommentsButtonFromWatchScreen),
              leading: const Icon(CupertinoIcons.bubble_left_bubble_right_fill),
              trailing: Switch(
                value: state.isHideComments,
                onChanged: (_) {
                  BlocProvider.of<SettingsBloc>(context)
                      .add(SettingsEvent.toggleCommentVisibility());
                },
              ),
            ),
            ListTile(
              title: Text(locals.hideRelated,
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(locals.hideRelatedVideosFromWatchScreen),
              leading: const Icon(Icons.video_settings),
              trailing: Switch(
                value: state.isHideRelated,
                onChanged: (_) {
                  BlocProvider.of<SettingsBloc>(context)
                      .add(SettingsEvent.toggleRelatedVideoVisibility());
                },
              ),
            ),
            ListTile(
              title: Text(locals.homeFeedMode,
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(_getHomeFeedModeDescription(state.homeFeedMode, locals)),
              leading: const Icon(Icons.home_outlined),
              trailing: DropdownButton<String>(
                value: state.homeFeedMode,
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(
                    value: HomeFeedMode.feedOrTrending.name,
                    child: Text(locals.homeFeedModeAuto),
                  ),
                  DropdownMenuItem(
                    value: HomeFeedMode.feedOnly.name,
                    child: Text(locals.homeFeedModeFeedOnly),
                  ),
                  DropdownMenuItem(
                    value: HomeFeedMode.trendingOnly.name,
                    child: Text(locals.homeFeedModeTrendingOnly),
                  ),
                ],
                onChanged: (mode) {
                  if (mode != null) {
                    BlocProvider.of<SettingsBloc>(context)
                        .add(SettingsEvent.setHomeFeedMode(mode: mode));
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String _getHomeFeedModeDescription(String mode, S locals) {
    if (mode == HomeFeedMode.feedOnly.name) {
      return locals.homeFeedModeFeedOnlyHint;
    } else if (mode == HomeFeedMode.trendingOnly.name) {
      return locals.homeFeedModeTrendingOnlyHint;
    }
    return locals.homeFeedModeAutoHint;
  }
}

// SettingsSection distractionFreeSettingsSection(
//     S locals, BuildContext context, SettingsState state) {
//   return SettingsSection(
//     title: Text(
//       locals.distractionFree,
//       style: Theme.of(context).textTheme.bodyMedium,
//     ),
//     tiles: [
//       SettingsTile.switchTile(
//         initialValue: state.isHideComments,
//         title: Text(locals.hideComments),
//         description: Text(locals.hideCommentsButtonFromWatchScreen),
//         leading: const Icon(CupertinoIcons.bubble_left_bubble_right_fill),
//         onToggle: (_) {
//           BlocProvider.of<SettingsBloc>(context)
//               .add(SettingsEvent.toggleCommentVisibility());
//         },
//       ),
//       SettingsTile.switchTile(
//         initialValue: state.isHideRelated,
//         title: Text(locals.hideRelated),
//         description: Text(locals.hideRelatedVideosFromWatchScreen),
//         leading: const Icon(Icons.video_settings),
//         onToggle: (_) {
//           BlocProvider.of<SettingsBloc>(context)
//               .add(SettingsEvent.toggleRelatedVideoVisibility());
//         },
//       )
//     ],
//   );
// }
