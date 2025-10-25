import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final dynamic user;
  final Function() onDeleteConfirmed;

  const DeleteConfirmationDialog({
    super.key,
    required this.user,
    required this.onDeleteConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      
      backgroundColor: AppColor.mainWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        width: 417.w,
        height: 365.h,
        decoration: BoxDecoration(),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: [
          Center(child: SvgPicture.asset('assets/svg/componant_delet.svg')),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                'Are you sure you want to delete the entity',
                style:AppTextStyle.setpoppinsTextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0XFF526477)),
                 overflow: TextOverflow.ellipsis, // This will prevent text wrapping
                     maxLines: 1,
              ),
            ),
            SizedBox(height: 40.h),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [              
                SizedBox(width: 12.w),
               CustomButton(
                width: 370.w,
                height: 50.h,
                text: 'Delate',
                textColor: AppColor.mainWhite,
                backgroundColor: const Color(0XFFFF3C3C),
                onPressed: (){
                  Navigator.of(context).pop();// Close dialog first
                    onDeleteConfirmed();
                } 
               ),
               SizedBox(height: 12.h,),
                CustomButton(
                  width: 370.w,
                height: 50.h,
                text: 'Cancel',
                textColor: AppColor.mainWhite,
                backgroundColor: const Color(0XFF1570EF),
                onPressed: () => Navigator.pop(context),
               ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}