import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          StepName(nextPage: nextPage),
          const StepPhoto(),
        ],
      ),
    );
  }
}
