import 'package:flutter/material.dart';

import '../../widgets/onboarding_image.dart';

class OnobardingPocket extends StatelessWidget {
  const OnobardingPocket({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingImage(
      assetPath: 'lib/assets/images/onboarding_pocket.webp',
      stepCount: "STEP 3",
      title: "Put Phone into Pocket",
    );
  }
}
