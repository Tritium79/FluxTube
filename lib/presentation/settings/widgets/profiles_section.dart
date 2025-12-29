import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxtube/application/settings/settings_bloc.dart';
import 'package:fluxtube/core/colors.dart';
import 'package:fluxtube/core/constants.dart';
import 'package:fluxtube/generated/l10n.dart';

class ProfilesSettingsSection extends StatelessWidget {
  const ProfilesSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final S locals = S.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          previous.profiles != current.profiles ||
          previous.currentProfile != current.currentProfile,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locals.profiles,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 16),
            ),
            kHeightBox5,
            Text(
              locals.profilesDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDarkMode
                        ? kWhiteColor.withValues(alpha: 0.6)
                        : kGreyColor,
                  ),
            ),
            kHeightBox10,
            ...state.profiles.map((profile) {
              final isSelected = state.currentProfile == profile;
              final isDefault = profile == 'default';
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                color: isSelected
                    ? (isDarkMode
                        ? kRedColor.withValues(alpha: 0.2)
                        : kRedColor.withValues(alpha: 0.1))
                    : (isDarkMode
                        ? kWhiteColor.withValues(alpha: 0.05)
                        : kWhiteColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? kRedColor
                        : (isDarkMode
                            ? kWhiteColor.withValues(alpha: 0.1)
                            : kGreyOpacityColor!),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Row(
                    children: [
                      Text(
                        isDefault ? locals.defaultProfile : profile,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                      ),
                      if (isSelected) ...[
                        kWidthBox10,
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: kRedColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            locals.profileInUse,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: kRedColor,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  leading: Icon(
                    isSelected ? Icons.person : Icons.person_outline,
                    color: isSelected ? kRedColor : null,
                  ),
                  trailing: !isDefault
                      ? PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            color: isDarkMode
                                ? kWhiteColor.withValues(alpha: 0.7)
                                : kGreyColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (value) {
                            if (value == 'rename') {
                              _showRenameProfileDialog(
                                  context, profile, locals);
                            } else if (value == 'delete') {
                              _showDeleteConfirmation(context, profile, locals);
                            }
                          },
                          itemBuilder: (ctx) => [
                            PopupMenuItem(
                              value: 'rename',
                              child: Row(
                                children: [
                                  const Icon(Icons.edit_outlined, size: 20),
                                  kWidthBox10,
                                  Text(locals.renameProfile),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline,
                                      size: 20, color: kRedColor),
                                  kWidthBox10,
                                  Text(locals.deleteProfile,
                                      style: TextStyle(color: kRedColor)),
                                ],
                              ),
                            ),
                          ],
                        )
                      : (isSelected
                          ? Icon(Icons.check_circle, color: kRedColor)
                          : null),
                  onTap: () {
                    if (!isSelected) {
                      BlocProvider.of<SettingsBloc>(context)
                          .add(SettingsEvent.switchProfile(profileName: profile));
                    }
                  },
                ),
              );
            }),
            kHeightBox5,
            OutlinedButton.icon(
              onPressed: () => _showAddProfileDialog(context, locals),
              icon: const Icon(Icons.add),
              label: Text(locals.addProfile),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDarkMode ? kWhiteColor : kBlackColor,
                side: BorderSide(
                  color: isDarkMode
                      ? kWhiteColor.withValues(alpha: 0.3)
                      : kGreyColor!.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, String profile, S locals) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(locals.deleteProfile),
        content: Text('Delete profile "$profile"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<SettingsBloc>(context)
                  .add(SettingsEvent.deleteProfile(profileName: profile));
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: kRedColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddProfileDialog(BuildContext context, S locals) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(locals.addProfile),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: locals.profileName,
            hintText: 'Enter profile name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                BlocProvider.of<SettingsBloc>(context)
                    .add(SettingsEvent.addProfile(profileName: name));
              }
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: kRedColor),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showRenameProfileDialog(
      BuildContext context, String oldName, S locals) {
    final controller = TextEditingController(text: oldName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(locals.renameProfile),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: locals.newProfileName,
            hintText: 'Enter new name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && newName != oldName) {
                BlocProvider.of<SettingsBloc>(context).add(
                    SettingsEvent.renameProfile(
                        oldName: oldName, newName: newName));
              }
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: kRedColor),
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }
}
