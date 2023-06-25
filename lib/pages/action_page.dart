import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import '../bloc/bloc.dart';

class ActionPage extends StatelessWidget {
  const ActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final actionBloc = BlocProvider.of<DeviceActionBloc>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Action Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SensorDebug(),
            const SizedBox(
              height: 100,
            ),
            BlocConsumer<DeviceActionBloc, DeviceActionState>(
                builder: ((context, state) {
              if (state is DeviceActionInitial ||
                  state is DeviceActionSuccess ||
                  state is DeviceActionFailure) {
                return Column(
                  children: [
                    if (state is DeviceActionFailure)
                      const Text('Action failed'),
                    ElevatedButton(
                      onPressed: () => actionBloc.add(
                        const DeviceActionStarted(
                            actionType: DeviceActionType.previous),
                      ),
                      child: const Text('Previous'),
                    ),
                    ElevatedButton(
                      onPressed: () => actionBloc.add(
                        const DeviceActionStarted(
                            actionType: DeviceActionType.next),
                      ),
                      child: const Text('Next'),
                    ),
                  ],
                );
              } else if (state is DeviceActionInProgress) {
                return Text(
                    '${state.actionType.toShortString()} in progress...');
              } else {
                return const SizedBox.shrink();
              }
            }), listener: (context, state) {
              if (state is DeviceActionSuccess) {
                final snackBar = SnackBar(
                  content: Text('${state.actionType.toShortString()} success'),
                  duration: const Duration(seconds: 1),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (state is DeviceActionFailure) {
                final snackBar = SnackBar(
                  content: Text('${state.actionType.toShortString()} failure'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: Colors.red,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
  }
}
