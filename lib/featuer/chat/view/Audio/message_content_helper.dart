import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';

class AudioMessageWidget extends StatefulWidget {
  final OrderedMessages message;

  const AudioMessageWidget({super.key, required this.message});

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget>
    with AutomaticKeepAliveClientMixin {
  final AudioPlayer _player = AudioPlayer();

  bool _isPlaying = false;
  bool _isLoading = true;
  bool _fileReady = false;
  String? _localPath;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  bool get wantKeepAlive => true; // Keeps widget alive during scroll

  @override
  void initState() {
    super.initState();
    _prepareAudio();
    _setupListeners();
  }

  void _setupListeners() {
    // 1. Listen to playback state (Playing/Paused/Completed)
    _player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          if (state.processingState == ProcessingState.completed) {
            _isPlaying = false;
            _player.seek(Duration.zero);
            _player.pause();
          }
        });
      }
    });

    // 2. Listen to current position for Slider
    _player.positionStream.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    // 3. Listen to total duration
    _player.durationStream.listen((d) {
      if (d != null && mounted) setState(() => _duration = d);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _prepareAudio() async {
    try {
      String content = widget.message.content ?? '';
      if (content.isEmpty) return;

      // استخدام الرابط المباشر من content
      String url = content;

      // 1. Download/Check Cache
      final file = await _downloadFile(url);

      if (file == null || !mounted) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      _localPath = file.path;

      // 2. Set file to player
      await _player.setFilePath(_localPath!);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _fileReady = true;
        });
      }
    } catch (e) {
      debugPrint("❌ Error loading audio: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<File?> _downloadFile(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final fileName = url.split('/').last;
      final file = File('${dir.path}/$fileName');

      if (await file.exists()) {
        return file;
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return file.writeAsBytes(response.bodyBytes);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _togglePlay() async {
    if (_isLoading || !_fileReady) return;

    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    const backgroundColor = Color(0xFF075E54);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Center(
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),

          const SizedBox(width: 8),

          // Play Button
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.25),
              ),
              child: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
            ),
          ),

          // Slider
          if (_fileReady)
            Expanded(
              child: SizedBox(
                height: 30,
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 14,
                    ),
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white.withOpacity(0.3),
                    thumbColor: Colors.white,
                  ),
                  child: Slider(
                    value: _position.inMilliseconds.toDouble().clamp(
                      0.0,
                      _duration.inMilliseconds.toDouble(),
                    ),
                    max: _duration.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      _player.seek(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: LinearProgressIndicator(
                  color: Colors.white.withOpacity(0.3),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),

          // Duration Text
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 4),
            child: Text(
              _formatDuration(_position.inSeconds > 0 ? _position : _duration),
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes)}:${two(d.inSeconds % 60)}";
  }
}
