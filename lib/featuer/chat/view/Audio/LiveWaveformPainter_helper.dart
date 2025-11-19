import 'package:flutter/material.dart';

class LiveWaveformPainter extends CustomPainter {
  final List<double> samples;
  final Color color;

  LiveWaveformPainter({required this.samples, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final double spacing = 4.0;
    final double barWidth = 3.0;
    final double maxBars = size.width / (barWidth + spacing);
    
    // Determine start index to make it scroll (show latest data)
    int startIndex = 0;
    if (samples.length > maxBars) {
      startIndex = samples.length - maxBars.toInt();
    }

    for (int i = startIndex; i < samples.length; i++) {
      final double normalizedHeight = samples[i];
      // Calculate bar height based on sample (0.0 to 1.0)
      final double barHeight = size.height * normalizedHeight;
      
      // Center vertically
      final double top = (size.height - barHeight) / 2;
      
      // Position horizontally
      final double left = (i - startIndex) * (barWidth + spacing);

      final RRect rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, barHeight),
        const Radius.circular(2),
      );

      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant LiveWaveformPainter oldDelegate) {
    return true; // Always repaint when samples change
  }
}