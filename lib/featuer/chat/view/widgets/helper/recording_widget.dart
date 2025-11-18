import 'package:admin_app/featuer/chat/view/widgets/chat_inputField_widget.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class RecordingInterface extends StatefulWidget {
  final Duration duration;
  final RecorderController waveController;
  final VoidCallback onCancel;
  final VoidCallback onSend;

  const RecordingInterface({
    super.key,
    required this.duration,
    required this.waveController,
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
              backgroundColor: Color(0xFFFFCDD2), // Red[100]
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

          // Waveform
          Expanded(
            child: AudioWaveforms(
              enableGesture: false,
              size: const Size(double.infinity, 30),
              recorderController: widget.waveController,
              waveStyle: WaveStyle(
                waveColor: Colors.red.shade400,
                extendWaveform: true,
                spacing: 4.0,
                showMiddleLine: false,
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