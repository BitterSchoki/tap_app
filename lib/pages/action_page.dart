import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_app/bloc/model_load/model_load_bloc.dart';

import '../widgets/widgets.dart';

class ActionPage extends StatelessWidget {
  const ActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TapAppScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SensorDebug(),
          ElevatedButton(
            onPressed: () {
              final modelLoadState = BlocProvider.of<ModelLoadBloc>(context).state;
              if (modelLoadState is ModelLoadSuccess) {
                // BlocProvider.of<ClassificationBloc>(context).add(
                //   ClassificationStarted(
                //     interpreter: modelLoadState.interpreter,
                //   ),
                // );
              }
            },
            child: Text('go'),
          ),
        ],
      ),
    );
  }
}
