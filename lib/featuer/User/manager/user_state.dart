
import 'package:admin_app/featuer/User/data/model/getAllUser_model.dart';

abstract class GetAllUserState {}

class GetAllUserInitial extends GetAllUserState {}

class GetAllUserLoading extends GetAllUserState {}

class GetAllUserSuccess extends GetAllUserState {
  final GetAllUserModel userModel;
  GetAllUserSuccess(this.userModel);
}

class GetAllUserFailure extends GetAllUserState {
  final String message;
  GetAllUserFailure(this.message);
}
