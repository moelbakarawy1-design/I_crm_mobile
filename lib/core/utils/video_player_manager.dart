import 'package:flutter/foundation.dart';

/// Singleton manager to limit the number of concurrent video players
/// to prevent "MediaCodecVideoRenderer error" on Android.
class VideoPlayerManager {
  static final VideoPlayerManager _instance = VideoPlayerManager._internal();

  factory VideoPlayerManager() {
    return _instance;
  }

  VideoPlayerManager._internal();

  // Conservative limit. Most devices support 4-6 hardware decoders.
  // We keep it low to be safe, leaving room for a full-screen player.
  static const int _maxConcurrentPlayers = 3;
  int _activePlayers = 0;

  /// Try to acquire a slot for a video player.
  /// Returns true if a slot was acquired, false otherwise.
  bool canAcquire() {
    if (_activePlayers < _maxConcurrentPlayers) {
      _activePlayers++;
      debugPrint('VideoPlayerManager: Slot acquired. Active: $_activePlayers');
      return true;
    }
    debugPrint('VideoPlayerManager: Slot denied. Active: $_activePlayers');
    return false;
  }

  /// Release a slot.
  void release() {
    if (_activePlayers > 0) {
      _activePlayers--;
      debugPrint('VideoPlayerManager: Slot released. Active: $_activePlayers');
    }
  }
}
