import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

import 'package:flutter/cupertino.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TapAppScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('lib/assets/tap_app_logo.webp'),
          BlocConsumer<DeviceConnectionBloc, DeviceConnectionState>(
              builder: ((context, state) {
            if (state is DeviceConnectionInitial) {
              return const ConnectButton();
            } else if (state is DeviceConnectionInProgress) {
              return const CupertinoButton.filled(
                onPressed: null,
                child: Text('Connecting...'),
              );
            } else if (state is DeviceConnectionFailure) {
              return const Column(
                children: [
                  Text('Connection failed'),
                  ConnectButton(),
                ],
              );
            } else if (state is DeviceConnectionSuccess) {
              return CupertinoButton.filled(
                onPressed: () => context.go('/action'),
                child: const Text('Action'),
              );
            } else {
              return const SizedBox.shrink();
            }
          }), listener: (context, state) {
            if (state is DeviceConnectionSuccess) {
              context.go('/action');
            }
          }),
        ],
      ),
    );
  }
}
