import 'package:admin_app/config/di/di.dart';
import 'package:admin_app/config/router/app_router.dart';
import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'featuer/getAllRole/manager/role_cubit.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding); 
await LocalData.init();
  await DependencyInjection.init(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Remove the splash screen after the app is loaded
    FlutterNativeSplash.remove();
    
    return ScreenUtilInit(
   
    // Your design size (width, height)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>(
                create: (context) => getIt<AuthCubit>(),
                 ),
             BlocProvider<InvitationCubit>(create:(context)=> getIt<InvitationCubit>() )
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