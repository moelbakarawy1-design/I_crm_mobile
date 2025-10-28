import 'package:admin_app/featuer/getAllRole/data/model/invitation_model.dart';
import 'package:admin_app/featuer/getAllRole/data/model/role_model.dart';
import 'package:admin_app/featuer/getAllRole/data/repo/invitation_repository.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvitationCubit extends Cubit<InvitationState> {
  final InvitationRepository _repository;
  List<RoleModel> _cachedRoles = [];

  InvitationCubit(this._repository) : super(InvitationInitial());

  List<RoleModel> get roles => _cachedRoles;

  static InvitationCubit get(context) => BlocProvider.of(context);

List<String> get allUniquePermissions {
    final Set<String> allPermissions = {};

    for (final role in _cachedRoles) {
      if (role.permissions != null) {
        allPermissions.addAll(role.permissions!);
      }
    }

    // 4. Convert back to a List and sort it alphabetically
    final sortedList = allPermissions.toList()..sort();
    
    return sortedList;
  }
Future<void> fetchRoles() async {
  emit(RolesLoading());

  try {
    final response = await _repository.getRoles();      
    if (response.status) {
      // Check if response.data is a List
      if (response.data != null && response.data is List) {
        final rolesData = response.data as List;
        
        _cachedRoles = rolesData.map((role) {
          return RoleModel.fromJson(role);
        }).toList();
        
        emit(RolesSuccess(_cachedRoles));
      
    
      } else if (response.data != null && response.data is Map && response.data['data'] is List) {
        
        final rolesData = response.data['data'] as List; 
        
         _cachedRoles = rolesData.map((role) {
          return RoleModel.fromJson(role);
        }).toList();
        
        emit(RolesSuccess(_cachedRoles));

      } else {
        _cachedRoles = [];
        emit(RolesSuccess(_cachedRoles));
      }
    } else {
      emit(RolesFailure(response.message ));
    }
  } catch (e) {
    print("--- 5. An ERROR occurred: $e ---"); // <-- ADD THIS
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
  Future<void> createRole({
    required String name,
    required List<String> permissions,
  }) async {
    emit(CreateRoleLoading());
    final response = await _repository.createRole(
      name: name,
      permissions: permissions,
    );
    if (response.status) {
      emit(CreateRoleSuccess());
      fetchRoles(); // Refresh the list after success
    } else {
      emit(CreateRoleFailure(response.message ));
    }
  }

  // --- NEW: Update Role ---
  Future<void> updateRole({
    required String roleId,
    required String name,
    required List<String> permissions,
  }) async {
    emit(UpdateRoleLoading());
    final response = await _repository.updateRole(
      roleId: roleId,
      name: name,
      permissions: permissions,
    );
    if (response.status) {
      emit(UpdateRoleSuccess());
      fetchRoles(); // Refresh the list after success
    } else {
      emit(UpdateRoleFailure(response.message ));
    }
  }

  // --- NEW: Delete Role ---
  Future<void> deleteRole({required String roleId}) async {
    emit(DeleteRoleLoading());
    final response = await _repository.deleteRole(roleId: roleId);
    if (response.status) {
      emit(DeleteRoleSuccess());
      fetchRoles(); // Refresh the list after success
    } else {
      emit(DeleteRoleFailure(response.message ));
    }
  }
}
