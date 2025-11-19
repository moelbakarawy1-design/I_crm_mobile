import 'package:admin_app/featuer/chat/manager/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RenameChatDialog extends StatefulWidget {
  final String chatId;

  const RenameChatDialog({super.key, required this.chatId});

  @override
  State<RenameChatDialog> createState() => _RenameChatDialogState();
}

class _RenameChatDialogState extends State<RenameChatDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isValid = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Rename Chat', style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'New Chat Name',
              hintText: 'e.g., Support Ticket #123',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            onChanged: (val) {
              setState(() {
                _isValid = val.trim().isNotEmpty;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: _isValid
              ? () {
                  context.read<ChatCubit>().renameChat(
                        widget.chatId,
                        _controller.text.trim(),
                      );
                  Navigator.pop(context);
                }
              : null, // Disable button if empty
          child: const Text('Save'),
        ),
      ],
    );
  }
}