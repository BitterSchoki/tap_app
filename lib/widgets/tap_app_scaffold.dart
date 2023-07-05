import 'package:flutter/cupertino.dart';

import '../utils/utils.dart';

class TapAppScaffold extends StatelessWidget {
  const TapAppScaffold({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          const _TapAppAppBar(),
          SliverFillRemaining(
            child: child,
          )
        ],
      ),
    );
  }
}

class _TapAppAppBar extends StatelessWidget {
  const _TapAppAppBar();

  @override
  Widget build(BuildContext context) {
    return const CupertinoSliverNavigationBar(
      // leading: Icon(CupertinoIcons.arrow_right_arrow_left_square),
      trailing: Icon(CupertinoIcons.question_circle),
      largeTitle: Text(
        GlobalEn.appName,
      ),
    );
  }
}
