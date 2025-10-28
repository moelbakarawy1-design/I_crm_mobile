import 'package:admin_app/featuer/getAllRole/data/model/role_model.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_cubit.dart'; // <-- 1. Import Cubit
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // <-- 2. Import Bloc
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showDeleteConfirmationDialog(BuildContext context, RoleModel role) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: const Text('Delete Role'),
      content: Text('Are you sure you want to delete "${role.name}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.read<InvitationCubit>().deleteRole(roleId: role.id);          
            Navigator.pop(context);      
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}