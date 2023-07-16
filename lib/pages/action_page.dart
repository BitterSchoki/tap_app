import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:tap_app/bloc/bloc.dart';
import 'package:tap_app/bloc/recording/recording_bloc.dart';
import 'package:tap_app/utils/utils.dart';

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "History:",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  BlocBuilder<DeviceCommunicationReceiveBloc,
                      DeviceCommunicationReceiveState>(
                    builder: (context, state) {
                      if (state is DeviceCommunicationMessageReceivedSuccess) {
                        return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: state.messages.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(state.messages[index]);
                            });
                      } else {
                        return const Text("no taps yet");
                      }
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    CupertinoButton(
                      child: const Text('Table'),
                      onPressed: () {
                        _selectTabType(
                          context,
                          tabType: TabType.table,
                        );
                      },
                    ),
                    CupertinoButton(
                      child: const Text('Pocket'),
                      onPressed: () {
                        _selectTabType(
                          context,
                          tabType: TabType.pocket,
                        );
                      },
                    ),
                    CupertinoButton(
                      child: const Text('Hand'),
                      onPressed: () {
                        _selectTabType(
                          context,
                          tabType: TabType.hand,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 75.0,
                ),
                child: SlideAction(
                  text: "Disconnect",
                  height: 48,
                  borderRadius: 10,
                  sliderButtonIconPadding: 6,
                  innerColor: Colors.white,
                  outerColor: CustomColors.darkPurple,
                  sliderButtonIcon: const Icon(
                    Icons.cancel,
                    color: CustomColors.darkPurple,
                  ),
                  onSubmit: () async {
                    BlocProvider.of<RecordingBloc>(context).add(
                      RecordingStopped(),
                    );
                    BlocProvider.of<ClassificationBloc>(context).add(
                      ClassificationStopped(),
                    );
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      context.push('/connect');
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectTabType(
    BuildContext context, {
    required TabType tabType,
  }) {
    BlocProvider.of<RecordingBloc>(context).add(RecordingStarted());
    final modelLoadState = BlocProvider.of<ModelLoadBloc>(context).state;
    if (modelLoadState is ModelLoadSuccess) {
      BlocProvider.of<ClassificationBloc>(context).add(
        ClassificationStarted(
          interpreter: modelLoadState.interpreter,
          tabType: tabType,
        ),
      );
    }
  }
}
