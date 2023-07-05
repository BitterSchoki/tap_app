import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';

class ConnectButton extends StatelessWidget {
  const ConnectButton({
    super.key,
    required this.title,
    this.isLoading = false,
  });

  final String title;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final selectionBloc = BlocProvider.of<DeviceConnectionBloc>(context);

    return CupertinoButton.filled(
      onPressed: isLoading
          ? null
          : () {
              selectionBloc.add(
                DeviceConnectionStarted(),
              );
            },
      child: Text(title),
    );
  }
}
