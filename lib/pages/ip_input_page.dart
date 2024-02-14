import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_app/bloc/bloc.dart';

class IpInputPage extends StatefulWidget {
  const IpInputPage({super.key});

  @override
  State<IpInputPage> createState() => _IpInputPageState();
}

class _IpInputPageState extends State<IpInputPage> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: 'ip');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              CupertinoTextField(
                controller: _textController,
              ),
              CupertinoButton.filled(
                child: Text('ok'),
                onPressed: () {
                  BlocProvider.of<DeviceConnectionBloc>(context).add(
                    IPAdressSet(ip: _textController.text),
                  );
                  print(_textController.text);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
