import 'package:admin_app/featuer/getAllRole/data/model/invitation_model.dart';
import 'package:admin_app/featuer/getAllRole/data/model/role_model.dart';
import 'package:admin_app/featuer/getAllRole/data/repo/invitation_repository.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvitationCubit extends Cubit<InvitationState> {
  final InvitationRepository _repository;
  List<RoleModel> _cachedRoles = [];

  InvitationCubit(this._repository) : super(InvitationInitial()) {
    print("--- InvitationCubit Initialized ---");
  }

  List<RoleModel> get roles => _cachedRoles;

  static InvitationCubit get(context) => BlocProvider.of(context);

  List<String> get allUniquePermissions {
    final Set<String> allPermissions = {};
    for (final role in _cachedRoles) {
      if (role.permissions != null) {
        allPermissions.addAll(role.permissions!);
      }
    }
    final sortedList = allPermissions.toList()..sort();
    return sortedList;
  }

  Future<void> fetchRoles() async {
    if (isClosed) return; // Safety check
    emit(RolesLoading());
    
    try {
      final response = await _repository.getRoles();

      // ✅ FIX: Check if closed after await
      if (isClosed) return;

      if (response.status) {
        if (response.data != null && response.data is List) {
          final rolesData = response.data as List;
          _cachedRoles = rolesData.map((role) => RoleModel.fromJson(role)).toList();
          emit(RolesSuccess(_cachedRoles));
        } else if (response.data != null && response.data is Map && response.data['data'] is List) {
          final rolesData = response.data['data'] as List;
          _cachedRoles = rolesData.map((role) => RoleModel.fromJson(role)).toList();
          emit(RolesSuccess(_cachedRoles));
        } else {
          _cachedRoles = [];
          emit(RolesSuccess(_cachedRoles));
        }
      } else {
        emit(RolesFailure(response.message));
      }
    } catch (e) {
      if (isClosed) return; // ✅ FIX: Check inside catch too
      emit(RolesFailure('Failed to fetch roles: $e'));
    }
  }

  // Send invitation
  Future<void> sendInvitation({
    required String name,
    required String email,
    required String roleName,
  }) async {
    if (isClosed) return;
    emit(InvitationSending());
    
    try {
      final invitation = InvitationModel(
        name: name,
        email: email,
        role: roleName,
      );
      final response = await _repository.sendInvitation(invitation);

      // ✅ FIX: Check if closed after await
      if (isClosed) return;

      if (response.status) {
        emit(InvitationSent(response.message));
      } else {
        emit(InvitationFailure(response.message));
      }
    } catch (e) {
      if (isClosed) return;
      emit(InvitationFailure('Failed to send invitation: $e'));
    }
  }

  // Create Role
  Future<void> createRole({
    required String name,
    required List<String> permissions,
  }) async {
    if (isClosed) return;
    emit(CreateRoleLoading());
    
    try {
      final response = await _repository.createRole(
        name: name,
        permissions: permissions,
      );

      // ✅ FIX: Check if closed after await
      if (isClosed) return;

      if (response.status) {
        emit(CreateRoleSuccess());
        // Note: fetchRoles handles its own isClosed checks internally now
        fetchRoles(); 
      } else {
        emit(CreateRoleFailure(response.message));
      }
    } catch (e) {
      if (isClosed) return;
      emit(CreateRoleFailure('An error occurred: $e'));
    }
  }

  // Update Role
  Future<void> updateRole({
    required String roleId,
    required String name,
    required List<String> permissions,
  }) async {
    if (isClosed) return;
    emit(UpdateRoleLoading());
    
    try {
      final response = await _repository.updateRole(
        roleId: roleId,
        name: name,
        permissions: permissions,
      );

      //  Check if closed after await
      if (isClosed) return;

      if (response.status) {
        emit(UpdateRoleSuccess());
        fetchRoles();
      } else {
        emit(UpdateRoleFailure(response.message));
      }
    } catch (e) {
      if (isClosed) return;
      
      emit(UpdateRoleFailure('An error occurred: $e'));
    }
  }

  // Delete Role
  Future<void> deleteRole({required String roleId}) async {
    if (isClosed) return;
    emit(DeleteRoleLoading());
    
    try {
      final response = await _repository.deleteRole(roleId: roleId);

      // ✅ FIX: Check if closed after await
      if (isClosed) return;

      if (response.status) {
        emit(DeleteRoleSuccess());
        fetchRoles();
      } else {
        emit(DeleteRoleFailure(response.message));
      }
    } catch (e) {
      if (isClosed) return;
      emit(DeleteRoleFailure('An error occurred: $e'));
    }
  }
}