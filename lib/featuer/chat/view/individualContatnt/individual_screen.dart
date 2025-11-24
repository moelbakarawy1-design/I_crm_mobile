import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/chat/data/model/chat_model12.dart';
import 'package:admin_app/featuer/chat/data/repo/MessagesRepository.dart';
import 'package:admin_app/featuer/chat/manager/message_cubit.dart';
import 'package:admin_app/featuer/chat/service/Socetserver.dart';
import 'package:admin_app/featuer/chat/view/individualContatnt/widget/chat_messages_list.dart';
import 'package:admin_app/featuer/chat/view/maps/map_picker_page.dart';
import 'package:admin_app/featuer/chat/view/pages/camera/view/PreviewScreen_page.dart';
import 'package:admin_app/featuer/chat/view/chat_input_contant/chat_inputField_widget.dart';
import 'package:admin_app/featuer/chat/view/widgets/Assign_user_rename_user.dart/chat_actions_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class IndividualScreen extends StatefulWidget {
  final Data chatModel;
  const IndividualScreen({super.key, required this.chatModel});

  @override
  State<IndividualScreen> createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> {
  final ImagePicker _picker = ImagePicker();

  // 📸 Pick Image
  Future<void> _pickImageFromGallery(BuildContext context) async {
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
            widget.chatModel.id ?? '', 
            result['imagePath'], 
            result['caption'] ?? ''
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gallery Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  // 📍 Pick Location
  Future<void> _pickLocation(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerPage()),
    );

    // Get Result and Send
    if (result != null && result is Map && context.mounted) {
      final double lat = result['lat'];
      final double long = result['long'];

      // Call Cubit
      context.read<MessagesCubit>().sendLocationMessage(
        widget.chatModel.id ?? '', 
        lat, 
        long
      );
    }
  }

  // 📄 Pick Document
  Future<void> _pickDocument(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null && result.files.single.path != null) {
        if (context.mounted) {
          context.read<MessagesCubit>().sendDocumentMessage(
            widget.chatModel.id ?? '', 
            result.files.single.path!
          );
        }
      }
    } catch (e) {
      print("Error picking doc: $e");
    }
  }

  // 🎥 Pick Video
  Future<void> _pickVideo(BuildContext context) async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null && context.mounted) {
        context.read<MessagesCubit>().sendVideoMessage(
          widget.chatModel.id ?? '', 
          video.path, 
          '' 
        );
      }
    } catch (e) {
      print("Error picking video: $e");
    }
  }

  // 👤 ✅ Pick Contact (New Feature)
   Future<void> _pickContact(BuildContext context) async {
    try {
      // 1. Check Permission
      if (await FlutterContacts.requestPermission()) {
        
        // 2. Open Native Picker
        // This function opens the native contact list and returns the selected contact
        final Contact? contact = await FlutterContacts.openExternalPick();

        if (contact != null && context.mounted) {
          String name = contact.displayName;
          String phone = "";

          // 3. Get Phone Number
          if (contact.phones.isNotEmpty) {
            phone = contact.phones.first.number;
          }

          if (phone.isNotEmpty) {
             print("👤 Selected: $name - $phone");
             
             // 4. Send
             context.read<MessagesCubit>().sendContactMessage(
               widget.chatModel.id ?? '', 
               name, 
               phone
             );
          } else {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text("Selected contact has no phone number")),
             );
          }
        }
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text("Permission denied")),
         );
      }
    } catch (e) {
      print("❌ Error picking contact: $e");
    }
  }
  
  // 🛠️ Show Attachment Options (Bottom Sheet)
  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        // Use Wrap to handle multiple rows gracefully
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          runSpacing: 20,
          spacing: 20,
          children: [
            _optionItem(Icons.image, Colors.purple, "Gallery", () {
              Navigator.pop(ctx);
              _pickImageFromGallery(context);
            }),
            _optionItem(Icons.videocam, Colors.pink, "Video", () {
              Navigator.pop(ctx);
              _pickVideo(context);
            }),
            _optionItem(Icons.insert_drive_file, Colors.blue, "Document", () {
              Navigator.pop(ctx);
              _pickDocument(context);
            }),
            _optionItem(Icons.location_on, Colors.green, "Location", () {
              Navigator.pop(ctx);
              _pickLocation(context);
            }),
            //  Added Contact Option
            _optionItem(Icons.person, Colors.blueAccent, "Contact", () {
              Navigator.pop(ctx);
              _pickContact(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _optionItem(IconData icon, Color color, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
       create:(context) => MessagesCubit(
        MessagesRepository(), 
        SocketService() 
      )..getMessages(widget.chatModel.id ?? ''),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xffECE5DD),
            appBar: _buildAppBar(context),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  // 1. Message List
                  const Expanded(
                    child: ChatMessagesList(),
                  ),
                  
                  // 2. Input Field
                  ChatInputField(
                    onSendText: (msg) => context.read<MessagesCubit>()
                        .sendMessage(widget.chatModel.id ?? '', msg),
                    onSendAudio: (path) => context.read<MessagesCubit>()
                        .sendAudioMessage(widget.chatModel.id ?? '', path),
                    onUploadFile: () => _showAttachmentOptions(context),
                    onOpenCamera: () async {
                      final result = await Navigator.pushNamed(context, Routes.cameraPage);
                      if (result != null && result is Map && context.mounted) {
                        context.read<MessagesCubit>().sendImageMessage(
                          widget.chatModel.id ?? '', 
                          result['imagePath'], 
                          result['caption'] ?? ''
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.lightBlue,
      actions: [
        IconButton(
          onPressed: (){ChatOptionsHelper.showOptionsSheet(context, widget.chatModel.id ?? '');} ,
          icon: SvgPicture.asset(
            'assets/svg/setting-2.svg',
            width: 30.w, height: 30.h, fit: BoxFit.scaleDown, color: AppColor.mainWhite,
          ),
        )
      ],
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
      title: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: Icon(Icons.person, color: Colors.grey),
          ),
          const SizedBox(width: 10),
          Text(
            widget.chatModel.customer?.name ?? 'Chat',
            style: AppTextStyle.setpoppinsWhite(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}