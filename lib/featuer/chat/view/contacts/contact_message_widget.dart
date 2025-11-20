import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactMessageWidget extends StatelessWidget {
  final String content; // This might be the JSON string

  const ContactMessageWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    // 1. Parse Data
    String displayName = "Unknown";
    String phoneNumber = "";

    try {
      // Handle case where content is a JSON list string
      // The backend sends: [{"name":{...}, "phones":[...]}]
      List<dynamic> contacts = [];
      if (content.startsWith('[')) {
        contacts = jsonDecode(content);
      } else {
        // Sometimes it might be wrapped or just a single object
        contacts = [jsonDecode(content)];
      }

      if (contacts.isNotEmpty) {
        final contact = contacts[0];
        displayName = contact['name']['formatted_name'] ?? "Unknown";
        final phones = contact['phones'] as List?;
        if (phones != null && phones.isNotEmpty) {
          phoneNumber = phones[0]['phone'] ?? "";
        }
      }
    } catch (e) {
      displayName = "Contact";
      phoneNumber = "Tap to view";
    }

    return Container(
      width: 230.w,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 18,
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  displayName,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 8.h),
          Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
          SizedBox(height: 8.h),

          // Action Button (Call / Save)
          GestureDetector(
            onTap: () async {
              final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
              if (await canLaunchUrl(launchUri)) {
                await launchUrl(launchUri);
              }
            },
            child: Center(
              child: Text(
                "Message", // Or "Call"
                style: TextStyle(
                    color: const Color(0xff075E54),
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp),
              ),
            ),
          )
        ],
      ),
    );
  }
}