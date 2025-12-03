import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';
import 'package:admin_app/featuer/chat/view/individualContatnt/widget/video_gallery_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

/// WhatsApp-style video album widget for grouped videos
class VideoAlbumWidget extends StatelessWidget {
  final List<OrderedMessages> videos;
  final bool isSentByMe;

  const VideoAlbumWidget({
    super.key,
    required this.videos,
    required this.isSentByMe,
  });

  void _openVideoGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VideoGalleryViewer(videos: videos, initialIndex: initialIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoCount = videos.length;

    return Container(
      constraints: BoxConstraints(maxWidth: 280.w, minWidth: 200.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.grey.shade200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: _buildVideoGrid(videoCount, context),
      ),
    );
  }

  Widget _buildVideoGrid(int count, BuildContext context) {
    if (count == 1) {
      return _buildSingleVideo(videos[0], context, 0);
    } else if (count == 2) {
      return _buildTwoVideos(context);
    } else if (count == 3) {
      return _buildThreeVideos(context);
    } else if (count == 4) {
      return _buildFourVideos(context);
    } else {
      return _buildFiveOrMoreVideos(context);
    }
  }

  Widget _buildSingleVideo(
    OrderedMessages video,
    BuildContext context,
    int index,
  ) {
    return GestureDetector(
      onTap: () => _openVideoGallery(context, index),
      child: _VideoThumbnail(
        videoUrl: video.content?.toString() ?? '',
        aspectRatio: 1.5,
      ),
    );
  }

  Widget _buildTwoVideos(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _openVideoGallery(context, 0),
            child: _VideoThumbnail(
              videoUrl: videos[0].content?.toString() ?? '',
              aspectRatio: 1.0,
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: GestureDetector(
            onTap: () => _openVideoGallery(context, 1),
            child: _VideoThumbnail(
              videoUrl: videos[1].content?.toString() ?? '',
              aspectRatio: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThreeVideos(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _openVideoGallery(context, 0),
                child: _VideoThumbnail(
                  videoUrl: videos[0].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _openVideoGallery(context, 1),
                child: _VideoThumbnail(
                  videoUrl: videos[1].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: () => _openVideoGallery(context, 2),
          child: _VideoThumbnail(
            videoUrl: videos[2].content?.toString() ?? '',
            aspectRatio: 2.0,
          ),
        ),
      ],
    );
  }

  Widget _buildFourVideos(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _openVideoGallery(context, 0),
                child: _VideoThumbnail(
                  videoUrl: videos[0].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _openVideoGallery(context, 1),
                child: _VideoThumbnail(
                  videoUrl: videos[1].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _openVideoGallery(context, 2),
                child: _VideoThumbnail(
                  videoUrl: videos[2].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _openVideoGallery(context, 3),
                child: _VideoThumbnail(
                  videoUrl: videos[3].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFiveOrMoreVideos(BuildContext context) {
    final remaining = videos.length - 3;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _openVideoGallery(context, 0),
                child: _VideoThumbnail(
                  videoUrl: videos[0].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _openVideoGallery(context, 1),
                child: _VideoThumbnail(
                  videoUrl: videos[1].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _openVideoGallery(context, 2),
                child: _VideoThumbnail(
                  videoUrl: videos[2].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _openVideoGallery(context, 3),
                child: Stack(
                  children: [
                    _VideoThumbnail(
                      videoUrl: videos[3].content?.toString() ?? '',
                      aspectRatio: 1.0,
                    ),
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                        child: Center(
                          child: Text(
                            '+$remaining',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Video thumbnail tile with play icon overlay
class _VideoThumbnail extends StatefulWidget {
  final String videoUrl;
  final double aspectRatio;

  const _VideoThumbnail({required this.videoUrl, required this.aspectRatio});

  @override
  State<_VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<_VideoThumbnail> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeThumbnail();
  }

  Future<void> _initializeThumbnail() async {
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
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
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
