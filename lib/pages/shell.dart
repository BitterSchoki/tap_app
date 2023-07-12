import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tap_app/bloc/bloc.dart';

class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompanionBloc, CompanionState>(
      listener: (context, state) {
        if (state is ShowCompanionSuccess) {
          context.push('/onboarding');
        } else if (state is DontShowCompanionSuccess) {
          context.push('/connect');
        }
      },
      child: const CupertinoActivityIndicator(),
    );
  }
}
