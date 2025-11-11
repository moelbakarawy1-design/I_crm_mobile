import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/chat/data/model/chat_model12.dart';
import 'package:admin_app/featuer/chat/data/repo/MessagesRepository.dart';
import 'package:admin_app/featuer/chat/manager/message_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndividualScreen extends StatefulWidget {
  final Data chatModel;

  const IndividualScreen({super.key, required this.chatModel});

  @override
  State<IndividualScreen> createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> {
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessagesCubit(MessagesRepository())
        ..getMessages(widget.chatModel.id ?? ''),
      child: Scaffold(
        backgroundColor: const Color(0xffECE5DD),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: AppColor.lightBlue,
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
                style: AppTextStyle.setpoppinsWhite(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              //  Chat Messages 
              Expanded(
                child: BlocBuilder<MessagesCubit, MessagesState>(
                  buildWhen: (prev, curr) =>
                      curr is MessagesLoaded ||
                      curr is MessagesError ||
                      curr is MessagesLoading,
                  builder: (context, state) {
                    if (state is MessagesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xff075E54)),
                      );
                    } else if (state is MessagesLoaded) {
                      final messages = state.messages;
                      if (messages.isEmpty) {
                        return const Center(
                          child: Text(
                            "No messages yet",
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[messages.length - 1 - index];
                          final isMe = msg.senderType == "ADMIN" ||
                              msg.direction == "OUTGOING";

                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(10),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? const Color(0xffDCF8C6)
                                    : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(12),
                                  topRight: const Radius.circular(12),
                                  bottomLeft: isMe
                                      ? const Radius.circular(12)
                                      : const Radius.circular(0),
                                  bottomRight: isMe
                                      ? const Radius.circular(0)
                                      : const Radius.circular(12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                             child: Column(
  crossAxisAlignment: isMe
      ? CrossAxisAlignment.end
      : CrossAxisAlignment.start,
  children: [
    // 👤 Sender name
    Text(
      msg.from ?? (isMe ? "You" : "Customer"),
      style: AppTextStyle.setpoppinsTextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600, color: AppColor.secondaryBlack,
        
      ),
    ),

    const SizedBox(height: 3),

    // 💬 Message content
    Text(
      msg.content ?? '',
      style: AppTextStyle.setpoppinsBlack(
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
    ),

    const SizedBox(height: 4),

    // 🕒 Time + status row
    Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        // Format time
        Text(
          _formatTime(msg.timestamp),
          style: AppTextStyle.setpoppinsTextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w400,
            color: AppColor.gray70,
          ),
        ),

        const SizedBox(width: 5),

        // Status (only for sent by admin)
        if (isMe && msg.status != null)
          Text(
            _getStatusText(msg.status!),
            style: AppTextStyle.setpoppinsTextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w400,
              color: _getStatusColor(msg.status!),
            ),
          ),
      ],
    ),
  ],
),

                            ),
                          );
                        },
                      );
                    } else if (state is MessagesError) {
                      return Center(child: Text(state.error));
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),

              // Message Input 
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                color: Colors.white,
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.emoji_emotions_outlined,
                            color: Colors.grey),
                        onPressed: () {},
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                                hintText: "Type a message",
                                border: InputBorder.none,
                                labelStyle: AppTextStyle.setpoppinsBlack(
                                    fontSize: 10, fontWeight: FontWeight.w500)),
                            style: AppTextStyle.setpoppinsBlack(
                                fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Row(

                        children:[
                              IconButton(                       
                          icon: const Icon(Icons.camera_alt, color: Color(0xff075E54)),
                          onPressed: () {
                          Navigator.pushNamed(context, Routes.cameraPage);
                          },
                        ),
                        SizedBox(width: 6.w,),
                          IconButton(                       
                          icon: const Icon(Icons.send, color: Color(0xff075E54)),
                          onPressed: () {
                            final msg = _messageController.text.trim();
                            if (msg.isNotEmpty) {
                              context
                                  .read<MessagesCubit>()
                                  .sendMessage(widget.chatModel.id ?? '', msg);
                              _messageController.clear();
                            }
                          },
                        ),] 
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'SENT':
        return 'SENT ✓';
      case 'DELIVERED':
        return 'DELIVERED ✓✓';
      case 'READ':
        return 'Seen ✓✓';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SENT':
        return Colors.grey;
      case 'DELIVERED':
        return Colors.blueGrey;
      case 'READ':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
  String _formatTime(String? dateTimeString) {
  if (dateTimeString == null || dateTimeString.isEmpty) return '';
  try {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final hours = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hours:$minutes $period';
  } catch (e) {
    return '';
  }
}

}