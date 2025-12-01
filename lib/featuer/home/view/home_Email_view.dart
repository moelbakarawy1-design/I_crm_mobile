import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/utils/responsive_layout.dart';
import 'package:admin_app/core/widgets/CustomAppBar_widget.dart';
import 'package:admin_app/featuer/home/view/pages/Dashboard_page.dart';
import 'package:admin_app/featuer/home/view/pages/profile_page.dart';
import 'package:admin_app/featuer/home/view/widget/cusstom_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> pages = [
    const DashboardPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.secondaryWhite,
      appBar: CustomAppBar(
        title: _getTitle(_currentIndex),
        // Open the right drawer (navigation)
        onMenuPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
      ),
      // Use 'endDrawer' for right-side navigation
      endDrawer: DrawerMenu(
        currentIndex: _currentIndex,
        onNavigate: _onItemTapped,
      ),
      body: pages[_currentIndex],
    );
  }

  Widget _buildTabletLayout() {
    return ScreenUtilInit(
      designSize: const Size(768, 1024), // Tablet Design Size
      builder: (context, child) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColor.secondaryWhite,
          appBar: CustomAppBar(
            title: _getTitle(_currentIndex),
            // Open the right drawer (navigation)
            onMenuPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          // Use 'endDrawer' for right-side navigation
          endDrawer: DrawerMenu(
            currentIndex: _currentIndex,
            onNavigate: _onItemTapped,
          ),
          body: pages[_currentIndex],
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return ScreenUtilInit(
      designSize: const Size(1440, 900), // Desktop Design Size
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColor.secondaryWhite,
          body: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Custom Header for Desktop if needed, or just the content
                    Container(
                      height: 60,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _getTitle(_currentIndex),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(child: pages[_currentIndex]),
                  ],
                ),
              ),
              // Permanent Drawer for Desktop (Right Side)
              SizedBox(
                width: 250,
                child: DrawerMenu(
                  currentIndex: _currentIndex,
                  onNavigate: _onItemTapped,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Profile';
      default:
        return '';
    }
  }
}