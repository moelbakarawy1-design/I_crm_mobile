import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';
import 'package:admin_app/featuer/chat/view/image/widget/image_gallery_viewer.dart';
import 'package:admin_app/featuer/chat/view/image/widget/image_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// WhatsApp-style image album widget for grouped images
class ImageAlbumWidget extends StatelessWidget {
  final List<OrderedMessages> images;
  final bool isSentByMe;

  const ImageAlbumWidget({
    super.key,
    required this.images,
    required this.isSentByMe,
  });

  void _openGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ImageGalleryViewer(images: images, initialIndex: initialIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageCount = images.length;

    return Container(
      constraints: BoxConstraints(maxWidth: 280.w, minWidth: 200.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.grey.shade200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: _buildImageGrid(imageCount, context),
      ),
    );
  }

  Widget _buildImageGrid(int count, BuildContext context) {
    if (count == 1) {
      return _buildSingleImage(images[0], context, 0);
    } else if (count == 2) {
      return _buildTwoImages(context);
    } else if (count == 3) {
      return _buildThreeImages(context);
    } else if (count == 4) {
      return _buildFourImages(context);
    } else {
      return _buildFiveOrMoreImages(context);
    }
  }

  /// Single image
  Widget _buildSingleImage(
    OrderedMessages image,
    BuildContext context,
    int index,
  ) {
    return GestureDetector(
      onTap: () => _openGallery(context, index),
      child: ImageTile(
        imageUrl: image.content?.toString() ?? '',
        aspectRatio: 1.5,
      ),
    );
  }

  /// Two images side by side
  Widget _buildTwoImages(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _openGallery(context, 0),
            child: ImageTile(
              imageUrl: images[0].content?.toString() ?? '',
              aspectRatio: 1.0,
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: GestureDetector(
            onTap: () => _openGallery(context, 1),
            child: ImageTile(
              imageUrl: images[1].content?.toString() ?? '',
              aspectRatio: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  /// Three images: 2 on top, 1 on bottom
  Widget _buildThreeImages(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _openGallery(context, 0),
                child: ImageTile(
                  imageUrl: images[0].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _openGallery(context, 1),
                child: ImageTile(
                  imageUrl: images[1].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: () => _openGallery(context, 2),
          child: ImageTile(
            imageUrl: images[2].content?.toString() ?? '',
            aspectRatio: 2.0,
          ),
        ),
      ],
    );
  }

  /// Four images: 2x2 grid
  Widget _buildFourImages(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _openGallery(context, 0),
                child: ImageTile(
                  imageUrl: images[0].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _openGallery(context, 1),
                child: ImageTile(
                  imageUrl: images[1].content?.toString() ?? '',
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
                onTap: () => _openGallery(context, 2),
                child: ImageTile(
                  imageUrl: images[2].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _openGallery(context, 3),
                child: ImageTile(
                  imageUrl: images[3].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Five or more images: 2x2 grid with "+X more" overlay
  Widget _buildFiveOrMoreImages(BuildContext context) {
    final remaining = images.length - 3;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _openGallery(context, 0),
                child: ImageTile(
                  imageUrl: images[0].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _openGallery(context, 1),
                child: ImageTile(
                  imageUrl: images[1].content?.toString() ?? '',
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
                onTap: () => _openGallery(context, 2),
                child: ImageTile(
                  imageUrl: images[2].content?.toString() ?? '',
                  aspectRatio: 1.0,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _openGallery(context, 3),
                child: Stack(
                  children: [
                    ImageTile(
                      imageUrl: images[3].content?.toString() ?? '',
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
