import 'package:admin_app/featuer/chat/view/chat_input_contant/widgets/animated_action_buttons.dart';
import 'package:admin_app/featuer/chat/view/chat_input_contant/widgets/animated_emoji_button.dart';
import 'package:admin_app/featuer/chat/view/chat_input_contant/widgets/animated_send_button.dart';
import 'package:admin_app/featuer/chat/view/chat_input_contant/widgets/animated_text_field.dart';
import 'package:flutter/material.dart';

class StandardInputInterface extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSendText;
  final VoidCallback onRecordStart;
  final VoidCallback onRecordEnd;
  final VoidCallback onUploadFile;
  final VoidCallback onOpenCamera;

  const StandardInputInterface({
    super.key,
    required this.controller,
    required this.onSendText,
    required this.onRecordStart,
    required this.onRecordEnd,
    required this.onUploadFile,
    required this.onOpenCamera,
  });

  @override
  State<StandardInputInterface> createState() => _StandardInputInterfaceState();
}

class _StandardInputInterfaceState extends State<StandardInputInterface>
    with TickerProviderStateMixin {
  late AnimationController _sendButtonController;
  late AnimationController _actionsController;

  @override
  void initState() {
    super.initState();

    _sendButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _actionsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _actionsController.forward();
  }

  @override
  void dispose() {
    _sendButtonController.dispose();
    _actionsController.dispose();
    super.dispose();
  }

  void _onTextChanged(bool isTyping) {
    if (isTyping) {
      _actionsController.reverse();
      _sendButtonController.forward();
    } else {
      _sendButtonController.reverse();
      _actionsController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AnimatedEmojiButton(),
        AnimatedTextField(controller: widget.controller),
        const SizedBox(width: 6),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: widget.controller,
          builder: (context, value, child) {
            final isTyping = value.text.trim().isNotEmpty;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _onTextChanged(isTyping);
            });

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: isTyping
                  ? AnimatedSendButton(
                      key: const ValueKey('send'),
                      controller: _sendButtonController,
                      onSend: () {
                        widget.onSendText(widget.controller.text.trim());
                        widget.controller.clear();
                      },
                    )
                  : AnimatedActionButtons(
                      key: const ValueKey('actions'),
                      controller: _actionsController,
                      onRecordStart: widget.onRecordStart,
                      onRecordEnd: widget.onRecordEnd,
                      onUploadFile: widget.onUploadFile,
                      onOpenCamera: widget.onOpenCamera,
                    ),
            );
          },
        ),
      ],
    );
  }
}