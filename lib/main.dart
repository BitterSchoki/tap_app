import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tap_app/bloc/bloc.dart';
import 'package:tap_app/pages/pages.dart';
import 'package:tap_app/provider/data_provider.dart';

import 'utils/utils.dart';

void main() => runApp(const TapApp());

class TapApp extends StatelessWidget {
  const TapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      routerConfig: _router,
      theme: cupertinoLight,
    );
  }
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider<DeviceConnectionBloc>(
          create: (context) => DeviceConnectionBloc(
            dataProvider: DataProvider(),
          ),
          child: const HomePage(),
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'action',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider<DeviceActionBloc>(
              create: (context) => DeviceActionBloc(),
              child: const ActionPage(),
            );
          },
        ),
      ],
    ),
  ],
);
