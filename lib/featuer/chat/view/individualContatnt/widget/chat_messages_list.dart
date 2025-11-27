import 'package:admin_app/featuer/chat/view/individualContatnt/widget/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/featuer/chat/manager/message_cubit.dart';

class ChatMessagesList extends StatefulWidget {
  const ChatMessagesList({super.key});

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  // 1️⃣ مش محتاجين نضيف Listener هنا خلاص
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        if (state is MessagesLoading && state is! MessagesLoaded) {
           return const Center(child: CircularProgressIndicator(color: Color(0xff075E54)));
        } 
        else if (state is MessagesLoaded) {
          final messages = state.messages;
          final cubit = context.read<MessagesCubit>();
          
          // 2️⃣ التغيير الجذري: NotificationListener
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {             
              if (scrollInfo is ScrollUpdateNotification) {
                final metrics = scrollInfo.metrics;
                final maxScroll = metrics.maxScrollExtent;
                final currentScroll = metrics.pixels;
                if (currentScroll >= (maxScroll - 100)) {
                  if (!cubit.isLoadingMore) {
                    cubit.loadMoreMessages();
                  }
                }
              }
              return false;
            },
            child: ListView.builder(
              controller: _scrollController,
              reverse: true, // معكوس (تحت = 0
              itemCount: messages.length + 1,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {      
                if (index == messages.length) {
                  if (cubit.isLoadingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                        child: SizedBox(
                          height: 20, 
                          width: 20, 
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xff075E54))
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox(height: 10); 
                  }
                }
                
                final msg = messages[index];
                final isMe = msg.senderType == "ADMIN" || msg.direction == "OUTGOING";
                
                return MessageBubble(msg: msg, isMe: isMe);
              },
            ),
          );
        } 
        return const SizedBox();
      },
    );
  }
}