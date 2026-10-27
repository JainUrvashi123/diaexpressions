import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class EmailSuccessView extends StatefulWidget {
  const EmailSuccessView({super.key});

  @override
  State<EmailSuccessView> createState() => _EmailSuccessViewState();
}

class _EmailSuccessViewState extends State<EmailSuccessView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Bounce-out scale animation for the checkmark circle
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    // Fade-in animation for text and buttons
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F5), // Light warm background matching cart details page
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // Animated Checkmark
              Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(120, 120),
                        painter: DrawingCheckmarkPainter(_controller.value),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Success Text Fade In
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const Text(
                      'Success!',
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your cart details have been emailed successfully.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Buttons at the bottom
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false, arguments: 1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryButton,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawingCheckmarkPainter extends CustomPainter {
  final double progress;

  DrawingCheckmarkPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Background Circle Paint (light subtle green)
    final bgPaint = Paint()
      ..color = const Color(0xFFE8F5E9)
      ..style = PaintingStyle.fill;

    // Checkmark & Border Paint (active green)
    final activePaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw the background circular fill
    canvas.drawCircle(center, radius, bgPaint);

    // Map global progress (0.0 to 1.0) into circle animation and checkmark animation
    // Circle draws from 0.0 to 0.4 progress
    double circleProgress = (progress / 0.4).clamp(0.0, 1.0);
    // Checkmark draws from 0.4 to 1.0 progress
    double checkProgress = ((progress - 0.4) / 0.6).clamp(0.0, 1.0);

    // Draw circle border
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 3),
      -3.14159 / 2, // Start at 12 o'clock
      2 * 3.14159 * circleProgress,
      false,
      activePaint,
    );

    // Draw checkmark lines
    if (progress > 0.4) {
      final path = Path();
      // Left point of checkmark
      final startPoint = Offset(size.width * 0.32, size.height * 0.52);
      // Bottom bend point of checkmark
      final midPoint = Offset(size.width * 0.47, size.height * 0.66);
      // Right top point of checkmark
      final endPoint = Offset(size.width * 0.70, size.height * 0.38);

      path.moveTo(startPoint.dx, startPoint.dy);

      if (checkProgress < 0.4) {
        // Drawing first segment (start -> mid)
        double segmentProgress = checkProgress / 0.4;
        double currentX = startPoint.dx + (midPoint.dx - startPoint.dx) * segmentProgress;
        double currentY = startPoint.dy + (midPoint.dy - startPoint.dy) * segmentProgress;
        path.lineTo(currentX, currentY);
      } else {
        // First segment complete
        path.lineTo(midPoint.dx, midPoint.dy);
        // Drawing second segment (mid -> end)
        double segmentProgress = (checkProgress - 0.4) / 0.6;
        double currentX = midPoint.dx + (endPoint.dx - midPoint.dx) * segmentProgress;
        double currentY = midPoint.dy + (endPoint.dy - midPoint.dy) * segmentProgress;
        path.lineTo(currentX, currentY);
      }
      canvas.drawPath(path, activePaint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingCheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
