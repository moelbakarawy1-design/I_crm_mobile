import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/home/data/model/sales_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalesTable extends StatelessWidget {
  final List<SalesPerson> salesData;

  const SalesTable({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 330.w,
        height: 100.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Table Header
            _buildTableHeader(),
            // Table Rows
            ...salesData.map((person) => _buildTableRow(person)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.mainWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Name', 1),
          _buildHeaderCell('Total Calls', 2),
          _buildHeaderCell('Successful Calls', 3),
          _buildHeaderCell('Incomplete Calls', 4),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, int position) {
    return Expanded(
      flex: position == 1 ? 2 : 3,
      child: Text(
        text,
        style: AppTextStyle.setpoppinsSecondaryBlack(fontSize: 9, fontWeight: FontWeight.w300),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableRow(SalesPerson person) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(person.name, 1, isName: true),
          _buildDataCell(person.totalCalls.toString(), 2),
          _buildDataCell(person.successfulCalls.toString(), 3, isSuccess: true),
          _buildDataCell(person.incompleteCalls.toString(), 4, isIncomplete: true),
        ],
      ),
    );
  }

  Widget _buildDataCell(String text, int position, {bool isName = false, bool isSuccess = false, bool isIncomplete = false}) {
    Color textColor = Colors.grey[800]!;
    FontWeight fontWeight = FontWeight.normal;
    
    if (isName) {
      fontWeight = FontWeight.bold;
      textColor = Colors.blue[800]!;
    }
    
    if (isSuccess) {
      textColor = Colors.green[700]!;
    }
    
    if (isIncomplete) {
      textColor = Colors.orange[700]!;
    }

    return Expanded(
      flex: position == 1 ? 2 : 3,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: fontWeight,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}