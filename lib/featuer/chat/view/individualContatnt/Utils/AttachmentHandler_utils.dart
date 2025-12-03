import 'package:admin_app/featuer/chat/manager/message_cubit.dart';
import 'package:admin_app/featuer/chat/view/maps/view/map_picker_page.dart';
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

  AttachmentHandler({required this.chatId, required this.context});

  /// 📸 Pick Multiple Images from Gallery
  Future<void> pickImageFromGallery(BuildContext context) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(imageQuality: 80);

      if (images.isNotEmpty && context.mounted) {
        // Show loading indicator
        if (images.length > 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Sending ${images.length} images...')),
                ],
              ),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: images.length * 2),
            ),
          );
        }

        // Send each image through preview screen
        for (int i = 0; i < images.length; i++) {
          if (context.mounted) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewScreen(
                  imagePath: images[i].path,
                  imageNumber: images.length > 1 ? i + 1 : null,
                  totalImages: images.length > 1 ? images.length : null,
                ),
              ),
            );

            if (result != null && result is Map && context.mounted) {
              context.read<MessagesCubit>().sendImageMessage(
                chatId,
                result['imagePath'],
                result['caption'] ?? '',
              );
            } else {
              // User cancelled, stop sending remaining images
              break;
            }
          }
        }

        if (context.mounted && images.length > 1) {
          _showSuccessSnackBar(
            context,
            '${images.length} images sent successfully',
          );
        }
      }
    } catch (e) {
      _showErrorSnackBar(context, "Gallery Error: $e");
    }
  }

  /// 🎥 Pick Multiple Videos from Gallery
  Future<void> pickVideo(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty && context.mounted) {
        final videos = result.files.where((file) => file.path != null).toList();

        if (videos.isEmpty) return;

        // Show loading indicator for multiple videos
        if (videos.length > 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Sending ${videos.length} videos...')),
                ],
              ),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: videos.length * 3),
            ),
          );
        }

        // Send each video
        for (int i = 0; i < videos.length; i++) {
          if (context.mounted) {
            context.read<MessagesCubit>().sendVideoMessage(
              chatId,
              videos[i].path!,
              '',
            );
          }
        }

        if (context.mounted) {
          _showSuccessSnackBar(
            context,
            videos.length > 1
                ? '${videos.length} videos sent successfully'
                : 'Video sent successfully',
          );
        }
      }
    } catch (e) {
      _showErrorSnackBar(context, "Video Error: $e");
    }
  }

  /// 📄 Pick Multiple Documents
  Future<void> pickDocument(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final documents = result.files
            .where((file) => file.path != null)
            .toList();

        if (documents.isEmpty) return;

        // Show loading indicator for multiple documents
        if (documents.length > 1 && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Sending ${documents.length} documents...'),
                  ),
                ],
              ),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: documents.length * 2),
            ),
          );
        }

        // Send each document
        for (int i = 0; i < documents.length; i++) {
          if (context.mounted) {
            context.read<MessagesCubit>().sendDocumentMessage(
              chatId,
              documents[i].path!,
            );
          }
        }

        if (context.mounted) {
          _showSuccessSnackBar(
            context,
            documents.length > 1
                ? '${documents.length} documents sent successfully'
                : 'Document sent successfully',
          );
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
        MaterialPageRoute(builder: (context) => const MapPickerPage()),
      );

      if (result != null && result is Map && context.mounted) {
        final double lat = result['lat'];
        final double long = result['long'];

        context.read<MessagesCubit>().sendLocationMessage(chatId, lat, long);
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
            _showErrorSnackBar(context, "Selected contact has no phone number");
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
