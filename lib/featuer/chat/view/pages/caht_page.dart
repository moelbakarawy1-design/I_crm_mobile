import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/helper/eror_snackBar_helper.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/featuer/chat/data/repo/MessagesRepository.dart';
import 'package:admin_app/featuer/chat/manager/chat_cubit.dart';
import 'package:admin_app/featuer/chat/manager/chat_state.dart';
import 'package:admin_app/featuer/chat/data/model/chat_model12.dart';
import 'package:admin_app/featuer/chat/data/repo/chat_repo.dart';
import 'package:admin_app/featuer/chat/view/widgets/cusstomUi/cusstom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CahtPage extends StatelessWidget {
  const CahtPage({super.key});

  // ✅ Helper to detect type if API misses it
  String _inferType(String? type, String? content) {
    if (type != null && ['video', 'image', 'audio', 'file', 'document', 'location', 'contacts'].contains(type.toLowerCase())) {
      return type.toLowerCase();
    }
    if (content == null) return 'text';
    
    final c = content.toLowerCase();
    if (c.endsWith('.mp4') || c.endsWith('.mov') || c.endsWith('.avi')) return 'video';
    if (c.endsWith('.jpg') || c.endsWith('.png') || c.endsWith('.jpeg')) return 'image';
    if (c.endsWith('.pdf') || c.endsWith('.doc') || c.endsWith('.docx')) return 'document';
    if (c.endsWith('.mp3') || c.endsWith('.wav') || c.endsWith('.aac')) return 'audio';
    
    return 'text';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ChatCubit(ChatRepository(), MessagesRepository())..fetchAllChats(),
      child: Stack(
        children: [
          BlocBuilder<ChatCubit, ChatState>(
            buildWhen: (previous, current) {
            
              return current is ChatLoading ||
                  current is ChatListLoaded ||
                  current is ChatError;
            },
            builder: (context, state) {
              if (state is ChatLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ChatListLoaded) {
                final chats = state.chatModel.data ?? [];
              if (state is ChatError) {
                showTopError(context, state.chatModel.message??'An error occurred');
              }
                if (chats.isEmpty) {
                  return const Center(
                    child: Text('No chats yet', style: TextStyle(color: Colors.grey)),
                  );
                }

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final Data chat = chats[index];
                    final lastMsg = (chat.messages?.isNotEmpty ?? false)
                        ? chat.messages!.last
                        : null;

                    final String messageContent = lastMsg?.content ?? 'No messages';
                    final String? messageTime = lastMsg?.timestamp ?? chat.createdAt;

                    // ✅ Determine Message Type
                    final String msgType = _inferType(lastMsg?.type, messageContent);

                    final String assignedToName = chat.user?.name ?? 'Unassigned'; 
                    final int unreadCount = (chat.id.hashCode % 4 == 0)
                        ? (chat.id.hashCode % 3) + 1
                        : 0; 
                    
                    final String? messageStatus = (unreadCount > 0)
                        ? null 
                        : (chat.id.hashCode % 3 == 0 ? 'read' : 'delivered'); 

                    return CusstomCard(
                      name: chat.customer?.name ?? 'Unknown',
                      assignedTo: assignedToName, 
                      message: messageContent, 
                      time: messageTime,
                      messageType: msgType,
                      messageStatus: messageStatus,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.individualScreen,
                          arguments: chat, 
                        );
                      },
                      onDelete: () {
                        final cubit = context.read<ChatCubit>();
                        _confirmDelete(context, chat.id ?? '', cubit);
                      },
                    );
                  },
                );
              }

              if (state is ChatError) {
                return Center(
                  child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)),
                );
              }

              return const SizedBox();
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: AppColor.lightBlue,
              onPressed: () {
                Navigator.pushNamed(context, Routes.createChatScreen);
              },
              child: Icon(Icons.chat, color: AppColor.mainWhite),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String chatId, ChatCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) { 
        return AlertDialog(
          title: const Text("Delete Chat"),
          content: const Text("Are you sure you want to delete this chat?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); 
                cubit.deleteChat(chatId);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}