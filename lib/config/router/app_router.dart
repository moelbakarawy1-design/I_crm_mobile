import 'package:admin_app/config/router/router_transation.dart';
import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/featuer/Auth/view/ChangePasswordView.dart';
import 'package:admin_app/featuer/Auth/view/Log_In_view.dart';
import 'package:admin_app/featuer/Auth/view/forget_password_view.dart';
import 'package:admin_app/AppLink/test_case.dart';
import 'package:admin_app/featuer/Auth/view/send_otp_view.dart';
import 'package:admin_app/featuer/Auth/view/reset_password_view.dart';
import 'package:admin_app/featuer/Task/view/screen/add_task_screen.dart';
import 'package:admin_app/featuer/Task/view/screen/edit_task_dialog.dart';
import 'package:admin_app/featuer/Task/view/screen/view_task_dialog.dart';
import 'package:admin_app/featuer/Task/view/task_screen_view.dart';
import 'package:admin_app/featuer/getAllRole/data/model/role_model.dart';
import 'package:admin_app/featuer/getAllRole/data/repo/invitation_repository.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_cubit.dart';
import 'package:admin_app/featuer/home/view/home_Email_view.dart';
import 'package:admin_app/featuer/getAllRole/view/invitation_page.dart';
import 'package:admin_app/featuer/home/view/pages/Dashboard_page.dart';
import 'package:admin_app/featuer/home/view/pages/setting_page.dart';
import 'package:admin_app/featuer/role/roles_page.dart';
import 'package:admin_app/featuer/on_boarding/on_board_view.dart';
import 'package:admin_app/featuer/on_boarding/splash_Screen.dart';
import 'package:admin_app/featuer/role/widget/create_role_page.dart';
import 'package:admin_app/featuer/role/widget/edit_role_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ✅ --- IMPORT CHAT MODEL WITH A PREFIX ---
import 'package:admin_app/featuer/chat/data/model/chat_model12.dart' as ChatModel;
import 'package:admin_app/featuer/chat/view/chat_view.dart';
import 'package:admin_app/featuer/chat/view/individual_screen.dart';
import 'package:admin_app/featuer/chat/view/pages/create_chatpage.dart';

// ✅ --- IMPORT TASK MODEL WITH A PREFIX ---
import 'package:admin_app/featuer/Task/data/model/getAllTask_model.dart' as TaskModel;


class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
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
      final token = settings.arguments as String;
        return RouterTransitions.buildFromBottom(ResetPasswordView(token: token ,));
      case Routes.invitationPage:
        return RouterTransitions.buildFromBottom(InvitationPage());
      case Routes.rolesPage:
        return RouterTransitions.buildFromBottom(
          BlocProvider(
            create: (context) =>
                InvitationCubit(InvitationRepository())..fetchRoles(),
            child: const RolesPage(),
          ),
        );
      case Routes.settingsPage:
        return RouterTransitions.buildFromBottom(SettingsPage());
      case Routes.changePasswordView:
        return RouterTransitions.buildFromBottom(ChangePasswordView());
      case Routes.editRolePage:
        final role = settings.arguments as RoleModel;
        return RouterTransitions.buildFromBottom(EditRolePage(
          role: role,
        ));

      case Routes.dashboard:
        return RouterTransitions.buildFromBottom(DashboardPage());
      case Routes.createRolePage:
        return RouterTransitions.buildFromBottom(CreateRolePage());
      case Routes.tokenHandlerPage:
        final token = settings.arguments as String;
        return RouterTransitions.buildFromBottom(TokenHandlerPage(
          token: token,
        ));
      case Routes.chatScreen:
        return RouterTransitions.buildFromBottom(ChatScreen());

      // ✅ --- FIX: Use the 'ChatModel' prefix ---
      case Routes.individualScreen:
        final chatModel = settings.arguments as ChatModel.Data;
        return RouterTransitions.buildFromBottom(
          IndividualScreen(
            chatModel: chatModel,
          ),
        );

      case Routes.tasksScreen:
        return RouterTransitions.buildFromBottom(TasksScreen());

      // ✅ --- FIX: Use the 'TaskModel' prefix ---
      case Routes.viewTaskDialog:
        final task = settings.arguments as TaskModel.TaskSummary;
        return RouterTransitions.buildFromBottom(ViewTaskDialog(
           task: task,
        ));

      // ✅ --- FIX: Use the 'TaskModel' prefix ---
      case Routes.editTaskDialog:
        final task = settings.arguments as TaskModel.TaskSummary;
        return RouterTransitions.buildFromBottom(EditTaskDialog(
          task: task,
        ));
        
      case Routes.addTaskDialog:
        return RouterTransitions.buildFromBottom(AddTaskDialog());
      case Routes.createChatScreen:
        return RouterTransitions.buildFromBottom(CreateChatScreen());
      default:
        if (settings.name != null &&
            settings.name!.startsWith('/') &&
            settings.name!.length > 60) {
          final String token = settings.name!.replaceFirst('/', '');
          return RouterTransitions.buildFromBottom(
              TokenHandlerPage(token: token));
        }
        return RouterTransitions.build(Scaffold(
          body: Center(
            child: Text("No Route"),
          ),
        ));
    }
  }
}