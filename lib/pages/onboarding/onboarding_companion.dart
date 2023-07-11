import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/onboarding_image.dart';

class OnboardingCompanion extends StatelessWidget {
  const OnboardingCompanion({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingImage(
      assetPath: 'lib/assets/images/onboarding_companion.webp',
      stepCount: "STEP 1",
      title: "Download Companion App",
    );
  }
}
