import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'rename_chat_dialog.dart'; // Import the files created below
import 'assign_user_dialog.dart'; // Import the files created below

class ChatOptionsHelper {
  
  static void showOptionsSheet(BuildContext context, String chatId) {
    // Capture the cubit before opening the sheet to preserve context
    final getAllUserCubit = context.read<GetAllUserCubit>();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take necessary space
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_add_alt_1, color: Colors.blue),
                  ),
                  title: const Text('Assign Chat to User', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showAssignUserDialog(context, chatId, getAllUserCubit);
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, color: Colors.orange),
                  ),
                  title: const Text('Rename Chat', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showRenameDialog(context, chatId);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _showRenameDialog(BuildContext context, String chatId) {
    showDialog(
      context: context,
      builder: (context) => RenameChatDialog(chatId: chatId),
    );
  }

  static void _showAssignUserDialog(
      BuildContext context, String chatId, GetAllUserCubit cubit) {
    showDialog(
      context: context,
      builder: (context) {
        // Re-provide the value because Dialog creates a new subtree
        return BlocProvider.value(
          value: cubit..fetchAllUsers(),
          child: AssignUserDialog(chatId: chatId),
        );
      },
    );
  }
}