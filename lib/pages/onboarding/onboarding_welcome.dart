import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/onboarding_image.dart';

class OnboardingWelcome extends StatelessWidget {
  const OnboardingWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingImage(
      assetPath: 'lib/assets/images/onboarding_welcome.webp',
      stepCount: "WELCOME STRANGER",
      title: "This app will replace your presenter",
    );
  }
}
