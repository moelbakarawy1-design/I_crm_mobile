import 'package:admin_app/featuer/chat/view/chat_input_contant/chat_inputField_widget.dart';
import 'package:flutter/material.dart';

class AnimatedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final int delay;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: clampedValue,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - clampedValue)),
            child: Opacity(
              opacity: clampedValue,
              child: IconButton(
                icon: Icon(icon, color: kPrimaryColor),
                onPressed: onPressed,
              ),
            ),
          ),
        );
      },
    );
  }
}