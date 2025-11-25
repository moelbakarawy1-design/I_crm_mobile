import 'package:admin_app/featuer/chat/manager/message_cubit.dart';
import 'package:admin_app/featuer/chat/view/maps/map_picker_page.dart';
import 'package:admin_app/featuer/chat/view/pages/camera/view/PreviewScreen_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';

class AttachmentHandler {
  final String chatId;
  final BuildContext context;
  final ImagePicker _picker = ImagePicker();

  AttachmentHandler({
    required this.chatId,
    required this.context,
  });

  /// 📸 Pick Image from Gallery
  Future<void> pickImageFromGallery(BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null && context.mounted) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewScreen(imagePath: image.path),
          ),
        );

        if (result != null && result is Map && context.mounted) {
          context.read<MessagesCubit>().sendImageMessage(
                chatId,
                result['imagePath'],
                result['caption'] ?? '',
              );
        }
      }
    } catch (e) {
      _showErrorSnackBar(context, "Gallery Error: $e");
    }
  }

  /// 🎥 Pick Video from Gallery
  Future<void> pickVideo(BuildContext context) async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (video != null && context.mounted) {
        context.read<MessagesCubit>().sendVideoMessage(
              chatId,
              video.path,
              '',
            );
        _showSuccessSnackBar(context, "Video selected successfully");
      }
    } catch (e) {
      _showErrorSnackBar(context, "Video Error: $e");
    }
  }

  /// 📄 Pick Document
  Future<void> pickDocument(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null && result.files.single.path != null) {
        if (context.mounted) {
          context.read<MessagesCubit>().sendDocumentMessage(
                chatId,
                result.files.single.path!,
              );
          _showSuccessSnackBar(context, "Document selected successfully");
        }
      }
    } catch (e) {
      _showErrorSnackBar(context, "Document Error: $e");
    }
  }

  /// 📍 Pick Location
  Future<void> pickLocation(BuildContext context) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MapPickerPage(),
        ),
      );

      if (result != null && result is Map && context.mounted) {
        final double lat = result['lat'];
        final double long = result['long'];

        context.read<MessagesCubit>().sendLocationMessage(
              chatId,
              lat,
              long,
            );
        _showSuccessSnackBar(context, "Location shared successfully");
      }
    } catch (e) {
      _showErrorSnackBar(context, "Location Error: $e");
    }
  }

  /// 👤 Pick Contact
  Future<void> pickContact(BuildContext context) async {
    try {
      // Request Permission
      if (await FlutterContacts.requestPermission()) {
        // Open Native Contact Picker
        final Contact? contact = await FlutterContacts.openExternalPick();

        if (contact != null && context.mounted) {
          String name = contact.displayName;
          String phone = "";

          // Get Phone Number
          if (contact.phones.isNotEmpty) {
            phone = contact.phones.first.number;
          }

          if (phone.isNotEmpty) {
            context.read<MessagesCubit>().sendContactMessage(
                  chatId,
                  name,
                  phone,
                );
            _showSuccessSnackBar(context, "Contact shared: $name");
          } else {
            _showErrorSnackBar(
              context,
              "Selected contact has no phone number",
            );
          }
        }
      } else {
        _showErrorSnackBar(context, "Contact permission denied");
      }
    } catch (e) {
      _showErrorSnackBar(context, "Contact Error: $e");
    }
  }

  // Helper methods for SnackBars
  void _showErrorSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}