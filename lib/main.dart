import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tap_app/bloc/bloc.dart';
import 'package:tap_app/bloc/recording/recording_bloc.dart';
import 'package:tap_app/pages/pages.dart';
import 'package:tap_app/pages/shell.dart';
import 'package:tap_app/provider/data_provider.dart';

import 'utils/utils.dart';

void main() => runApp(const TapApp());

class TapApp extends StatelessWidget {
  const TapApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = DataProvider();
    final modelLoadBloc = ModelLoadBloc();
    final deviceCommunicationReceiveBloc = DeviceCommunicationReceiveBloc();

    return CupertinoApp.router(
      routerConfig: GoRouter(
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
              return BlocProvider<CompanionBloc>(
                create: (context) => CompanionBloc()
                  ..add(
                    CompanionCheckStarted(),
                  ),
                child: const Shell(),
              );
            },
            routes: [
              GoRoute(
                  path: 'connect',
                  builder: (BuildContext context, GoRouterState state) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider<DeviceConnectionBloc>(
                          create: (context) => DeviceConnectionBloc(
                            dataProvider: dataProvider,
                            deviceCommunicationReceiveBloc:
                                deviceCommunicationReceiveBloc,
                          ),
                        ),
                        BlocProvider<ModelLoadBloc>(
                          create: (context) =>
                              modelLoadBloc..add(ModelLoadStarted()),
                        ),
                      ],
                      child: const ConnectPage(),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'action',
                      builder: (BuildContext context, GoRouterState state) {
                        final classificationBloc = ClassificationBloc();

                        return MultiBlocProvider(
                          providers: [
                            BlocProvider<DeviceCommunicationSendBloc>(
                              create: (context) => DeviceCommunicationSendBloc(
                                dataProvider: dataProvider,
                              ),
                            ),
                            BlocProvider<DeviceCommunicationReceiveBloc>(
                              create: (context) =>
                                  deviceCommunicationReceiveBloc,
                            ),
                            BlocProvider<ClassificationBloc>(
                              create: (context) => classificationBloc,
                            ),
                            BlocProvider<RecordingBloc>(
                              create: (context) => RecordingBloc(
                                classificationBloc: classificationBloc,
                              ),
                            ),
                          ],
                          child: const ActionPage(),
                        );
                      },
                    ),
                  ]),
              GoRoute(
                path: 'companion',
                builder: (BuildContext context, GoRouterState state) {
                  return const TutorialPage();
                },
              ),
              GoRoute(
                path: 'onboarding',
                builder: (BuildContext context, GoRouterState state) {
                  return const OnboardingPage();
                },
              ),
            ],
          ),
        ],
      ),
      theme: cupertinoDark,
    );
  }
}
