import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';
import 'package:admin_app/featuer/chat/view/video/widget/video_gallery_viewer.dart';
import 'package:admin_app/featuer/chat/view/video/widget/video_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      child: VideoThumbnail(
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
            child: VideoThumbnail(
              videoUrl: videos[0].content?.toString() ?? '',
              aspectRatio: 1.0,
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: GestureDetector(
            onTap: () => _openVideoGallery(context, 1),
            child: VideoThumbnail(
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
                child: VideoThumbnail(
                  videoUrl: videos[0].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _openVideoGallery(context, 1),
                child: VideoThumbnail(
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
          child: VideoThumbnail(
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
                child: VideoThumbnail(
                  videoUrl: videos[0].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _openVideoGallery(context, 1),
                child: VideoThumbnail(
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
                child: VideoThumbnail(
                  videoUrl: videos[2].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _openVideoGallery(context, 3),
                child: VideoThumbnail(
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
                child: VideoThumbnail(
                  videoUrl: videos[0].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _openVideoGallery(context, 1),
                child: VideoThumbnail(
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
                child: VideoThumbnail(
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
                    VideoThumbnail(
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
