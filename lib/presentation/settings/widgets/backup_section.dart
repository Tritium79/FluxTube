import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxtube/application/application.dart';
import 'package:fluxtube/core/constants.dart';
import 'package:fluxtube/generated/l10n.dart';
import 'package:share_plus/share_plus.dart' show ShareParams, SharePlus, XFile;

class BackupSettingsSection extends StatelessWidget {
  const BackupSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final S locals = S.of(context);

    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          previous.currentProfile != current.currentProfile ||
          previous.lastExportedFilePath != current.lastExportedFilePath,
      builder: (context, settingsState) {
        final currentProfile = settingsState.currentProfile;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locals.backupRestore,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 16),
            ),
            if (currentProfile != 'default')
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Profile: $currentProfile',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            kHeightBox10,
            ListTile(
              title: Text(locals.exportSubscriptions,
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(locals.backupRestoreDescription),
              leading: const Icon(Icons.upload),
              onTap: () async {
                await _exportSubscriptions(context, currentProfile, locals);
              },
            ),
            ListTile(
              title: Text(locals.importSubscriptions,
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(locals.selectFile),
              leading: const Icon(Icons.download),
              onTap: () async {
                await _importSubscriptions(context, currentProfile, locals);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportSubscriptions(
      BuildContext context, String currentProfile, S locals) async {
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 16),
            const Text('Exporting...'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    // Dispatch export event and wait for state update
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    settingsBloc.add(SettingsEvent.exportSubscriptions(profileName: currentProfile));

    // Wait for the export to complete and state to update
    await Future.delayed(const Duration(milliseconds: 800));

    // Get the exported file path from state
    final exportedFilePath = settingsBloc.state.lastExportedFilePath;

    // Show success message with share option
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(locals.exportSuccess),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          action: exportedFilePath != null
              ? SnackBarAction(
                  label: locals.share,
                  onPressed: () async {
                    await SharePlus.instance.share(
                      ShareParams(files: [XFile(exportedFilePath)]),
                    );
                  },
                )
              : null,
        ),
      );
    }
  }

  Future<void> _importSubscriptions(
      BuildContext context, String currentProfile, S locals) async {
    try {
      // Open file picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return; // User cancelled
      }

      final filePath = result.files.first.path;
      if (filePath == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(locals.importError),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 16),
                const Text('Importing...'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Dispatch import event
      BlocProvider.of<SettingsBloc>(context).add(
        SettingsEvent.importSubscriptions(
          filePath: filePath,
          profileName: currentProfile,
        ),
      );

      // Wait for import to process
      await Future.delayed(const Duration(milliseconds: 800));

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(locals.importSuccess),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Refresh subscriptions
        BlocProvider.of<SubscribeBloc>(context).add(
          const SubscribeEvent.getAllSubscribeList(),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${locals.importError}: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
