import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';

class AudioMessageWidget extends StatefulWidget {
  final MessageData message;

  const AudioMessageWidget({super.key, required this.message});

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  final AudioPlayer _player = AudioPlayer();
  final PlayerController _waveController = PlayerController();

  bool _isPlaying = false;
  bool _isError = false;
  Duration _duration = Duration.zero;

  // Store subscriptions to cancel them on dispose
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    // The content might be either a full URL or just a file ID
    String content = widget.message.content ?? '';
    
    // Validate content is not empty
    if (content.isEmpty) {
      debugPrint("❌ Audio content is empty!");
      if (mounted) {
        setState(() => _isError = true);
      }
      return;
    }
    
    String url = content;
    
    // If content doesn't start with http, construct the URL
    if (!url.startsWith('http')) {
      url = "${EndPoints.baseUrl}/chats/media/$url";
    }
    
    debugPrint("📻 Loading audio from URL: $url");
    debugPrint("📝 Message content: ${widget.message.content}");
    debugPrint("📝 Message type: ${widget.message.type}");

    try {
      // Load audio into just_audio with HTTP URL
      await _player.setUrl(url);
      _duration = _player.duration ?? Duration.zero;
      
      debugPrint("✅ Audio loaded successfully. Duration: $_duration");

      // position stream - with null safety check and subscription management
      _positionSubscription = _player.positionStream.listen((p) {
        // Just update state for UI responsiveness
        if (mounted) {
          setState(() {});
        }
      });

      // handle completion - with null safety check and subscription management
      _playerStateSubscription = _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _player.seek(Duration.zero);
          _player.pause();
          _waveController.stopPlayer();
          if (mounted) {
            setState(() => _isPlaying = false);
          }
        }
      });
    } catch (e) {
      debugPrint("❌ AUDIO ERROR: $e");
      if (mounted) {
        setState(() => _isError = true);
      }
    }
  }

  @override
  void dispose() {
    // Cancel subscriptions to prevent setState() after dispose
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    
    _player.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF075E54),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                "Audio unavailable",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF075E54),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AVATAR
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            ),
            child: Center(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // PLAY BUTTON
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.25),
            ),
            child: GestureDetector(
              onTap: () async {
                if (!_isPlaying) {
                  _waveController.startPlayer();
                  await _player.play();
                } else {
                  _waveController.pausePlayer();
                  await _player.pause();
                }
                setState(() => _isPlaying = !_isPlaying);
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // WAVEFORM - Animated bars like the photo
          Expanded(
            child: SizedBox(
              height: 35,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    16,
                    (index) {
                      // Create varying heights for visual effect
                      double baseHeight = 5.0 + (index % 4) * 2.5;
                      
                      return Container(
                        width: 2.0,
                        height: _isPlaying 
                          ? baseHeight + 3.0  // Taller when playing
                          : baseHeight,
                        decoration: BoxDecoration(
                          color: _isPlaying 
                            ? Colors.white
                            : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // DURATION
          Text(
            _format(_duration),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes)}:${two(d.inSeconds % 60)}";
  }
}
