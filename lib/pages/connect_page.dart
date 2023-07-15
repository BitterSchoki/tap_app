import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tap_app/utils/utils.dart';

import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

class ConnectPage extends StatelessWidget {
  const ConnectPage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ModelLoadBloc>(context).add(ModelLoadStarted());
    return TapAppScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(),
              Image.asset('lib/assets/images/tap_app_logo.webp'),
              SafeArea(
                child:
                    BlocConsumer<DeviceConnectionBloc, DeviceConnectionState>(
                  listener: (context, state) {
                    if (state is DeviceConnectionFailure) {
                      context.push('/connect/action');
                    } else if (state is DeviceConnectionFailure) {
                      _showAlertDialog(context);
                    }
                  },
                  builder: (context, state) {
                    return ConnectButton(
                      title: _getButtonTitle(state),
                      isLoading: state is DeviceConnectionInProgress,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getButtonTitle(DeviceConnectionState connectionState) {
    switch (connectionState.runtimeType) {
      case DeviceConnectionInitial:
      case DeviceConnectionFailure:
        return GlobalEn.connectButtonTitleDefault;
      case DeviceConnectionInProgress:
        return GlobalEn.connectButtonTitleConnecting;
      default:
        return '';
    }
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext dialogContext) => CupertinoAlertDialog(
        title: const Text(GlobalEn.connectionFailedDialogTitle),
        content: const Text(GlobalEn.conectionFailedDialogDescription),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              BlocProvider.of<DeviceConnectionBloc>(context).add(
                DeviceConnectionStarted(),
              );
              Navigator.pop(dialogContext);
            },
            child: const Text(GlobalEn.conectionFailedDialogTryAgain),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text(GlobalEn.conectionFailedDialogClose),
          ),
        ],
      ),
    );
  }
}
