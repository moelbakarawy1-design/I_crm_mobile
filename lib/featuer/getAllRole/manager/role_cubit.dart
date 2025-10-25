import 'package:admin_app/featuer/getAllRole/data/model/invitation_model.dart';
import 'package:admin_app/featuer/getAllRole/data/model/role_model.dart';
import 'package:admin_app/featuer/getAllRole/data/repo/invitation_repository.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvitationCubit extends Cubit<InvitationState> {
  final InvitationRepository _repository;
  List<RoleModel> _cachedRoles = [];

  InvitationCubit(this._repository) : super(InvitationInitial());

  // Get cached roles
  List<RoleModel> get roles => _cachedRoles;

  // Static method to get cubit from context
  static InvitationCubit get(context) => BlocProvider.of(context);

  // Fetch roles from API
  Future<void> fetchRoles() async {
    emit(RolesLoading());

    try {
      final response = await _repository.getRoles();
      if (response.status) {
        // Check if data exists and is a List
        if (response.data != null && response.data['data'] is List) {
          final rolesData = response.data['data'] as List;
    
          
          _cachedRoles = rolesData.map((role) {
            return RoleModel.fromJson(role);
          }).toList();
          
          
          // ignore: unused_local_variable
          for (final role in _cachedRoles) {
          }
          
          emit(RolesSuccess(_cachedRoles));
        } else {
          _cachedRoles = [];
          emit(RolesSuccess(_cachedRoles));
        }
      } else {
        emit(RolesFailure(response.message));
      }
    } catch (e) {

      emit(RolesFailure('Failed to fetch roles: $e'));
    }
  }

  // Send invitation
  Future<void> sendInvitation({
    required String name,
    required String email,
    required String roleName,
  }) async {
    emit(InvitationSending());

    try {
      final invitation = InvitationModel(
        name: name,
        email: email,
        role: roleName,
      );

      final response = await _repository.sendInvitation(invitation);

      if (response.status) {
        emit(InvitationSent(response.message));
      } else {
        emit(InvitationFailure(response.message));
      }
    } catch (e) {
      emit(InvitationFailure('Failed to send invitation: $e'));
    }
  }
}