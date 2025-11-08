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
}
