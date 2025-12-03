import 'dart:io';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviewScreen extends StatefulWidget {
  final String imagePath;
  final int? imageNumber;
  final int? totalImages;

  const PreviewScreen({
    super.key,
    required this.imagePath,
    this.imageNumber,
    this.totalImages,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _sendImage() {
    final String caption = _captionController.text.trim();
    Navigator.of(
      context,
    ).pop({'imagePath': widget.imagePath, 'caption': caption});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white, size: 28.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: widget.imageNumber != null && widget.totalImages != null
            ? Text(
                'Image ${widget.imageNumber} of ${widget.totalImages}',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              )
            : null,
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Image.file(File(widget.imagePath), fit: BoxFit.contain),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: TextField(
                        controller: _captionController,
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: 'Add a caption...',
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 14.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  FloatingActionButton(
                    backgroundColor: AppColor.lightBlue,
                    onPressed: _sendImage, // Calls the function above
                    child: Icon(Icons.send, color: AppColor.mainWhite),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
