import 'package:flutter/material.dart';

import '../../widgets/onboarding_image.dart';

class OnboardingConnect extends StatelessWidget {
  const OnboardingConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingImage(
      assetPath: 'lib/assets/images/onboarding_connect.webp',
      stepCount: "STEP 2",
      title: "Connect Phone with Laptop",
    );
  }
}
