import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/User/data/model/getAllUser_model.dart' as UserModel;
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'package:admin_app/featuer/User/manager/user_state.dart';

class AssignUserDropdown extends StatefulWidget {
  final List<String> selectedUserIds;
  final ValueChanged<List<String>> onSelectionChanged;

  const AssignUserDropdown({
    super.key,
    required this.selectedUserIds,
    required this.onSelectionChanged,
  });

  @override
  State<AssignUserDropdown> createState() => _AssignUserDropdownState();
}

class _AssignUserDropdownState extends State<AssignUserDropdown> {
  @override
  void initState() {
    super.initState();
    context.read<GetAllUserCubit>().fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllUserCubit, GetAllUserState>(
      builder: (context, state) {
        if (state is GetAllUserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetAllUserSuccess) {
          final users = state.userModel.data ?? [];

          return DropdownSearch<UserModel.Data>.multiSelection(
            items: (filter, infiniteScrollProps) => users,
            itemAsString: (UserModel.Data? user) =>
                '${user?.name ?? 'Unknown'} ${user?.role?.name ?? 'No Role'}',
            compareFn: (UserModel.Data? a, UserModel.Data? b) => a?.id == b?.id,
            selectedItems: users
                .where((u) => widget.selectedUserIds.contains(u.id))
                .toList(),
            onChanged: (List<UserModel.Data> selectedUsers) {
              final selectedIds = selectedUsers.map((e) => e.id!).toList();
              widget.onSelectionChanged(selectedIds);
            },
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: "Assign To",
                labelStyle: AppTextStyle.setpoppinsBlack(
                    fontSize: 10, fontWeight: FontWeight.w500),
                filled: true,
                fillColor: const Color(0xFFF6FAFD),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            popupProps: PopupPropsMultiSelection.menu(
              showSearchBox: true,
              itemBuilder: (context, item, isDisabled, isSelected) {
                final user = item;
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? Colors.blue.shade50 : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        radius: 18,
                        child: Text(
                          (user.name?.substring(0, 1) ?? '').toUpperCase(),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${user.name ?? 'Unknown'}\n',
                                style: AppTextStyle.setpoppinsBlack(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: '${user.email ?? 'No Email'}\n',
                                style: AppTextStyle.setipoppinssecondaryGery(
                                    fontSize: 8, fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: user.role?.name ?? 'No Role',
                                style: AppTextStyle.setpoppinsSecondlightGrey(
                                    fontSize: 6, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  hintStyle: AppTextStyle.setpoppinsBlack(
                      fontSize: 10, fontWeight: FontWeight.w500),
                  labelStyle: AppTextStyle.setpoppinsBlack(
                      fontSize: 10, fontWeight: FontWeight.w500),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
            ),
          );
        } else if (state is GetAllUserFailure) {
          return Text(
            'Failed to load users: ${state.message}',
            style: const TextStyle(color: Colors.red),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
