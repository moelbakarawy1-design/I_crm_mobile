import 'package:admin_app/featuer/chat/view/widgets/chat_inputField_widget.dart';
import 'package:flutter/material.dart';

class StandardInputInterface extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
          onPressed: () {}, 
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Type a message",
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        
        // Actions (Send or Record/Attach)
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, child) {
            final isTyping = value.text.trim().isNotEmpty;

            if (isTyping) {
              return IconButton(
                icon: const Icon(Icons.send, color: kPrimaryColor),
                onPressed: () {
                  onSendText(controller.text.trim());
                  controller.clear();
                },
              );
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onLongPress: onRecordStart,
                  onLongPressUp: onRecordEnd,
                  onTap: onRecordStart, // Optional: Tap to start recording toggle
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.mic, color: kPrimaryColor),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file, color: kPrimaryColor),
                  onPressed: onUploadFile,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: kPrimaryColor),
                  onPressed: onOpenCamera,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}