import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/utils.dart';
import '../widgets/widgets.dart';

class CompanionPage extends StatelessWidget {
  const CompanionPage({super.key});

  static const String _webUrl = 'https://tap-app.webflow.io/';

  @override
  Widget build(BuildContext context) {
    return TapAppScaffold(
      appBarTitle: GlobalEn.companionAppBarTitle,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(),
              Column(
                children: [
                  CupertinoButton(
                    child: const Text(GlobalEn.goToWebUrl),
                    onPressed: () => _launchUrl(_webUrl),
                  ),
                  CupertinoButton.filled(
                    child: const Text(GlobalEn.shareLink),
                    onPressed: () => Share.share(_webUrl),
                  ),
                ],
              ),
              CupertinoButton(
                child: const Text(GlobalEn.next),
                onPressed: () => context.push('/connect'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final parsedUrl = Uri.parse(url);
    if (!await launchUrl(parsedUrl)) {
      throw Exception('Could not launch $parsedUrl');
    }
  }
}
