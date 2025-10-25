
import 'package:admin_app/config/router/router_transation.dart';
import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/featuer/Auth/view/Log_In_view.dart';
import 'package:admin_app/featuer/Auth/view/forget_password_view.dart';
import 'package:admin_app/featuer/Auth/view/send_otp_view.dart';
import 'package:admin_app/featuer/Auth/view/reset_password_view.dart';
import 'package:admin_app/featuer/home/view/home_Email_view.dart';
import 'package:admin_app/featuer/getAllRole/view/invitation_page.dart';
import 'package:admin_app/featuer/home/view/pages/Dashboard_page.dart';
import 'package:admin_app/featuer/role/roles_page.dart';
import 'package:admin_app/featuer/on_boarding/on_board_view.dart';
import 'package:admin_app/featuer/on_boarding/splash_Screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings settings){
    switch (settings.name) {
      case Routes.splashScreen:
        return RouterTransitions.build(SplashScreen());
        case Routes.onBoardView:
        return RouterTransitions.build(OnBoardView());
      case Routes.logInView:
        return RouterTransitions.buildFromBottom(LogInView());
      case Routes.forgetPassword:
        return RouterTransitions.buildFromBottom(ForgetPasswordView());
      case Routes.sendOtp:
        return RouterTransitions.buildFromBottom(SendOtpView(email: ''));
         case Routes.home:
        return RouterTransitions.buildFromBottom(HomeView());
       case Routes.resetPassword:
        return RouterTransitions.buildFromBottom(ResetPasswordView()); 
        case Routes.invitationPage:
        return   RouterTransitions.buildFromBottom(InvitationPage());
         case Routes.rolesPage:
        return   RouterTransitions.buildFromBottom(RolesPage());
         case Routes.dashboard:
        return   RouterTransitions.buildFromBottom(DashboardPage());
       
        default: 
        return RouterTransitions.build(Scaffold(
          body: Center(
            child: Text("No Route"),
          ),
        ));
    }
  }
}