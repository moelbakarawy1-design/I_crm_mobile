import 'package:admin_app/core/network/local_invitation.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/widgets/CustomAppBar_widget.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_cubit.dart';
import 'package:admin_app/featuer/getAllRole/view/screens/AddController_screen.dart';
import 'package:admin_app/featuer/getAllRole/view/widget/show_dilog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InvitationPage extends StatefulWidget {
  const InvitationPage({super.key});

  @override
  State<InvitationPage> createState() => _InvitationPageState();
}

class _InvitationPageState extends State<InvitationPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _invitedUsers = [];
  int _currentPage = 1;
  final int _itemsPerPage = 6;

  @override
  void initState() {
    super.initState();
    InvitationCubit.get(context).fetchRoles();
    _loadInvitations();
  }

  Future<void> _loadInvitations() async {
    final saved = await LocalInvitations.loadInvitations();
    setState(() {
      _invitedUsers.addAll(saved);
    });
  }

  Future<void> _saveInvitations() async {
    await LocalInvitations.saveInvitations(_invitedUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredUsers {
    if (_searchController.text.isEmpty) return _invitedUsers;
    final searchLower = _searchController.text.toLowerCase();
    return _invitedUsers.where((user) {
      return user['name'].toLowerCase().contains(searchLower) ||
          user['email'].toLowerCase().contains(searchLower);
    }).toList();
  }

  List<Map<String, dynamic>> get _paginatedUsers {
    final filtered = _filteredUsers;
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= filtered.length) return [];
    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }
  Future<void> _showDeleteConfirmationDialog(BuildContext context, dynamic user) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          user: user,
          onDeleteConfirmed: () async {
            setState(() {
              _invitedUsers.remove(user);
            });
            await _saveInvitations();
            // Optional: Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('User deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar:CustomAppBar(title: 'Send Invite',onMenuPressed: () => Navigator.pop(context),),

      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            /// 🔍 Search and Add Controller Button
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() => _currentPage = 1),
                      style:  AppTextStyle.setpoppinsTextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColor.gray70),

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0XFFEAEEF4),
                        hintText: 'Search Name',
                        hintStyle: AppTextStyle.setpoppinsTextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColor.gray70),
                        prefixIcon: SvgPicture.asset(
                          'assets/svg/Vector.svg',
                          width: 16.w,
                          height: 16.h,
                          fit: BoxFit.scaleDown,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF9CA3AF),
                            BlendMode.srcIn,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddControllerPage(),
                      ),
                    );

                    if (result != null && result is Map<String, dynamic>) {
                      setState(() {
                        result['date'] = DateTime.now();
                        _invitedUsers.insert(0, result);
                        _currentPage = 1;
                      });
                      await _saveInvitations();
                    }
                  },
                  icon: Icon(Icons.add, size: 16.w, color: Colors.white),
                  label: Text(
                    'Add Controller',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    minimumSize: Size(122.w, 38.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            /// 🧾 Table View (ListView Style)
        Expanded(
      child: _invitedUsers.isEmpty
      ? const Center(
          child: Text('No controllers added yet'),
        )
      : Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColor.mainBlack.withOpacity(0.05),
                blurRadius: 7,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              /// Table Header
              Container(
                width: 486.w,
              //  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(5),
                    1: FlexColumnWidth(4),
                    2: FlexColumnWidth(4),
                    3: FlexColumnWidth(5),
                    4: FlexColumnWidth(5),
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 10.w),
                          child: Text(
                            'Name',
                            style:AppTextStyle.setpoppinsTextStyle(fontSize: 8, fontWeight: FontWeight.w500, color: Color(0XFF7E92A2))
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h,),
                          child: Text(
                            'Email',
                             style:AppTextStyle.setpoppinsTextStyle(fontSize: 8, fontWeight: FontWeight.w500, color: Color(0XFF7E92A2))

                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 10.w),
                          child: Text(
                            'Role',
                             style:AppTextStyle.setpoppinsTextStyle(fontSize: 8, fontWeight: FontWeight.w500, color: Color(0XFF7E92A2))

                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h,horizontal:12.w),
                          child: Text(
                            'Start Date',
                             style:AppTextStyle.setpoppinsTextStyle(fontSize: 8, fontWeight: FontWeight.w500, color: Color(0XFF7E92A2))

                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h ,horizontal: 10.w),
                          child: Text(
                            'Actions',
                             style:AppTextStyle.setpoppinsTextStyle(fontSize: 8, fontWeight: FontWeight.w500, color: Color(0XFF7E92A2))

                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          
              /// Table Content
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _paginatedUsers.length,
                  itemBuilder: (context, index) {
                    final user = _paginatedUsers[index];
                    final date = user['date'] as DateTime;
                    final months = [
                      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                    ];
                    final formattedDate =
                        '${months[date.month - 1]} ${date.day}, ${date.year}';
          
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(4),
                          2: FlexColumnWidth(4),
                          3: FlexColumnWidth(4),
                          4: FlexColumnWidth(5),
                        },
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 12.h,
                                ),
                                child: Text(
                                  user['name'],
                                  style:AppTextStyle.setpoppinsTextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Color(0XFF7E92A2)),

                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 12.h,
                                ),
                                child: Text(
                                  user['email'],
                                  style:AppTextStyle.setpoppinsTextStyle(fontSize: 8, fontWeight: FontWeight.w500, color: Color(0XFF7E92A2)),

                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 12.h,
                                ),
                                child: Text(
                                  user['role'] ?? '—',
                                  style:AppTextStyle.setpoppinsTextStyle(fontSize: 8, fontWeight: FontWeight.w500, color: Color(0XFF7E92A2))

                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 12.h,
                                ),
                                child: Text(
                                  formattedDate,
                                   style:AppTextStyle.setpoppinsTextStyle(fontSize: 8, fontWeight: FontWeight.w500, color: Color(0XFF7E92A2))

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(child: SvgPicture.asset('assets/svg/Component _edit.svg',width: 15.w,height: 15.h,)),
                                     SizedBox(width: 10.w,),
                                    InkWell(child: SvgPicture.asset('assets/svg/Component _delete.svg',width: 15.w,height: 15.h,) ,onTap: () async {
                                          await _showDeleteConfirmationDialog(context, user);
                                      }, ),
                                
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
),
          ],
        ),
      ),
   
    );
  }
}
