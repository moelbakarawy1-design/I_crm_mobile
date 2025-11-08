import 'package:admin_app/core/widgets/CustomAppBar_widget.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/core/widgets/custom_textField_widget.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/Task/manager/task_cubit.dart';
import 'package:admin_app/featuer/Task/manager/task_state.dart';
import 'package:admin_app/featuer/User/data/model/getAllUser_model.dart';
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'package:admin_app/featuer/User/manager/user_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dropdown_search/dropdown_search.dart';


class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _deadline;
   List<String> selectedUserIds = [];
  void _pickDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  void _handleAddTask() {
  if (_formKey.currentState!.validate()) {
    if (_deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a deadline')),
      );
      return;
    }

    context.read<TaskCubit>().createTask(
      title: _titleController.text,
      description: _descriptionController.text,
      assignedTo: selectedUserIds, 
      endDate: _deadline! ,
      
    );
  }
}


  @override
  void initState() {
    super.initState();
    context.read<GetAllUserCubit>().fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Task'),
      backgroundColor: const Color(0xFFF1F5F9),
      body: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 45.h),
        child: Container(
          width: 388.w,
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add New Task',
                        style: AppTextStyle.setpoppinsTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0XFF092C4C),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          'assets/svg/Button.svg',
                          width: 50.w,
                          height: 50.h,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
    
                  /// 🔽 Dropdown for Assigned To
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Task Assigned To',
                      style: AppTextStyle.setpoppinsTextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: const Color(0XFF667085),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
    
          BlocBuilder<GetAllUserCubit, GetAllUserState>(
  builder: (context, state) {
    if (state is GetAllUserLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is GetAllUserSuccess) {
      final users = state.userModel.data ?? [];

      return DropdownSearch<Data>.multiSelection(
        items: (filter, infiniteScrollProps)=> users,
        itemAsString: (Data? user) => '${user?.name ?? 'Unknown'} ${user?.role?.name ?? 'No Role'}',
        compareFn: (Data? a, Data? b) => a?.id == b?.id,
        selectedItems: users.where((u) => selectedUserIds.contains(u.id)).toList(),
        onChanged: (List<Data> selectedUsers) {
          setState(() {
            selectedUserIds = selectedUsers.map((e) => e.id!).toList(); 
          });
        },
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: "Assign To",
            labelStyle: AppTextStyle.setpoppinsBlack(fontSize: 10, fontWeight: FontWeight.w500),
            filled: true,
            fillColor: const Color(0xFFF6FAFD),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        popupProps:  PopupPropsMultiSelection.menu(
          showSearchBox: true,
          itemBuilder: (context, item, isDisabled, isSelected) {
            final user = item;
            return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
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
                    style:  AppTextStyle.setpoppinsBlack(fontSize: 12, fontWeight: FontWeight.w500)
                  ),
                  TextSpan(
                    text: '${user.email ?? 'No Email'}\n',
                    style: AppTextStyle.setipoppinssecondaryGery(fontSize: 8, fontWeight: FontWeight.w500)
                  ),
                  TextSpan(
                    text: user.role?.name ?? 'No Role',
                    style: AppTextStyle.setpoppinsSecondlightGrey(fontSize: 6, fontWeight: FontWeight.w600)
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
              hintStyle: AppTextStyle.setpoppinsBlack(fontSize: 10, fontWeight: FontWeight.w500),
              labelStyle: AppTextStyle.setpoppinsBlack(fontSize: 10, fontWeight: FontWeight.w500),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
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
),

                  SizedBox(height: 20.h),
                  /// Deadline
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Reschedule the delivery date',
                      style: AppTextStyle.setpoppinsTextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: const Color(0XFF667085),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: _pickDeadline,
                    child: AbsorbPointer(
                      child: CustomTextFormField(
                        fillColor: const Color(0xFFF6FAFD),
                        hintText: _deadline == null
                            ? 'Deadline'
                            : "${_deadline!.day}-${_deadline!.month}-${_deadline!.year}",
                        prefixIcon: SvgPicture.asset(
                          'assets/svg/calendar 1.svg',
                          width: 14.w,
                          height: 14.h,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
    
                  /// Task title
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Enter Task Title',
                      style: AppTextStyle.setpoppinsTextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: const Color(0XFF667085),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextFormField(
                    fillColor: const Color(0xFFF6FAFD),
                    hintText: 'Follow up with client',
                    controller: _titleController,
                    suffixIcon: SvgPicture.asset('assets/svg/edit-2.svg',
                        fit: BoxFit.scaleDown),
                    validator: (v) => v!.isEmpty ? 'Required field' : null,
                  ),
                  SizedBox(height: 20.h),
    
                  /// Task Description
                  CustomTextFormField(
                    fillColor: const Color(0xFFF6FAFD),
                    hintText: 'Enter the required task………',
                    controller: _descriptionController,
                    maxLines: 5,
                    suffixIcon: SvgPicture.asset('assets/svg/edit-2.svg',
                        fit: BoxFit.scaleDown),
                  ),
                  SizedBox(height: 30.h),
    
                  /// Submit button
                 BlocConsumer<TaskCubit, TaskState>
(
      listener: (context, state) {
    if (state is CreateTaskSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('done'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else if (state is CreateTaskFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
      },
      builder: (context, state) {
    if (state is CreateTaskLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return CustomButton(
      text: 'Add Task',
      onPressed: _handleAddTask,
      width: 332.w,
      height: 33.h,
      backgroundColor: const Color(0xFF1570EF),
      textColor: Colors.white,
      borderRadius: 8,
    );
      },
    )
    
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
