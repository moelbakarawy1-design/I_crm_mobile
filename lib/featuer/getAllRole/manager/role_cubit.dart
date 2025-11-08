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
    print("--- Getting allUniquePermissions ---");
    final Set<String> allPermissions = {};
    for (final role in _cachedRoles) {
      if (role.permissions != null) {
        allPermissions.addAll(role.permissions!);
      }
    }
    final sortedList = allPermissions.toList()..sort();
    print("--- Found ${sortedList.length} unique permissions ---");
    return sortedList;
  }

  Future<void> fetchRoles() async {
    print("--- 1. fetchRoles: Starting... ---");
    emit(RolesLoading());
    try {
      final response = await _repository.getRoles();
      print("--- 2. fetchRoles: API Response Status: ${response.status} ---");
      print("--- 3. fetchRoles: API Response Data: ${response.data} ---");
    if (isClosed) return;

      if (response.status) {
        if (response.data != null && response.data is List) {
          print("--- 4. fetchRoles: Data is a direct List. Parsing... ---");
          final rolesData = response.data as List;
          _cachedRoles = rolesData.map((role) => RoleModel.fromJson(role)).toList();
          emit(RolesSuccess(_cachedRoles));

        } else if (response.data != null && response.data is Map && response.data['data'] is List) {
          print("--- 4. fetchRoles: Data is a Map with a 'data' key. Parsing... ---");
          final rolesData = response.data['data'] as List; 
          _cachedRoles = rolesData.map((role) => RoleModel.fromJson(role)).toList();
          emit(RolesSuccess(_cachedRoles));

        } else {
          print("--- 4. fetchRoles: Data is null or not a recognized format. Emitting empty list. ---");
          _cachedRoles = [];
          emit(RolesSuccess(_cachedRoles));
        }
      } else {
        print("--- 4. fetchRoles: API returned status: false. Error: ${response.message} ---");
            if (isClosed) return;

        emit(RolesFailure(response.message ));
      }
    } catch (e) {
      // This 'catch' block handles failed refreshes or other exceptions
      print("--- 5. ❌ fetchRoles: An ERROR occurred: $e ---");
      emit(RolesFailure('Failed to fetch roles: $e'));
    }
  }

  // Send invitation
  Future<void> sendInvitation({
    required String name,
    required String email,
    required String roleName,
  }) async {
    print("--- 1. sendInvitation: Starting... (Email: $email, Role: $roleName) ---");
    emit(InvitationSending());
    try {
      final invitation = InvitationModel(
        name: name,
        email: email,
        role: roleName,
      );
      final response = await _repository.sendInvitation(invitation);
      print("--- 2. sendInvitation: API Response Status: ${response.status} ---");

      if (response.status) {
        print("--- 3. sendInvitation: Success. Message: ${response.message} ---");
        emit(InvitationSent(response.message ));
      } else {
        print("--- 3. ❌ sendInvitation: API returned status: false. Error: ${response.message} ---");
        emit(InvitationFailure(response.message ));
      }
    } catch (e) {
      print("--- 4. ❌ sendInvitation: An ERROR occurred: $e ---");
      emit(InvitationFailure('Failed to send invitation: $e'));
    }
  }

  // Create Role
  Future<void> createRole({
    required String name,
    required List<String> permissions,
  }) async {
    print("--- 1. createRole: Starting... (Name: $name) ---");
    emit(CreateRoleLoading());
    try {
      final response = await _repository.createRole(
        name: name,
        permissions: permissions,
      );
      print("--- 2. createRole: API Response Status: ${response.status} ---");

      if (response.status) {
        print("--- 3. createRole: Success. Refreshing roles list... ---");
        emit(CreateRoleSuccess());
        fetchRoles(); // Refresh the list after success
      } else {
        print("--- 3. ❌ createRole: API returned status: false. Error: ${response.message} ---");
        emit(CreateRoleFailure(response.message ));
      }
    } catch (e) {
      print("--- 4. ❌ createRole: An ERROR occurred: $e ---");
      emit(CreateRoleFailure('An error occurred: $e'));
    }
  }

  // Update Role
  Future<void> updateRole({
    required String roleId,
    required String name,
    required List<String> permissions,
  }) async {
    print("--- 1. updateRole: Starting... (ID: $roleId, Name: $name) ---");
    emit(UpdateRoleLoading());
    try {
      final response = await _repository.updateRole(
        roleId: roleId,
        name: name,
        permissions: permissions,
      );
      print("--- 2. updateRole: API Response Status: ${response.status} ---");

      if (response.status) {
        print("--- 3. updateRole: Success. Refreshing roles list... ---");
        emit(UpdateRoleSuccess());
        fetchRoles(); // Refresh the list after success
      } else {
        print("--- 3. ❌ updateRole: API returned status: false. Error: ${response.message} ---");
        emit(UpdateRoleFailure(response.message ));
      }
    } catch (e) {
      print("--- 4. ❌ updateRole: An ERROR occurred: $e ---");
      emit(UpdateRoleFailure('An error occurred: $e'));
    }
  }

  // Delete Role
  Future<void> deleteRole({required String roleId}) async {
    print("--- 1. deleteRole: Starting... (ID: $roleId) ---");
    emit(DeleteRoleLoading());
    try {
      final response = await _repository.deleteRole(roleId: roleId);
      print("--- 2. deleteRole: API Response Status: ${response.status} ---");

      if (response.status) {
        print("--- 3. deleteRole: Success. Refreshing roles list... ---");
        emit(DeleteRoleSuccess());
        fetchRoles(); // Refresh the list after success
      } else {
        print("--- 3. ❌ deleteRole: API returned status: false. Error: ${response.message} ---");
        emit(DeleteRoleFailure(response.message ));
      }
    } catch (e) {
      print("--- 4. ❌ deleteRole: An ERROR occurred: $e ---");
      emit(DeleteRoleFailure('An error occurred: $e'));
    }
  }
}