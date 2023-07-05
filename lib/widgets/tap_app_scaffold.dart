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
      // leading: Icon(CupertinoIcons.arrow_right_arrow_left_square),
      trailing: const Icon(CupertinoIcons.question_circle),
      largeTitle: Text(
        appBarTitle,
      ),
    );
  }
}
