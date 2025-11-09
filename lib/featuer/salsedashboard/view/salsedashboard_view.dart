import 'package:admin_app/core/widgets/CustomAppBar_widget.dart';
import 'package:flutter/material.dart';

class SalsedashboardView extends StatelessWidget {
  const SalsedashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Sales Dashboard',),
      body: Column(),
    );
  }
}