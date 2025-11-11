import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/widgets/CustomAppBar_widget.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/core/widgets/custom_textField_widget.dart';
import 'package:admin_app/featuer/Task/data/model/getAllTask_model.dart';
import 'package:admin_app/featuer/Task/manager/task_cubit.dart';
import 'package:admin_app/featuer/Task/manager/task_state.dart';
import 'package:admin_app/featuer/Task/view/widget/assign_user_dropdown.dart';
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'package:admin_app/featuer/User/manager/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class EditTaskDialog extends StatefulWidget {
  final TaskSummary task; 
  
  const EditTaskDialog({super.key, required this.task, });

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late List<String> _selectedUserIds;
  late DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);

    _selectedUserIds =
      [];
    _deadline = widget.task.endDate != null
        ? DateTime.tryParse(widget.task.endDate!)
        : null;
    context.read<GetAllUserCubit>().fetchAllUsers();
  }

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

  void _handleEditTask() {
    if (_formKey.currentState!.validate()) {
      if (_selectedUserIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please assign to at least one user')),
        );
        return;
      }
      if (_deadline == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a deadline')),
        );
        return;
      }

      context.read<TaskCubit>().updateTask(
            taskId: widget.task.id!,
            title: _titleController.text,
            description: _descriptionController.text,
            assignedTo: _selectedUserIds,
            endDate: _deadline,
          );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    String deadlineText = 'Deadline';
    if (_deadline != null) {
      deadlineText = DateFormat('d-M-y').format(_deadline!);
    }

    return Scaffold(
     appBar: const CustomAppBar(title: 'Edit Task'),
      backgroundColor: const Color(0xFFF1F5F9),
      body: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 45.h),
        child: BlocListener<TaskCubit, TaskState>(
          listener: (context, state) {
            // ✅ --- Listen for success and pop the dialog ---
            if (state is UpdateTaskSuccess) {
              Navigator.pop(context); // Close the edit dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message), backgroundColor: Colors.green),
              );
            } else if (state is UpdateTaskFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          child: Container(
            height: 600.h ,
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
                        const Text('Edit Task',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      InkWell(
                          onTap: () => Navigator.pop(context),
                          child: SvgPicture.asset('assets/svg/Button.svg',width: 50.w, height: 50.h,))
                      ],
                    ),
                    SizedBox(height: 15.h),
      
                    // ✅ --- User Selection Dropdown ---
                   BlocBuilder<GetAllUserCubit, GetAllUserState>(
              builder: (context, state) {
               if (state is GetAllUserLoading) {
               return const Center(child: CircularProgressIndicator());
               } else if (state is GetAllUserSuccess) {
                  return AssignUserDropdown(
                   selectedUserIds: _selectedUserIds,
                   onSelectionChanged: (ids) {
                setState(() {
                  _selectedUserIds = ids;
                });
              },
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
      
                    // Deadline
                    GestureDetector(
                      onTap: _pickDeadline,
                      child: AbsorbPointer(
                        child: CustomTextFormField(
                          hintText: deadlineText,
                          prefixIcon: SvgPicture.asset(
                            'assets/svg/calendar 1.svg',
                            width: 14.w,
                            height: 14.h,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h,),     
                    // Task title
                    CustomTextFormField(
                      hintText: 'Task Title',
                      controller: _titleController,
                      validator: (v) => v!.isEmpty ? 'Required field' : null,
                      suffixIcon: SvgPicture.asset('assets/svg/edit-2.svg',
                          fit: BoxFit.scaleDown),
                    ),
                    SizedBox(height: 20.h),
      
                    // Task Description
                    CustomTextFormField(
                      hintText: 'Task Description',
                      controller: _descriptionController,
                      maxLines: 5,
                      suffixIcon: SvgPicture.asset('assets/svg/edit-2.svg',
                          fit: BoxFit.scaleDown),
                    ),
                    SizedBox(height: 30.h),
      
                    BlocConsumer<TaskCubit, TaskState>(
                      listener: (context, state) {
                
                      },
                      builder: (context, state) {
                        if (state is UpdateTaskLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return CustomButton(
                          text: 'Edit Task',
                          onPressed: _handleEditTask,
                          width: 343.w,
                          backgroundColor: AppColor.mainBlue,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}