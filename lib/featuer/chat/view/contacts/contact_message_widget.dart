import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactMessageWidget extends StatelessWidget {
  final String content;

  const ContactMessageWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    // --- 1. Parsing Logic (Kept Safe) ---
    String displayName = "Unknown";
    String phoneNumber = "";
    String initials = "";

    try {
      List<dynamic> contacts = [];
      if (content.startsWith('[')) {
        contacts = jsonDecode(content);
      } else {
        contacts = [jsonDecode(content)];
      }

      if (contacts.isNotEmpty) {
        final contact = contacts[0];
        displayName = contact['name']['formatted_name'] ?? "Unknown";
        
        // Generate Initials (e.g., "Ahmed Ayman" -> "AA")
        if (displayName != "Unknown" && displayName.isNotEmpty) {
           List<String> names = displayName.trim().split(" ");
           if (names.length >= 2) {
             initials = "${names[0][0]}${names[1][0]}".toUpperCase();
           } else if (names.isNotEmpty) {
             initials = names[0][0].toUpperCase();
           }
        }

        final phones = contact['phones'] as List?;
        if (phones != null && phones.isNotEmpty) {
          phoneNumber = phones[0]['phone'] ?? "";
        }
      }
    } catch (e) {
      displayName = "Contact";
      phoneNumber = "";
    }

    // --- 2. Modern UI Design ---
    return Container(
      width: 260.w, // Slightly wider for better breathing room
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white, // Clean white card
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Section: Info
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Modern Avatar
                Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFCFD8DC), Color(0xFFB0BEC5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: initials.isNotEmpty
                        ? Text(
                            initials,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Icon(Icons.person, color: Colors.white, size: 24.sp),
                  ),
                ),
                SizedBox(width: 12.w),
                // Text Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        displayName,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF202020),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (phoneNumber.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          phoneNumber,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider (Subtle)
          Divider(height: 1, color: Colors.grey.withOpacity(0.15)),

          // Bottom Section: Action Button
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.r),
              bottomRight: Radius.circular(16.r),
            ),
            child: InkWell(
              onTap: () async {
                if (phoneNumber.isNotEmpty) {
                  // Changed 'tel' logic to match "Call" label. 
                  // Use 'sms' if you want to message.
                  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
                  if (await canLaunchUrl(launchUri)) {
                    await launchUrl(launchUri);
                  }
                }
              },
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                alignment: Alignment.center,
                child: Text(
                  "Call Contact", // Explicit Action
                  style: TextStyle(
                    color: const Color(0xFF075E54), // WhatsApp Teal
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}