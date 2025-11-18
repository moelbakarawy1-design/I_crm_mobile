import 'dart:async';
import 'dart:io';
import 'package:admin_app/featuer/chat/view/widgets/helper/recording_widget.dart';
import 'package:admin_app/featuer/chat/view/widgets/helper/standeredInput_widget.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';

// --- Constants ---
const Color kPrimaryColor = Color(0xff075E54);
const Color kRecordingColor = Colors.red;

class ChatInputField extends StatefulWidget {
  final Function(String text) onSendText;
  final Function(String filePath) onSendAudio;
  final VoidCallback onUploadFile;
  final VoidCallback onOpenCamera;

  const ChatInputField({
    super.key,
    required this.onSendText,
    required this.onSendAudio,
    required this.onUploadFile,
    required this.onOpenCamera,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> with TickerProviderStateMixin {
  // Logic & State
  final TextEditingController _textController = TextEditingController();
  final RecorderController _waveController = RecorderController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  
  bool _isRecording = false;
  Timer? _durationTimer;
  Duration _recordingDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  void _initializeRecorder() {
    _waveController
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..sampleRate = 16000;
  }

  @override
  void dispose() {
    _textController.dispose();
    _waveController.dispose();
    _durationTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  // --- Recording Logic ---

  Future<void> _startRecording() async {
    if (!await _audioRecorder.hasPermission()) return;

    final dir = await getTemporaryDirectory();
    final path = "${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav";

    try {
      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.wav, sampleRate: 44100),
        path: path,
      );

      // UI Updates
      _waveController.record();
      setState(() {
        _isRecording = true;
        _recordingDuration = Duration.zero;
      });

      _startTimer();
    } catch (e) {
      debugPrint('❌ Recording error: $e');
    }
  }

  Future<void> _stopRecording({bool isCancelled = false}) async {
    _durationTimer?.cancel();
    final path = await _audioRecorder.stop();
    _waveController.refresh(); // Stop waveform

    if (isCancelled) {
      if (path != null) File(path).delete().ignore();
    } else if (path != null) {
      widget.onSendAudio(path);
    }

    setState(() => _isRecording = false);
  }

  void _startTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        _recordingDuration += const Duration(milliseconds: 100);
      });
    });
  }

  // --- Main Build ---

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.white,
      child: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isRecording
              ? RecordingInterface(
                  duration: _recordingDuration,
                  waveController: _waveController,
                  onCancel: () => _stopRecording(isCancelled: true),
                  onSend: () => _stopRecording(isCancelled: false),
                )
              : StandardInputInterface(
                  controller: _textController,
                  onSendText: widget.onSendText,
                  onRecordStart: _startRecording,
                  onRecordEnd: () => _stopRecording(isCancelled: false),
                  onUploadFile: widget.onUploadFile,
                  onOpenCamera: widget.onOpenCamera,
                ),
        ),
      ),
    );
  }
}