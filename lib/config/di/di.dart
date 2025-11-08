import 'package:admin_app/featuer/Auth/data/repository/auth_repository.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_cubit.dart';
import 'package:admin_app/featuer/Task/data/repo/get_Task_repo.dart';
import 'package:admin_app/featuer/Task/manager/task_cubit.dart';
import 'package:admin_app/featuer/User/data/repo/get_all_user_repo.dart';
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'package:admin_app/core/network/api_helper.dart';
import 'package:admin_app/featuer/chat/data/repo/MessagesRepository.dart';
import 'package:admin_app/featuer/chat/manager/message_cubit.dart';
import 'package:admin_app/featuer/getAllRole/data/repo/invitation_repository.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    // API Helper
    getIt.registerLazySingleton<APIHelper>(() => APIHelper());

    // Auth
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
    getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));

    // Roles
    getIt.registerLazySingleton<InvitationRepository>(() => InvitationRepository());
    getIt.registerFactory<InvitationCubit>(() => InvitationCubit(getIt<InvitationRepository>()));

    // Messages
    getIt.registerLazySingleton<MessagesRepository>(() => MessagesRepository());
    getIt.registerFactory<MessagesCubit>(() => MessagesCubit(getIt<MessagesRepository>()));

    // Tasks
    getIt.registerLazySingleton<BaseTasksRepository>(() => TasksRepository(getIt<APIHelper>()));
    getIt.registerFactory<TaskCubit>(() => TaskCubit(getIt<BaseTasksRepository>()));

    // ✅ Add this missing repo registration
    getIt.registerLazySingleton<GetAllUserRepo>(() => GetAllUserRepo(getIt<APIHelper>()));

    // ✅ Then your cubit can use it safely
    getIt.registerFactory<GetAllUserCubit>(() => GetAllUserCubit(getIt<GetAllUserRepo>()));
  }
}
