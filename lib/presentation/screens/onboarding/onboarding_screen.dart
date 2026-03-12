import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class OnboardingScreen extends StatefulWidget {
  static const name = 'onboarding-screen';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();

  void nextPage() {
    controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void previousPage() {
    controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          PageView(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StepName(nextPage: nextPage),
              StepPhoto(previousPage: previousPage, nextPage: nextPage),
              StepComplete()
            ],
          ),

          /// Indicador
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).padding.top + 20,
            child: Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  spacing: 8,
                  activeDotColor: const Color.fromARGB(189, 7, 213, 213),
                  dotColor: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
