import 'package:admin_app/featuer/getAllRole/data/repo/invitation_repository.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:admin_app/featuer/Auth/data/repository/auth_repository.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_cubit.dart';

final GetIt getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    // AuthRepositories
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
    // AuthCubits
    getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
   // InvitationRepository
    getIt.registerLazySingleton<InvitationRepository>(()=>InvitationRepository());
    //InvitationCubit
   getIt.registerFactory<InvitationCubit>(() => InvitationCubit(getIt<InvitationRepository>()));


  }
}
