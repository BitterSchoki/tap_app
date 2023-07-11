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
    return TapAppScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('lib/assets/images/tap_app_logo.webp'),
          BlocConsumer<DeviceConnectionBloc, DeviceConnectionState>(
            builder: ((context, state) {
              if (state is DeviceConnectionInitial) {
                return const ConnectButton(
                  title: GlobalEn.connectButtonTitleDefault,
                );
              } else if (state is DeviceConnectionInProgress) {
                return const ConnectButton(
                  title: GlobalEn.connectButtonTitleConnecting,
                  isLoading: true,
                );
              } else if (state is DeviceConnectionFailure) {
                return const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(GlobalEn.connectionFailed),
                    ),
                    ConnectButton(
                      title: GlobalEn.connectButtonTitleFailed,
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
            listener: (context, state) {
              if (state is DeviceConnectionSuccess) {
                context.go('/action');
              }
            },
          ),
        ],
      ),
    );
  }
}
