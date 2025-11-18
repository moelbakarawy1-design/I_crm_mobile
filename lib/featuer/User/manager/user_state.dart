import 'package:admin_app/featuer/User/data/model/getAllUser_model.dart';

import 'package:equatable/equatable.dart'; 

// 1. Extend Equatable so 'props' will work
abstract class GetAllUserState extends Equatable { 
  const GetAllUserState(); 

  // 2. Add the default props list
  @override
  List<Object> get props => [];
}

class GetAllUserInitial extends GetAllUserState {}

class GetAllUserLoading extends GetAllUserState {}

class GetAllUserSuccess extends GetAllUserState {
  final GetAllUserModel userModel;
  const GetAllUserSuccess(this.userModel);

  // 3. Add props for comparison
  @override
  List<Object> get props => [userModel];
}

class GetAllUserFailure extends GetAllUserState {
  final String message;
  const GetAllUserFailure(this.message);

  // 3. Add props for comparison
  @override
  List<Object> get props => [message];
}

// --- States for Update User ---
class UserUpdateLoading extends GetAllUserState {}

class UserUpdateSuccess extends GetAllUserState {
  final String message;
  const UserUpdateSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class UserUpdateFailure extends GetAllUserState {
  final String message;
  const UserUpdateFailure(this.message);

  @override
  List<Object> get props => [message];
}
class UserDeleteLoading extends GetAllUserState {}

class UserDeleteSuccess extends GetAllUserState {
  final String message;
  const UserDeleteSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class UserDeleteFailure extends GetAllUserState {
  final String message;
  const UserDeleteFailure(this.message);

  @override
  List<Object> get props => [message];
}
