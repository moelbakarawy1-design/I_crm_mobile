import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';
import 'package:admin_app/featuer/chat/view/Audio/message_content_helper.dart';
import 'package:admin_app/featuer/chat/view/maps/special_message_widgets.dart'; 
import 'package:admin_app/featuer/chat/view/video/widget/DocumentMessageWidget.dart';
import 'package:admin_app/featuer/chat/view/video/widget/VideoMessageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Helper: Smart URL Builder
String _getMediaUrl(String? content) {
  if (content == null || content.isEmpty) return '';
  if (content.startsWith('http') || content.startsWith('https')) {
    return content;
  }
  return '${EndPoints.baseUrl}/chats/media/$content';
}

Widget buildMessageContent(MessageData msg) {
  // Get Full URL
  final String fullUrl = _getMediaUrl(msg.content);
  
  // Smart Type Detection
  String type = (msg.type ?? '').toLowerCase();
  
  // Fallback detection
  if (type == 'text' || type.isEmpty) {
     final c = msg.content?.toLowerCase() ?? '';
     if (c.endsWith('.mp4') || c.endsWith('.mov') || c.endsWith('.avi') || c.endsWith('.mkv')) {
       type = 'video';
     } else if (c.endsWith('.jpg') || c.endsWith('.png') || c.endsWith('.jpeg')) {
       type = 'image';
     } else if (c.endsWith('.pdf') || c.endsWith('.doc') || c.endsWith('.docx')) {
       type = 'file';
     }
  }

 
  //  LOCATION (New)

  if (type == 'location') {
    return LocationMessageWidget(
      locationContent: msg.content ?? '', // Expecting "lat,long"
    );
  }
 
  //  VIDEO
 
  else if (type == 'video') {
    return VideoMessageWidget(
      videoUrl: fullUrl, 
      caption: msg.caption,
    );
  }
  // IMAGE
  else if (type == 'image') {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            fullUrl, 
            width: 200.w,
            height: 200.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.broken_image, color: Colors.grey),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 200.w,
                height: 200.h,
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
        if (msg.caption != null && msg.caption!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              msg.caption!,
              style: AppTextStyle.setpoppinsTextStyle(
                fontSize: 12, 
                color: AppColor.mainBlack, 
                fontWeight: FontWeight.w400
              ),
            ),
          ),
      ],
    );
  } 
  //   AUDIO
  else if (type == 'audio') {
    msg.content = fullUrl; 
    return AudioMessageWidget(message: msg); 
  } 
  //  FILE / DOCUMENT
  else if (type == 'file' || type == 'document') {
    return DocumentMessageWidget(
      fileName: "Document", 
      fileUrl: fullUrl, 
    );
  }
  //  TEXT (Default - No Linkify)
  else {
    return Text(
      msg.content ?? '',
      style: AppTextStyle.setpoppinsTextStyle(
        fontSize: 12, 
        fontWeight: FontWeight.w400, 
        color: AppColor.mainBlack
      ),
    );
  }
}