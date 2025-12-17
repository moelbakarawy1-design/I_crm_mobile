import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/helper/enum_permission.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/featuer/chat/data/model/chat_model12.dart';
import 'package:admin_app/featuer/chat/manager/BroadcastCubit.dart';
import 'package:admin_app/featuer/chat/manager/chat_cubit.dart';
import 'package:admin_app/featuer/chat/manager/chat_state.dart';
import 'package:admin_app/featuer/chat/view/pages/cahtPage/view/Broadcast_dialoge.dart';
import 'package:admin_app/featuer/chat/view/pages/cahtPage/widgets/AnimatedFAB_widgets.dart';
import 'package:admin_app/featuer/chat/view/pages/cahtPage/widgets/ChatListView.dart';
import 'package:admin_app/featuer/chat/view/pages/cahtPage/widgets/EmptyChatsState_widgets.dart';
import 'package:admin_app/featuer/chat/view/widgets/showDeleteDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CahtPage extends StatelessWidget {
  const CahtPage({super.key});

  void _showBroadcastDialog(BuildContext context) {
    // Capture Cubits from the current context
    final broadcastCubit = context.read<BroadcastCubit>();
    final chatCubit = context.read<ChatCubit>();

    showDialog(
      context: context,
      builder: (_) {
        // Pass providers to the Dialog
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: broadcastCubit),
            BlocProvider.value(value: chatCubit),
          ],
          child: const BroadcastDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<ChatCubit, ChatState>(
            buildWhen: (previous, current) {
              return current is ChatLoading ||
                  current is ChatListLoaded ||
                  current is ChatError ||
                  current is ChatSearchResult;
            },
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildContent(context, state),
              );
            },
          ),

          FutureBuilder<bool>(
            future: LocalData.hasEnumPermission(Permission.READ_WRITE_WHATSAPP),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.orange,
                        onPressed: () => _showBroadcastDialog(context),
                        child: const Icon(Icons.campaign, color: Colors.white),
                      ),

                      const SizedBox(height: 12),

                      const AnimatedFAB(),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ChatState state) {
    List<Data> chats = [];

    if (state is ChatLoading) {
      return const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(),
      );
    }

    if (state is ChatListLoaded) {
      chats = state.chatModel.data ?? [];
    } else if (state is ChatSearchResult) {
      chats = state.results;
    } else if (state is ChatError) {
      return Center(
        key: const ValueKey('error'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<ChatCubit>().fetchAllChats(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (chats.isEmpty) {
      return const EmptyChatsState(key: ValueKey('empty'));
    }

    return ChatListView(
      key: const ValueKey('loaded'),
      chats: chats,
      onChatTap: (chat) => _navigateToChat(context, chat),
      onChatDelete: (chatId) => _confirmDelete(context, chatId),
    );
  }

  void _navigateToChat(BuildContext context, Data chat) {
    if (chat.id != null) {
      context.read<ChatCubit>().openChat(chat.id!);
    }
    Navigator.pushNamed(context, Routes.individualScreen, arguments: chat);
  }

  void _confirmDelete(BuildContext context, String chatId) {
    showDeleteDialog(
      context: context,
      onConfirm: () {
        context.read<ChatCubit>().deleteChat(chatId);
      },
    );
  }
}
