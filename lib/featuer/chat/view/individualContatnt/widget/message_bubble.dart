import 'package:admin_app/featuer/chat/view/individualContatnt/widget/messaging%20_helper.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';
import 'package:admin_app/featuer/chat/view/individualContatnt/Utils/chat_utils.dart';


class MessageBubble extends StatelessWidget {
  final OrderedMessages msg;
  final bool isMe;

  const MessageBubble({super.key, required this.msg, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xffDCF8C6) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Sender Name
            Text(
              msg.from ?? (isMe ? "You" : "Customer"),
              style: AppTextStyle.setpoppinsTextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColor.secondaryBlack,
              ),
            ),
            const SizedBox(height: 3),
            
      
            buildMessageContent(msg, context),
            
            const SizedBox(height: 4),
            
            // Time & Status
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(
                  ChatUtils.formatTime(msg.timestamp),
                  style: AppTextStyle.setpoppinsTextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                    color: AppColor.gray70,
                  ),
                ),
                const SizedBox(width: 5),
                if (isMe && msg.status != null)
                  Text(
                    ChatUtils.getStatusText(msg.status!),
                    style: AppTextStyle.setpoppinsTextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                      color: ChatUtils.getStatusColor(msg.status!),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // 🗑️ DELETED local _buildContent to avoid duplication logic
}