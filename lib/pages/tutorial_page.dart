import 'package:flutter/cupertino.dart';
import 'package:tap_app/utils/global/global.dart';

import '../widgets/tap_app_scaffold.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TapAppScaffold(
      appBarTitle: GlobalEn.tutorialAppBarTitle,
      child: Container(),
    );
  }
}
