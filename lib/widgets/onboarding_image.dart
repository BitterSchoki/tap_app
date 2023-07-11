import 'package:flutter/material.dart';

class OnboardingImage extends StatelessWidget {
  const OnboardingImage({
    super.key,
    required this.assetPath,
    required this.stepCount,
    required this.title,
  });

  final String assetPath;
  final String stepCount;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          assetPath,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color.fromARGB(179, 0, 0, 0),
                Color.fromARGB(0, 0, 0, 0),
                Color.fromARGB(0, 0, 0, 0),
                Color.fromARGB(179, 0, 0, 0),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Text(
                  stepCount,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
