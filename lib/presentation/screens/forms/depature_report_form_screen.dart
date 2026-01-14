import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class DepatureReportFormScreen extends StatelessWidget {
  static const name = 'depature-report-form-screen';

  const DepatureReportFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 14, 170, 170),
            Color.fromARGB(255, 5, 7, 7),
          ],
          stops: [0.1, 0.4],
        ),
      ),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: const CustomAppbar(),
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [Color.fromARGB(4, 148, 0, 0), Color.fromARGB(0, 105, 88, 19)],
              //   stops: [0.8,1.0],
              // ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  // Centered, scrollable card
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        top: 120,
                        bottom: 100,
                        left: 20,
                        right: 20,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: size.width < 600 ? size.width : 520,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                decoration: BoxDecoration(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 28,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 18),
                                    // const DepatureReportForm(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}