import 'package:flutter/material.dart';

import '../../widgets/onboarding_image.dart';

class OnboardingTap extends StatelessWidget {
  const OnboardingTap({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingImage(
      assetPath: 'lib/assets/images/onboarding_companion.webp',
      stepCount: "STEP 4",
      title: "Tap on back to skip\n Double Tap to previous",
    );
  }
}
