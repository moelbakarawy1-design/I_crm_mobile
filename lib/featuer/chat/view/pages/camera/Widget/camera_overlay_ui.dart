import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CameraOverlayUI extends StatelessWidget {
  final bool isTakingPicture;
  final Offset? focusPoint;
  final VoidCallback onClose;
  final VoidCallback onSwitchCamera;
  final VoidCallback onCapture;

  const CameraOverlayUI({
    super.key,
    required this.isTakingPicture,
    this.focusPoint,
    required this.onClose,
    required this.onSwitchCamera,
    required this.onCapture,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 🟡 Focus Indicator (مربع التركيز)
        if (focusPoint != null)
          Positioned(
            left: focusPoint!.dx - 20,
            top: focusPoint!.dy - 20,
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.yellow, width: 2),
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
          ),

        // 🎛️ Control Buttons
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white, size: 28.sp),
                      onPressed: onClose,
                    ),
                   
                  ],
                ),
              ),

              // Capture Button
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: GestureDetector(
                  onTap: onCapture,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isTakingPicture ? 80.r : 70.r,
                    height: isTakingPicture ? 80.r : 70.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 5.w),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}