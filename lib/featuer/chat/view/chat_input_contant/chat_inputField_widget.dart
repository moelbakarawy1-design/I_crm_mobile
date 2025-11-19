import 'dart:async';
import 'dart:io';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/featuer/chat/view/Audio/recording_widget.dart';
import 'package:admin_app/featuer/chat/view/chat_input_contant/standeredInput_widget.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart'; 

//  Constants
const Color kPrimaryColor = Color(0xff075E54);
const Color kRecordingColor = AppColor.mainBlue;

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
  final AudioRecorder _audioRecorder = AudioRecorder(); 
  
  bool _isRecording = false;
  Timer? _timer;
  Duration _recordingDuration = Duration.zero;
  // Waveform Data
  List<double> _amplitudeSamples = [];
  StreamSubscription<Amplitude>? _amplitudeSub;

  @override
  void dispose() {
    _textController.dispose();
    _audioRecorder.dispose();
    _timer?.cancel();
    _amplitudeSub?.cancel();
    super.dispose();
  }

  //  Recording Logic

  Future<void> _startRecording() async {
    try {
      if (!await _audioRecorder.hasPermission()) {
        debugPrint("❌ Microphone permission denied");
        return;
      }

      final dir = await getTemporaryDirectory();
      final path = "${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav";
      const config = RecordConfig(
        encoder: AudioEncoder.wav, 
        sampleRate: 44100,
        numChannels: 1,
      );

     
      await _audioRecorder.start(config, path: path);

      setState(() {
        _isRecording = true;
        _recordingDuration = Duration.zero;
        _amplitudeSamples = []; 
      });

      _startTimer();
      _startAmplitudeListener();

    } catch (e) {
      debugPrint('❌ Recording error: $e');
      setState(() => _isRecording = false);
    }
  }

  Future<void> _stopRecording({bool isCancelled = false}) async {
    _timer?.cancel();
    _amplitudeSub?.cancel();

    final path = await _audioRecorder.stop();

    if (isCancelled) {
      if (path != null) File(path).delete().ignore();
      debugPrint("🗑️ Recording cancelled");
    } else if (path != null) {
      debugPrint("✅ WAV Recording saved: $path");
      widget.onSendAudio(path);
    }

    setState(() => _isRecording = false);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      setState(() {
        _recordingDuration += const Duration(seconds: 1);
      });
    });
  }

  void _startAmplitudeListener() {
    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 50))
        .listen((amp) {
      setState(() {
        double normalized = (amp.current + 50) / 50;
        normalized = normalized.clamp(0.1, 1.0);        
        _amplitudeSamples.add(normalized);
        if (_amplitudeSamples.length > 40) {
          _amplitudeSamples.removeAt(0);
        }
      });
    });
  }

  //  Main Build
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
                  samples: _amplitudeSamples,
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