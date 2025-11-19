import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

// 🎥 Video Widget
class VideoMessageWidget extends StatefulWidget {
  final String videoUrl; // This will receive the ID (Content)
  final String? caption;

  const VideoMessageWidget({super.key, required this.videoUrl, this.caption});

  @override
  State<VideoMessageWidget> createState() => _VideoMessageWidgetState();
}

class _VideoMessageWidgetState extends State<VideoMessageWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // ✅ Construct the full URL by passing content at the end of endpoint
      String finalUrl;
      
      // Check if it's already a full link (starts with http/https)
      if (widget.videoUrl.startsWith('http') || widget.videoUrl.startsWith('https')) {
        finalUrl = widget.videoUrl;
      } else {
        // 🔥 THIS IS THE KEY PART YOU ASKED FOR:
        // Append the content (ID) to the end of the media endpoint
        finalUrl = '${EndPoints.baseUrl}/chats/media/${widget.videoUrl}';
      }

      debugPrint("🎥 Final Video URL: $finalUrl");

      // 2. Init Video Controller
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(finalUrl));
      await _videoPlayerController!.initialize();

      // 3. Init Chewie Controller
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: false,
        errorBuilder: (context, errorMessage) {
          return const Center(
            child: Icon(Icons.error, color: Colors.white),
          );
        },
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xff075E54),
          handleColor: Colors.white,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white38,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("❌ Error initializing video: $e");
      if (mounted) {
        setState(() => _isError = true);
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 250.w,
          height: 180.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _isError
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, color: Colors.white54, size: 30),
                        SizedBox(height: 5),
                        Text("Video Error", style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  )
                : _isInitialized
                    ? Chewie(controller: _chewieController!)
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
          ),
        ),
        if (widget.caption != null && widget.caption!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              widget.caption!,
              style: TextStyle(fontSize: 12.sp, color: Colors.black87),
            ),
          ),
      ],
    );
  }
}