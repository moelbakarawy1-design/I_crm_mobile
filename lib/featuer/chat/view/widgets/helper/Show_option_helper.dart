
import 'package:admin_app/featuer/User/data/model/getAllUser_model.dart';
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'package:admin_app/featuer/User/manager/user_state.dart';
import 'package:admin_app/featuer/chat/manager/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showChatOptions(BuildContext context, String chatId) {
  // We need the GetAllUserCubit for the "Assign" dialog
  final getAllUserCubit = context.read<GetAllUserCubit>();

  showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.person_add_alt_1),
              title: const Text('Assign Chat to User'),
              onTap: () {
                Navigator.pop(ctx); // Close bottom sheet
                _showAssignUserDialog(context, chatId, getAllUserCubit);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename Chat'),
              onTap: () {
                Navigator.pop(ctx); // Close bottom sheet
                _showRenameDialog(context, chatId);
              },
            ),
          ],
        ),
      );
    },
  );
}

/// 2. Rename Chat Dialog
void _showRenameDialog(BuildContext context, String chatId) {
  final TextEditingController renameController = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Rename Chat'),
        content: TextField(
          controller: renameController,
          decoration: const InputDecoration(
            labelText: 'New chat name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (renameController.text.isNotEmpty) {
                // Call the cubit function
                context
                    .read<ChatCubit>()
                    .renameChat(chatId, renameController.text);
                Navigator.pop(ctx); // Close dialog
              }
            },
            child: const Text('Rename'),
          ),
        ],
      );
    },
  );
}

/// 3. Assign User Dialog
void _showAssignUserDialog(BuildContext context, String chatId,
    GetAllUserCubit getAllUserCubit) {
  showDialog(
    context: context,
    builder: (ctx) {
      return BlocProvider.value(
        value: getAllUserCubit..fetchAllUsers(), 
        child: AlertDialog(
          title: const Text('Assign to User'),
         
          content: _AssignUserDialogContent(
            chatId: chatId,
         
            chatCubit: context.read<ChatCubit>(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    },
  );
}



class _AssignUserDialogContent extends StatefulWidget {
  final String chatId;
  final ChatCubit chatCubit;

  const _AssignUserDialogContent({
    required this.chatId,
    required this.chatCubit,
  });

  @override
  State<_AssignUserDialogContent> createState() =>
      _AssignUserDialogContentState();
}

class _AssignUserDialogContentState extends State<_AssignUserDialogContent> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Data> _filterUsers(List<Data> users) {
    if (_searchQuery.isEmpty) return users;
    return users.where((user) {
      final name = user.name?.toLowerCase() ?? '';
      final email = user.email?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Set dialog width and height
    return SizedBox(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by name or email...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
          const SizedBox(height: 16),
          // User List
          Expanded(
            child: BlocBuilder<GetAllUserCubit, GetAllUserState>(
              builder: (context, state) {
                if (state is GetAllUserLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is GetAllUserFailure) {
                  return Center(child: Text('Error: ${state.message}'));
                }

                if (state is GetAllUserSuccess) {
                  if (state.userModel.data == null ||
                      state.userModel.data!.isEmpty) {
                    return const Center(child: Text('No users found.'));
                  }

                  final filteredUsers = _filterUsers(state.userModel.data!);

                  if (filteredUsers.isEmpty) {
                    return const Center(child: Text('No users match search.'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(user.name?[0].toUpperCase() ?? '?'),
                        ),
                        title: Text(user.name ?? 'No Name'),
                        subtitle: Text(user.email ?? 'No Email'),
                        onTap: () {
                          widget.chatCubit
                              .assignChat(widget.chatId, user.id!);
                          Navigator.pop(context); 
                        },
                      );
                    },
                  );
                }
                return const Center(child: Text('Loading users...'));
              },
            ),
          ),
        ],
      ),
    );
  }
}