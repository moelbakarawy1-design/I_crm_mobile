import 'package:admin_app/featuer/User/data/repo/get_all_user_repo.dart';
import 'package:admin_app/featuer/User/manager/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAllUserCubit extends Cubit<GetAllUserState> {
  final GetAllUserRepo getAllUserRepo;

  GetAllUserCubit(this.getAllUserRepo) : super(GetAllUserInitial());

  Future<void> fetchAllUsers() async {
    emit(GetAllUserLoading());

    final response = await getAllUserRepo.getAllUsers();

    if (response.status && response.data != null) {
      emit(GetAllUserSuccess(response.data));
    } else {
      emit(GetAllUserFailure(response.message));
    }
  }

  Future<void> updateUser({
    required String userId,
    String? name,
    String? email,
    String? roleId,
  }) async {
    emit(UserUpdateLoading()); // Emit the update loading state

    final response = await getAllUserRepo.updateUser(
      userId: userId,
      name: name,
      email: email,
      roleId: roleId,
    );

    if (response.status) {
      emit(UserUpdateSuccess(response.message));
    } else {
      emit(UserUpdateFailure(response.message));
    }
  }

  Future<void> deleteUser(String userId) async {
    emit(UserDeleteLoading());

    final response = await getAllUserRepo.deleteUser(userId);

    if (response.status) {
      emit(UserDeleteSuccess(response.message));
      fetchAllUsers(); // refresh list
    } else {
      emit(UserDeleteFailure(response.message));
    }
  }
}
