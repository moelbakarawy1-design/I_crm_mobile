import 'package:admin_app/config/di/di.dart';
import 'package:admin_app/config/router/app_router.dart';
import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/network/api_helper.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_cubit.dart';
import 'package:admin_app/featuer/Task/manager/task_cubit.dart';
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'package:admin_app/featuer/chat/manager/message_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'featuer/getAllRole/manager/role_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding); 
  await LocalData.init();
  await DependencyInjection.init(); 
  await APIHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    
    return ScreenUtilInit(
    designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>(
                create: (context) => getIt<AuthCubit>(),
                 ),
             BlocProvider<InvitationCubit>(create:(context)=> getIt<InvitationCubit>(),

              ),
               BlocProvider<MessagesCubit>(
             create: (context) => getIt<MessagesCubit>(),
           ),
           BlocProvider<TaskCubit>(
              create: (context) => getIt<TaskCubit>(),
            ),
            BlocProvider<GetAllUserCubit>(
              create: (context) => getIt<GetAllUserCubit>(),
            ),
       
                      ],
          child: MaterialApp(
            onGenerateRoute: AppRouter().onGenerateRoute,
            initialRoute: Routes.splashScreen,
            debugShowCheckedModeBanner: false,
            title: 'Admin App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
            ),
          
          ),
        );
      },
    );
  }
}