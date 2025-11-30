import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/featuer/chat/data/model/chat_model12.dart';
import 'package:admin_app/featuer/chat/data/repo/MessagesRepository.dart';
import 'package:admin_app/featuer/chat/manager/message_cubit.dart';
import 'package:admin_app/featuer/chat/service/Socetserver.dart';
import 'package:admin_app/featuer/chat/view/individualContatnt/Utils/AttachmentHandler_utils.dart';
import 'package:admin_app/featuer/chat/view/individualContatnt/widget/ChatAppBar%20_widget.dart';
import 'package:admin_app/featuer/chat/view/individualContatnt/widget/chat_messages_list.dart';
import 'package:admin_app/featuer/chat/view/chat_input_contant/chat_inputField_widget.dart';
import 'package:admin_app/featuer/chat/view/individualContatnt/widget/showAttachmentBottomSheet.dart';
import 'package:admin_app/core/helper/enum_permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Assuming you use ScreenUtil

class IndividualScreen extends StatefulWidget {
  final Data chatModel;
  const IndividualScreen({super.key, required this.chatModel});

  @override
  State<IndividualScreen> createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AttachmentHandler _attachmentHandler;

  @override
  void initState() {
    super.initState();
    _attachmentHandler = AttachmentHandler(
      chatId: widget.chatModel.id ?? '',
      context: context,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _showAttachmentOptions() {
    showAttachmentBottomSheet(
      context: context,
      onImagePick: () => _attachmentHandler.pickImageFromGallery(context),
      onVideoPick: () => _attachmentHandler.pickVideo(context),
      onDocumentPick: () => _attachmentHandler.pickDocument(context),
      onLocationPick: () => _attachmentHandler.pickLocation(context),
      onContactPick: () => _attachmentHandler.pickContact(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessagesCubit(
        MessagesRepository(),
        SocketService(),
      )..getMessages(widget.chatModel.id ?? ''),
      child: Builder(
        builder: (context) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Scaffold(
              backgroundColor: const Color(0xffECE5DD),
              appBar: ChatAppBar(chatModel: widget.chatModel),
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    // Message List
                    const Expanded(
                      child: ChatMessagesList(),
                    ),
                    // Input Field with Permission Check
                    FutureBuilder<bool>(
                      future: LocalData.hasEnumPermission(Permission.READ_WRITE_WHATSAPP),
                      builder: (context, snapshot) {
                        
                        // 1. Loading State (Show nothing or small loader)
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        }

                        // 2. Permission Granted: Show the Input Field
                        if (snapshot.data == true) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            child: ChatInputField(
                              onSendText: (msg) => context
                                  .read<MessagesCubit>()
                                  .sendMessage(widget.chatModel.id ?? '', msg),
                              onSendAudio: (path) => context
                                  .read<MessagesCubit>()
                                  .sendAudioMessage(
                                      widget.chatModel.id ?? '', path),
                              onUploadFile: _showAttachmentOptions,
                              onOpenCamera: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  Routes.cameraPage,
                                );
                                if (result != null &&
                                    result is Map &&
                                    context.mounted) {
                                  context.read<MessagesCubit>().sendImageMessage(
                                        widget.chatModel.id ?? '',
                                        result['imagePath'],
                                        result['caption'] ?? '',
                                      );
                                }
                              },
                            ),
                          );
                        }

                        // 3. Permission Denied: Show "Read Only" Banner
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                          color: Colors.white.withOpacity(0.95),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock_outline, color: Colors.grey[600], size: 20),
                              SizedBox(width: 10.w),
                              Text(
                                "You have read-only access to this chat.",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}