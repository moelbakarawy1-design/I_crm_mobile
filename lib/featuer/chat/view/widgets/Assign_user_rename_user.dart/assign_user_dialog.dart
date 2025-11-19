import 'package:admin_app/featuer/User/data/model/getAllUser_model.dart';
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'package:admin_app/featuer/User/manager/user_state.dart';
import 'package:admin_app/featuer/chat/manager/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignUserDialog extends StatefulWidget {
  final String chatId;

  const AssignUserDialog({super.key, required this.chatId});

  @override
  State<AssignUserDialog> createState() => _AssignUserDialogState();
}

class _AssignUserDialogState extends State<AssignUserDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Data> _filterUsers(List<Data> users) {
    if (_searchQuery.isEmpty) return users;
    final query = _searchQuery.toLowerCase();
    return users.where((user) {
      final name = user.name?.toLowerCase() ?? '';
      final email = user.email?.toLowerCase() ?? '';
      return name.contains(query) || email.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(20),
      // Fixed title to ensure it doesn't scroll
      title: Row(
        children: [
          const Icon(Icons.group_add_outlined, color: Colors.blueAccent),
          const SizedBox(width: 10),
          const Text('Assign User'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400, // Constraint height
        child: Column(
          children: [
            // 1. Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search user...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 16),
            
            // 2. List Area
            Expanded(
              child: BlocBuilder<GetAllUserCubit, GetAllUserState>(
                builder: (context, state) {
                  if (state is GetAllUserLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetAllUserFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 30),
                          const SizedBox(height: 8),
                          Text(state.message, textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  } else if (state is GetAllUserSuccess) {
                    final users = state.userModel.data ?? [];
                    final filteredList = _filterUsers(users);

                    if (users.isEmpty) {
                      return _buildEmptyState('No users found in database.');
                    }
                    if (filteredList.isEmpty) {
                      return _buildEmptyState('No matching results.');
                    }

                    return ListView.separated(
                      itemCount: filteredList.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final user = filteredList[index];
                        return _UserListTile(
                          user: user,
                          onTap: () {
                            context.read<ChatCubit>().assignChat(widget.chatId, user.id!);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search_outlined, size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(text, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

// Separate widget for the list item to keep code clean
class _UserListTile extends StatelessWidget {
  final Data user;
  final VoidCallback onTap;

  const _UserListTile({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final firstLetter = user.name?.isNotEmpty == true ? user.name![0].toUpperCase() : '?';
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Text(
          firstLetter,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        user.name ?? 'Unknown User',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        user.email ?? 'No Email',
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400),
    );
  }
}