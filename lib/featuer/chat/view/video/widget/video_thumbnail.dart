import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/core/utils/video_player_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

/// Video thumbnail tile with play icon overlay
class VideoThumbnail extends StatefulWidget {
  final String videoUrl;
  final double aspectRatio;

  const VideoThumbnail({
    super.key,
    required this.videoUrl,
    required this.aspectRatio,
  });

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasAcquiredSlot = false;

  @override
  void initState() {
    super.initState();
    _initializeThumbnail();
  }

  Future<void> _initializeThumbnail() async {
    // Try to acquire a slot from the manager
    if (!VideoPlayerManager().canAcquire()) {
      return; // Failed to acquire slot, stay in placeholder state
    }
    _hasAcquiredSlot = true;

    try {
      String finalUrl;
      if (widget.videoUrl.startsWith('http') ||
          widget.videoUrl.startsWith('https')) {
        finalUrl = widget.videoUrl;
      } else {
        finalUrl = '${EndPoints.baseUrl}/chats/media/${widget.videoUrl}';
      }

      _controller = VideoPlayerController.networkUrl(Uri.parse(finalUrl));
      await _controller!.initialize();
      // Seek to a very small position to ensure we have a frame, then pause
      await _controller!.seekTo(const Duration(milliseconds: 100));
      await _controller!.pause();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error loading thumbnail: $e");
      // If initialization fails, release the slot
      if (_hasAcquiredSlot) {
        VideoPlayerManager().release();
        _hasAcquiredSlot = false;
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    if (_hasAcquiredSlot) {
      VideoPlayerManager().release();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Thumbnail or Placeholder
          if (_isInitialized && _controller != null)
            VideoPlayer(_controller!)
          else
            Container(
              color: Colors.grey.shade300,
              child: Icon(
                Icons.videocam,
                color: Colors.grey.shade600,
                size: 40.sp,
              ),
            ),

          // Play button overlay
          Center(
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.play_arrow, color: Colors.white, size: 32.sp),
            ),
          ),
        ],
      ),
    );
  }
}
