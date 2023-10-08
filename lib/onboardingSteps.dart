import 'package:flutter/material.dart';
import 'constants.dart';


// Your widget class
class CreativeStepsWidget extends StatefulWidget {
  const CreativeStepsWidget({super.key});

  @override
  _CreativeStepsWidgetState createState() => _CreativeStepsWidgetState();
}

class _CreativeStepsWidgetState extends State<CreativeStepsWidget>
    with SingleTickerProviderStateMixin {
  // Use the mixin here
  late AnimationController _controller;

  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, // Use 'this' as the vsync parameter
        duration: const Duration(seconds: 1));
    _controller.forward().whenComplete(() {
      setState(() {
        currentStep++;
        if (currentStep < steps.length) {
          _controller.reset();
          _controller.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < steps.length; i++)
          _buildStep(i + 1, steps[i]['title']!, steps[i]['description']!,
              steps[i]['example']!),
      ],
    );
  }

  Widget _buildStep(
      int stepNumber, String title, String description, String example) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                color: ColorConstants.colorHeaders,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(
                color: ColorConstants.colorTexts,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              example,
              style: TextStyle(
                color: ColorConstants.colorTexts,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
