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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: BlocBuilder<DeviceCommunicationReceiveBloc, DeviceCommunicationReceiveState>(
                  builder: (context, state) {
                    if (state is DeviceCommunicationMessageReceivedSuccess) {
                      return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: state.messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(state.messages[index]);
                          });
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
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
                child: const Text('Start'),
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
                    context.push('/connect');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
