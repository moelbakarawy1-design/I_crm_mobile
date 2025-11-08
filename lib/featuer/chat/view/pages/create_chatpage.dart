import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/core/widgets/custom_textField_widget.dart';
import 'package:admin_app/featuer/chat/data/repo/MessagesRepository.dart';
import 'package:admin_app/featuer/chat/manager/message_cubit.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateChatScreen extends StatefulWidget {
  const CreateChatScreen({super.key});

  @override
  State<CreateChatScreen> createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _selectedCountryCode = "+20"; // Default country code for Egypt 🇪🇬

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MessagesCubit(MessagesRepository()),
      child: BlocConsumer<MessagesCubit, MessagesState>(
        listener: (context, state) {
          if (state is MessagesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is MessagesLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Chat created successfully!"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final cubit = context.read<MessagesCubit>();

          return Scaffold(
            appBar: AppBar(
              title: const Text("Create Chat"),
              backgroundColor: AppColor.lightBlue,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter customer details",
                      style: AppTextStyle.setpoppinsBlack(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15.h),

                    // Name Field
                    CustomTextFormField(
                      controller: _nameController,
                      labelText: "Enter Name",
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a name";
                        }
                        if (value.length < 3) {
                          return "Name must be at least 3 characters long";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    // Phone Field with Country Picker
                    Text(
                      "Phone Number",
                      style: AppTextStyle.setpoppinsBlack(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        children: [
                          CountryCodePicker(
                            onChanged: (country) {
                              setState(() {
                                _selectedCountryCode = country.dialCode ?? "+20";
                              });
                            },
                            initialSelection: 'EG',
                            favorite: const ['+20', 'EG'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                hintText: "Enter phone number",
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a phone number";
                                }
                                if (value.length < 8) {
                                  return "Phone number too short";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Button
                    Center(
                      child: CustomButton(
                        text: "Create Chat",
                        width: double.infinity,
                        height: 45,
                        backgroundColor: AppColor.lightBlue,
                        isLoading: state is MessagesLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final fullPhone =
                                '$_selectedCountryCode${_phoneController.text.trim()}';
                            cubit.createChat(fullPhone, _nameController.text.trim());
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
