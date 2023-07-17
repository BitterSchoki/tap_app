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
                  //
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    CupertinoButton(
                      child: const Text('Table'),
                      onPressed: () {
                        _selectTapType(
                          context,
                          tapType: TapType.table,
                        );
                      },
                    ),
                    CupertinoButton(
                      child: const Text('Pocket'),
                      onPressed: () {
                        _selectTapType(
                          context,
                          tapType: TapType.pocket,
                        );
                      },
                    ),
                    CupertinoButton(
                      child: const Text('Hand'),
                      onPressed: () {
                        _selectTapType(
                          context,
                          tapType: TapType.hand,
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
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
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

  void _selectTapType(
    BuildContext context, {
    required TapType tapType,
  }) {
    BlocProvider.of<RecordingBloc>(context).add(RecordingStarted());
    final modelLoadState = BlocProvider.of<ModelLoadBloc>(context).state;
    if (modelLoadState is ModelLoadSuccess) {
      BlocProvider.of<ClassificationBloc>(context).add(
        ClassificationStarted(
          interpreter: modelLoadState.interpreter,
          tapType: tapType,
        ),
      );
    }
  }
}
