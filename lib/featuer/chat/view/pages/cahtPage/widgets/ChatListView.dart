import 'package:admin_app/featuer/chat/data/model/chat_model12.dart';
import 'package:admin_app/featuer/chat/view/pages/cahtPage/widgets/utils/MessageTypeHelper.dart';
import 'package:admin_app/featuer/chat/view/widgets/cusstomUi/cusstom_card.dart';
import 'package:flutter/material.dart';

class ChatListView extends StatefulWidget {
  final List<Data> chats;
  final Function(Data chat) onChatTap;
  final Function(String chatId) onChatDelete;

  const ChatListView({
    super.key,
    required this.chats,
    required this.onChatTap,
    required this.onChatDelete,
  });

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.chats.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 80), // Space for FAB
      itemBuilder: (context, index) {
        return _buildAnimatedChatItem(context, widget.chats[index], index);
      },
    );
  }

  Widget _buildAnimatedChatItem(BuildContext context, Data chat, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: _buildChatCard(context, chat),
    );
  }

  Widget _buildChatCard(BuildContext context, Data chat) {
    final lastMsg = (chat.messages?.isNotEmpty ?? false)
        ? chat.messages!.last
        : null;

    final String messageContent = lastMsg?.content ?? 'No messages';
    final String? messageTime = lastMsg?.timestamp ?? chat.createdAt;
    final String msgType = MessageTypeHelper.inferType(
      lastMsg?.type,
      messageContent,
    );

    final String assignedToName = chat.user?.name ?? 'Unassigned';
    final int unreadCount = (chat.id.hashCode % 4 == 0)
        ? (chat.id.hashCode % 3) + 1
        : 0;

    final String? messageStatus = (unreadCount > 0)
        ? null
        : (chat.id.hashCode % 3 == 0 ? 'read' : 'delivered');

    return Dismissible(
      key: Key(chat.id!),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      confirmDismiss: (direction) async {
        widget.onChatDelete(chat.id ?? '');
        return false; 
      },
      child: CusstomCard(
        name: chat.customer?.name ?? 'Unknown',
        assignedTo: assignedToName,
        message: messageContent,
        time: messageTime,
        messageType: msgType,
        messageStatus: messageStatus,
        onTap: () => widget.onChatTap(chat),
        onDelete: () => widget.onChatDelete(chat.id ?? ''),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.withOpacity(0.8), Colors.red],
        ),
      ),
      child: const Icon(
        Icons.delete_outline,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}