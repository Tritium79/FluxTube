import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxtube/application/application.dart';
import 'package:fluxtube/core/enums.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  void _initializeSettings() {
    // Initialize the settings bloc
    BlocProvider.of<SettingsBloc>(context)
        .add(SettingsEvent.initializeSettings());
    BlocProvider.of<SubscribeBloc>(context)
        .add(const SubscribeEvent.getAllSubscribeList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
        return BlocBuilder<SubscribeBloc, SubscribeState>(
          builder: (context, subscribeState) {
            _handleState(state, subscribeState);

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 24),
                  // Show connection status when testing instances
                  if (state.isTestingConnection && state.connectingToInstance != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          Text(
                            'Connecting to API...',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.connectingToInstance!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  else if (state.settingsStatus == ApiStatus.loading)
                    Text(
                      'Loading settings...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    )
                  else if (subscribeState.subscribeStatus == ApiStatus.loading)
                    Text(
                      'Loading subscriptions...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  void _handleState(SettingsState state, SubscribeState subscribeState) async {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);

    // Fetch instances based on service type
    // For invidious: fetch invidious instances
    // For piped/iframe/explode: fetch piped instances (they all use piped API for feeds)
    if (state.initialized) {
      if (state.ytService == YouTubeServices.invidious.name) {
        if (state.invidiousInstances.isEmpty &&
            state.invidiousInstanceStatus != ApiStatus.loading) {
          settingsBloc.add(SettingsEvent.fetchInvidiousInstances());
        }
      } else {
        // piped, iframe, and explode all use piped API for trending/search/channels
        if (state.pipedInstances.isEmpty &&
            state.pipedInstanceStatus != ApiStatus.loading) {
          settingsBloc.add(SettingsEvent.fetchPipedInstances());
        }
      }
    }

    // Check if instances are ready
    final bool instancesReady;
    if (state.ytService == YouTubeServices.invidious.name) {
      instancesReady = state.invidiousInstanceStatus == ApiStatus.loaded ||
          state.invidiousInstanceStatus == ApiStatus.error;
    } else {
      // piped, iframe, explode all need piped instances
      instancesReady = state.pipedInstanceStatus == ApiStatus.loaded ||
          state.pipedInstanceStatus == ApiStatus.error;
    }

    // go to home screen
    if ((state.settingsStatus == ApiStatus.loaded ||
            state.settingsStatus == ApiStatus.error) &&
        instancesReady &&
        (subscribeState.subscribeStatus == ApiStatus.loaded ||
            subscribeState.subscribeStatus == ApiStatus.error)) {
      {
        await Future.delayed(const Duration());
        if (mounted) {
          Router.neglect(context, () {
            context
                .goNamed('main');
          });
        }
      }
    }
  }
}
