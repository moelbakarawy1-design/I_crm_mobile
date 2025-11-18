import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';
import 'package:admin_app/featuer/chat/view/widgets/helper/message_content_helper.dart';
import 'package:flutter/material.dart';

Widget buildMessageContent(MessageData msg) {
  // Check if it's an audio message with valid content
  if (msg.type == "audio" && (msg.content?.isNotEmpty ?? false)) {
    return AudioMessageWidget(message: msg);
  }

  // Default text message (or empty audio message)
  return Text(
    msg.content ?? '',
    style: AppTextStyle.setpoppinsBlack(
        fontSize: 11, fontWeight: FontWeight.w400),
  );
}
