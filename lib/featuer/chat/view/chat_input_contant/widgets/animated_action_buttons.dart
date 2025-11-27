import 'package:admin_app/featuer/chat/view/chat_input_contant/widgets/animated_mic_button.dart';
import 'package:admin_app/featuer/chat/view/chat_input_contant/widgets/animated_icon_button.dart';
import 'package:flutter/material.dart';

class AnimatedActionButtons extends StatelessWidget {
  final AnimationController controller;
  final VoidCallback onRecordStart;
  final VoidCallback onRecordEnd;
  final VoidCallback onUploadFile;
  final VoidCallback onOpenCamera;

  const AnimatedActionButtons({
    super.key,
    required this.controller,
    required this.onRecordStart,
    required this.onRecordEnd,
    required this.onUploadFile,
    required this.onOpenCamera,
  });

  @override
  Widget build(BuildContext context) {
    final scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.elasticOut),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedMicButton(
                onRecordStart: onRecordStart,
                onRecordEnd: onRecordEnd,
              ),
              AnimatedIconButton(
                icon: Icons.attach_file,
                onPressed: onUploadFile,
                delay: 50,
              ),
              AnimatedIconButton(
                icon: Icons.camera_alt,
                onPressed: onOpenCamera,
                delay: 100,
              ),
            ],
          ),
        );
      },
    );
  }
}