import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/featuer/chat/manager/chat_cubit.dart';
import 'package:admin_app/featuer/chat/manager/chat_state.dart';
import 'package:admin_app/featuer/chat/data/model/chat_model12.dart';
import 'package:admin_app/featuer/chat/view/pages/cahtPage/widgets/AnimatedFAB_widgets.dart';
import 'package:admin_app/featuer/chat/view/pages/cahtPage/widgets/ChatListView.dart';
import 'package:admin_app/featuer/chat/view/pages/cahtPage/widgets/EmptyChatsState_widgets.dart';
import 'package:admin_app/featuer/chat/view/widgets/showDeleteDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CahtPage extends StatelessWidget {
  const CahtPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          BlocBuilder<ChatCubit, ChatState>(
            buildWhen: (previous, current) {
              print("🔄 CahtPage buildWhen: ${current.runtimeType}");
              return current is ChatLoading ||
                  current is ChatListLoaded ||
                  current is ChatError ||
                  current is ChatSearchResult;
            },
            builder: (context, state) {
              print("🎨 CahtPage building with state: ${state.runtimeType}");
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildContent(context, state),
              );
            },
          ),

          // Floating Action Button
          const AnimatedFAB(),
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

    // 🔍 Support both ChatListLoaded and ChatSearchResult
    if (state is ChatListLoaded) {
      chats = state.chatModel.data ?? [];
      print("📋 Displaying ${chats.length} chats (ChatListLoaded)");
    } else if (state is ChatSearchResult) {
      chats = state.results;
      print("🔍 Displaying ${chats.length} search results (ChatSearchResult)");
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

    // If no chats
    if (chats.isEmpty) {
      return const EmptyChatsState(key: ValueKey('empty'));
    }

    // Display chat list
    return ChatListView(
      key: const ValueKey('loaded'),
      chats: chats,
      onChatTap: (chat) => _navigateToChat(context, chat),
      onChatDelete: (chatId) => _confirmDelete(context, chatId),
    );
  }

  void _navigateToChat(BuildContext context, Data chat) {
    Navigator.pushNamed(
      context,
      Routes.individualScreen,
      arguments: chat,
    );
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