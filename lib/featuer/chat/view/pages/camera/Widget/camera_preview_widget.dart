import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FullScreenCameraPreview extends StatelessWidget {
  final CameraController controller;

  const FullScreenCameraPreview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return  Container();
    }

    final size = MediaQuery.of(context).size;
    
    // 🔥 LOGIC TO MAKE IT FULL SCREEN
    // نقوم بحساب معامل التكبير لتغطية الشاشة بالكامل
    var scale = size.aspectRatio * controller.value.aspectRatio;

    // إذا كان المقياس أقل من 1، نقلبه لضمان التغطية
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(controller),
      ),
    );
  }
}