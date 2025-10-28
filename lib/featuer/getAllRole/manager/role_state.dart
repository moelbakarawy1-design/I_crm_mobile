import 'package:admin_app/featuer/getAllRole/data/model/role_model.dart';
import 'package:equatable/equatable.dart';
abstract class InvitationState extends Equatable {
  const InvitationState();

  @override
  List<Object?> get props => [];
}

class InvitationInitial extends InvitationState {}

// Roles States
class RolesLoading extends InvitationState {}

class RolesSuccess extends InvitationState {
  final List<RoleModel> roles;

  const RolesSuccess(this.roles);

  @override
  List<Object?> get props => [roles];
}

class RolesFailure extends InvitationState {
  final String errorMessage;

  const RolesFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

// Invitation States
class InvitationSending extends InvitationState {}

class InvitationSent extends InvitationState {
  final String message;

  const InvitationSent(this.message);

  @override
  List<Object?> get props => [message];
}

class InvitationFailure extends InvitationState {
  final String errorMessage;

  const InvitationFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
class CreateRoleLoading extends InvitationState {}
class CreateRoleSuccess extends InvitationState {}
class CreateRoleFailure extends InvitationState {
  final String errorMessage;
  const CreateRoleFailure(this.errorMessage);
}
// --- Update Role States ---
class UpdateRoleLoading extends InvitationState {}
class UpdateRoleSuccess extends InvitationState {}
class UpdateRoleFailure extends InvitationState {
  final String errorMessage;
  const UpdateRoleFailure(this.errorMessage);
}
// --- Delete Role States ---
class DeleteRoleLoading extends InvitationState {}
class DeleteRoleSuccess extends InvitationState {}
class DeleteRoleFailure extends InvitationState {
  final String errorMessage;
  const DeleteRoleFailure(this.errorMessage);
}