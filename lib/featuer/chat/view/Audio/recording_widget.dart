import 'package:admin_app/featuer/chat/view/chat_input_contant/chat_inputField_widget.dart';
import 'package:admin_app/featuer/chat/view/Audio/LiveWaveformPainter_helper.dart';
import 'package:flutter/material.dart';

class RecordingInterface extends StatefulWidget {
  final Duration duration;
  final List<double> samples; // Raw amplitude data
  final VoidCallback onCancel;
  final VoidCallback onSend;

  const RecordingInterface({
    super.key,
    required this.duration,
    required this.samples,
    required this.onCancel,
    required this.onSend,
  });

  @override
  State<RecordingInterface> createState() => _RecordingInterfaceState();
}

class _RecordingInterfaceState extends State<RecordingInterface> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Cancel Button
          GestureDetector(
            onTap: widget.onCancel,
            child: const CircleAvatar(
              backgroundColor: Color(0xFFFFCDD2),
              radius: 15,
              child: Icon(Icons.close, color: Color(0xFFD32F2F), size: 18),
            ),
          ),
          const SizedBox(width: 12),

          // Pulse Animation
          ScaleTransition(
            scale: Tween(begin: 1.0, end: 1.2).animate(_pulseController),
            child: const CircleAvatar(radius: 5, backgroundColor: kRecordingColor),
          ),
          const SizedBox(width: 8),

          // Timer
          Text(
            _formatDuration(widget.duration),
            style: const TextStyle(
              color: kRecordingColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),

          // Custom Waveform Painter
          Expanded(
            child: SizedBox(
              height: 30,
              child: CustomPaint(
                painter: LiveWaveformPainter(
                  samples: widget.samples, 
                  color: Colors.red.shade400
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Send Button
          GestureDetector(
            onTap: widget.onSend,
            child: const CircleAvatar(
              backgroundColor: Colors.green,
              radius: 18,
              child: Icon(Icons.check, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
