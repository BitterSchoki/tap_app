import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocConsumer<DeviceConnectionBloc, DeviceConnectionState>(
                builder: ((context, state) {
              if (state is DeviceConnectionInitial) {
                return const ConnectButton();
              } else if (state is DeviceConnectionInProgress) {
                return const Text('Connecting...');
              } else if (state is DeviceConnectionFailed) {
                return const Column(
                  children: [
                    Text('Connection failed'),
                    ConnectButton(),
                  ],
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
      ),
    );
  }
}
