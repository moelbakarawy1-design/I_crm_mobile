import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentMessageWidget extends StatelessWidget {
  final String fileName;
  final String fileUrl;

  const DocumentMessageWidget({super.key, required this.fileName, required this.fileUrl});

  Future<void> _openDocument() async {
    final String fullUrl = fileUrl.startsWith('http') 
        ? fileUrl 
        : '${EndPoints.baseUrl}/chats/media/$fileUrl';

    final Uri uri = Uri.parse(fullUrl);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
         debugPrint("Could not launch $uri");
      }
    } catch (e) {
      debugPrint("Error launching url: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openDocument,
      child: Container(
        width: 220.w,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.insert_drive_file, color: Colors.red[400], size: 32),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName.split('/').last, 
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  Text(
                    "Click to open",
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}