import 'package:admin_app/core/widgets/CustomAppBar_widget.dart';
import 'package:admin_app/featuer/User/data/model/getAllUser_model.dart';
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'package:admin_app/featuer/User/manager/user_state.dart';
import 'package:admin_app/featuer/User/view/widgets/user_error_view.dart';
import 'package:admin_app/featuer/User/view/widgets/user_list_item.dart';
import 'package:admin_app/featuer/User/view/widgets/user_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Only fetch if not already loaded (optional optimization)
    context.read<GetAllUserCubit>().fetchAllUsers();
  }

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
      final role = user.role?.name?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return name.contains(query) ||
          email.contains(query) ||
          role.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Manage Users',
        onMenuPressed: () => Navigator.pop(context),
      ),
      body: BlocBuilder<GetAllUserCubit, GetAllUserState>(
        builder: (context, state) {
          
          if (state is GetAllUserLoading || state is GetAllUserInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetAllUserFailure) {
            return UserErrorView(message: state.message);
          }

          if (state is GetAllUserSuccess) {
            if (state.userModel.data == null || state.userModel.data!.isEmpty) {
              return _buildEmptyState();
            }

            final List<Data> users = state.userModel.data!;
            final filteredUsers = _filterUsers(users);

            return Column(
              children: [
                UserSearchBar(
                  searchController: _searchController,
                  searchQuery: _searchQuery,
                  filteredCount: filteredUsers.length,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  onClear: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
                // User List
                Expanded(
                  child: filteredUsers.isEmpty
                      ? _buildNoSearchResults()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return UserListItem(user: user);
                          },
                        ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Users Found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'There are no users to display',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Results Found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}