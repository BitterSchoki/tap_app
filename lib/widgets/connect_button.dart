import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';

class ConnectButton extends StatelessWidget {
  const ConnectButton({super.key});

  @override
  Widget build(BuildContext context) {
    final selectionBloc = BlocProvider.of<DeviceConnectionBloc>(context);

    return CupertinoButton.filled(
      onPressed: () {
        selectionBloc.add(
          DeviceConnectionStarted(),
        );
      },
      child: const Text('Connect'),
    );
  }
}
