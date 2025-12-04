import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import 'package:admin_app/featuer/chat/view/video/widget/video_player_control_widget.dart';

/// Fullscreen video gallery viewer for albums
class VideoGalleryViewer extends StatefulWidget {
  final List<OrderedMessages> videos;
  final int initialIndex;

  const VideoGalleryViewer({
    super.key,
    required this.videos,
    this.initialIndex = 0,
  });

  @override
  State<VideoGalleryViewer> createState() => _VideoGalleryViewerState();
}

class _VideoGalleryViewerState extends State<VideoGalleryViewer> {
  late PageController _pageController;
  late int _currentIndex;
  VideoPlayerController? _currentVideoController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _initializeVideoPlayer(_currentIndex);
  }

  void _initializeVideoPlayer(int index) {
    _currentVideoController?.dispose();

    final videoUrl = widget.videos[index].content?.toString() ?? '';
    _currentVideoController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl))
          ..initialize().then((_) {
            if (mounted) {
              setState(() {});
              _currentVideoController?.play();
            }
          });
  }

  @override
  void dispose() {
    _currentVideoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _initializeVideoPlayer(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white, size: 28.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_currentIndex + 1} / ${widget.videos.length}',
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.videos.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          if (index == _currentIndex && _currentVideoController != null) {
            return VideoPlayerControlWidget(
              controller: _currentVideoController!,
            );
          }

          // Placeholder for non-current videos
          return Center(child: CircularProgressIndicator(color: Colors.white));
        },
      ),
      bottomNavigationBar: widget.videos.length > 1
          ? Container(
              color: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.videos.length > 5 ? 5 : widget.videos.length,
                  (index) {
                    if (widget.videos.length > 5 && index == 4) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          '...',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 16.sp,
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.white38,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : null,
    );
  }
}
