import 'package:admin_app/featuer/chat/view/individualContatnt/widget/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/featuer/chat/manager/message_cubit.dart';

class ChatMessagesList extends StatelessWidget {
  const ChatMessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        if (state is MessagesLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff075E54)),
          );
        } else if (state is MessagesLoaded) {
          final messages = state.messages;
          if (messages.isEmpty) {
            return const Center(
              child: Text("No messages yet", style: TextStyle(color: Colors.grey)),
            );
          }
          return ListView.builder(
            reverse: true,
            itemCount: messages.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final msg = messages[messages.length - 1 - index];
              // منطق تحديد المرسل
              final isMe = msg.senderType == "ADMIN" || msg.direction == "OUTGOING";
              
              return MessageBubble(msg: msg, isMe: isMe);
            },
          );
        } else if (state is MessagesError) {
          return Center(child: Text(state.error));
        }
        return const SizedBox();
      },
    );
  }
}