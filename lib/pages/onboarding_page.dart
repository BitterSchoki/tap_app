import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tap_app/utils/utils.dart';
import '../utils/global/global_en.dart';
import 'onboarding/onboarding_pages.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();

  static const int pageCount = 4;
  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                isLastPage = (index == pageCount - 1);
              });
            },
            controller: _controller,
            children: const [
              OnboardingCompanion(),
              OnboardingConnect(),
              OnobardingPocket(),
              OnboardingTap(),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(25.0),
            alignment: Alignment.center,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: CupertinoButton(
                          color: Colors.grey.shade200.withOpacity(0.5),
                          onPressed: () {
                            isLastPage
                                ? context.push("/companion")
                                : _controller.nextPage(
                                    duration: const Duration(
                                      milliseconds: 400,
                                    ),
                                    curve: Curves.easeOut,
                                  );
                          },
                          child: Text(
                            isLastPage ? GlobalEn.done : GlobalEn.next,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: pageCount,
                    effect: const ExpandingDotsEffect(
                      dotColor: CustomColors.dotColor,
                      activeDotColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
