import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tap_app/bloc/bloc.dart';
import 'package:tap_app/bloc/recording/recording_bloc.dart';
import 'package:tap_app/pages/pages.dart';
import 'package:tap_app/provider/data_provider.dart';

import 'utils/utils.dart';

void main() => runApp(const TapApp());

class TapApp extends StatelessWidget {
  const TapApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = DataProvider();
    final deviceCommunicationReceiveBloc = DeviceCommunicationReceiveBloc();
    final deviceConnectionBloc = DeviceConnectionBloc(
      dataProvider: dataProvider,
      deviceCommunicationReceiveBloc: deviceCommunicationReceiveBloc,
    );
    final modelLoadBloc = ModelLoadBloc();

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
                path: 'onboarding',
                builder: (BuildContext context, GoRouterState state) {
                  return const OnboardingPage();
                },
              ),
              GoRoute(
                path: 'companion',
                builder: (BuildContext context, GoRouterState state) {
                  return const CompanionPage();
                },
              ),
              GoRoute(
                path: 'connect',
                builder: (BuildContext context, GoRouterState state) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<DeviceConnectionBloc>(create: (context) => deviceConnectionBloc),
                      BlocProvider<ModelLoadBloc>(
                        create: (context) => modelLoadBloc,
                      ),
                    ],
                    child: const ConnectPage(),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'action',
                    builder: (BuildContext context, GoRouterState state) {
                      final deviceCommunicationSendBloc = DeviceCommunicationSendBloc(
                        dataProvider: dataProvider,
                      );
                      final classificationBloc = ClassificationBloc(
                        deviceCommunicationSendBloc: deviceCommunicationSendBloc,
                      );

                      return MultiBlocProvider(
                        providers: [
                          BlocProvider<DeviceCommunicationSendBloc>(
                            create: (context) => deviceCommunicationSendBloc,
                          ),
                          BlocProvider<DeviceCommunicationReceiveBloc>(
                            create: (context) => deviceCommunicationReceiveBloc,
                          ),
                          BlocProvider<ClassificationBloc>(
                            create: (context) => classificationBloc,
                          ),
                          BlocProvider<RecordingBloc>(
                            create: (context) => RecordingBloc(
                              classificationBloc: classificationBloc,
                            ),
                          ),
                          BlocProvider<DeviceConnectionBloc>.value(
                            value: deviceConnectionBloc,
                          ),
                          BlocProvider<ModelLoadBloc>.value(
                            value: modelLoadBloc,
                          )
                        ],
                        child: const ActionPage(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      theme: cupertinoDark,
    );
  }
}
