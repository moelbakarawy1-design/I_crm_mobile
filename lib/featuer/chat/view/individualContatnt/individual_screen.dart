import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/featuer/chat/data/model/chat_model12.dart';
import 'package:admin_app/featuer/chat/data/repo/MessagesRepository.dart';
import 'package:admin_app/featuer/chat/manager/message_cubit.dart';
import 'package:admin_app/featuer/chat/service/Socetserver.dart';
import 'package:admin_app/featuer/chat/view/individualContatnt/Utils/AttachmentHandler_utils.dart';
import 'package:admin_app/featuer/chat/view/individualContatnt/widget/ChatAppBar%20_widget.dart';
import 'package:admin_app/featuer/chat/view/individualContatnt/widget/chat_messages_list.dart';
import 'package:admin_app/featuer/chat/view/chat_input_contant/chat_inputField_widget.dart';
import 'package:admin_app/featuer/chat/view/individualContatnt/widget/showAttachmentBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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
    
    // Fade animation for the entire screen
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
                    // Message List with Hero Animation
                    const Expanded(
                      child: ChatMessagesList(),
                    ),
                    
                    // Input Field with Slide Animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      child: ChatInputField(
                        onSendText: (msg) => context
                            .read<MessagesCubit>()
                            .sendMessage(widget.chatModel.id ?? '', msg),
                        onSendAudio: (path) => context
                            .read<MessagesCubit>()
                            .sendAudioMessage(widget.chatModel.id ?? '', path),
                        onUploadFile: _showAttachmentOptions,
                        onOpenCamera: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            Routes.cameraPage,
                          );
                          if (result != null && result is Map && context.mounted) {
                            context.read<MessagesCubit>().sendImageMessage(
                              widget.chatModel.id ?? '',
                              result['imagePath'],
                              result['caption'] ?? '',
                            );
                          }
                        },
                      ),
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