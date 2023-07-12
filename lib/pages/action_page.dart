import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:tap_app/bloc/bloc.dart';
import 'package:tap_app/bloc/recording/recording_bloc.dart';
import 'package:tap_app/utils/themes/colors.dart';

import '../widgets/widgets.dart';

class ActionPage extends StatelessWidget {
  const ActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TapAppScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<RecordingBloc>(context).add(RecordingStarted());
              final modelLoadState = BlocProvider.of<ModelLoadBloc>(context).state;
              if (modelLoadState is ModelLoadSuccess) {
                BlocProvider.of<ClassificationBloc>(context).add(
                  ClassificationStarted(
                    interpreter: modelLoadState.interpreter,
                  ),
                );
              }
            },
            child: Text('go'),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: SlideAction(
              text: "Disconnect",
              elevation: 0,
              innerColor: CustomColors.darkPurple,
              outerColor: Colors.white,
              sliderButtonIcon: const Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              onSubmit: () async {
                BlocProvider.of<RecordingBloc>(context).add(
                  RecordingStopped(),
                );
                context.push('/');
              },
            ),
          ),
        ],
      ),
    );
  }
}
