import 'package:flutter/cupertino.dart';

import '../utils/utils.dart';

class TapAppScaffold extends StatelessWidget {
  const TapAppScaffold({
    required this.child,
    this.appBarTitle = GlobalEn.appName,
    super.key,
  });
  final Widget child;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          _TapAppAppBar(
            appBarTitle: appBarTitle,
          ),
          SliverFillRemaining(
            child: child,
          )
        ],
      ),
    );
  }
}

class _TapAppAppBar extends StatelessWidget {
  const _TapAppAppBar({
    required this.appBarTitle,
  });

  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      trailing: GestureDetector(
        child: const Icon(
          CupertinoIcons.question_circle,
        ),
        onTap: () {
          _showAlertDialog(context);
        },
      ),
      largeTitle: Text(
        appBarTitle,
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Need help?'),
        content: const Text('Go to download...'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Understand'),
          ),
        ],
      ),
    );
  }
}
