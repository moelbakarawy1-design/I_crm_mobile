import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentMessageWidget extends StatelessWidget {
  final String fileName;
  final String fileUrl;

  const DocumentMessageWidget({
    super.key, 
    required this.fileName, 
    required this.fileUrl
  });

  // 🎨 Helper: Get Color based on extension
  Color _getFileColor(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf': return const Color(0xFFE57373); // Red
      case 'doc':
      case 'docx': return const Color(0xFF64B5F6); // Blue
      case 'xls':
      case 'xlsx': return const Color(0xFF81C784); // Green
      case 'jpg':
      case 'png':
      case 'jpeg': return const Color(0xFFBA68C8); // Purple
      default: return const Color(0xFF90A4AE); // Grey
    }
  }

  // 📂 Helper: Get Icon based on extension
  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf': return Icons.picture_as_pdf_rounded;
      case 'doc':
      case 'docx': return Icons.description_rounded;
      case 'xls':
      case 'xlsx': return Icons.table_chart_rounded;
      case 'jpg':
      case 'png': return Icons.image_rounded;
      default: return Icons.insert_drive_file_rounded;
    }
  }

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
    final extension = fileName.split('.').last;
    final themeColor = _getFileColor(extension);

    return Container(
      width: 260.w, // Slightly wider for better breathing room
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r), // Softer corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openDocument,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                // 1. Modern Icon Container
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1), // Light background
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Icon(
                      _getFileIcon(extension),
                      color: themeColor,
                      size: 24.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // 2. File Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        fileName.split('/').last,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D3436),
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "${extension.toUpperCase()} File • Tap to view",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Action Icon (Chevron or Download)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.sp,
                  color: Colors.grey.shade300,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}