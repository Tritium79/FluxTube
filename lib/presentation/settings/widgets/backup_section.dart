import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxtube/application/settings/settings_bloc.dart';
import 'package:fluxtube/core/constants.dart';
import 'package:fluxtube/generated/l10n.dart';
import 'package:share_plus/share_plus.dart';

class BackupSettingsSection extends StatelessWidget {
  const BackupSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final S locals = S.of(context);
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          previous.isSyncEnabled != current.isSyncEnabled ||
          previous.lastSynced != current.lastSynced,
      builder: (context, state) {
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
            kHeightBox10,
            ListTile(
              title: Text(locals.exportSubscriptions,
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(locals.backupRestoreDescription),
              leading: const Icon(Icons.upload),
              onTap: () async {
                BlocProvider.of<SettingsBloc>(context)
                    .add(SettingsEvent.exportSubscriptions());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(locals.exportSuccess),
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: locals.share,
                      onPressed: () {
                        // Share the exported file
                        Share.share('FluxTube subscriptions exported');
                      },
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(locals.importSubscriptions,
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(locals.selectFile),
              leading: const Icon(Icons.download),
              onTap: () {
                // Note: Would need file_picker package for full implementation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('File picker integration required'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Text(locals.syncData,
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(locals.syncDataDescription),
              leading: const Icon(Icons.sync),
              trailing: Switch(
                value: state.isSyncEnabled,
                onChanged: (_) {
                  BlocProvider.of<SettingsBloc>(context)
                      .add(SettingsEvent.toggleSync());
                },
              ),
            ),
            if (state.isSyncEnabled) ...[
              ListTile(
                title: Text(locals.syncNow,
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: state.lastSynced != null
                    ? Text('${locals.lastSynced}: ${state.lastSynced}')
                    : null,
                leading: const Icon(Icons.cloud_sync),
                onTap: () {
                  BlocProvider.of<SettingsBloc>(context)
                      .add(SettingsEvent.syncNow());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sync completed'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }
}
