import 'package:admin_app/core/network/api_helper.dart';
import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/core/network/api_response.dart';
import 'package:admin_app/featuer/getAllRole/data/model/invitation_model.dart';

class InvitationRepository {
  final APIHelper _apiHelper;

  InvitationRepository({APIHelper? apiHelper})
      : _apiHelper = apiHelper ?? APIHelper();
Future<void> debugRolesAPI() async {
    try {
      print('🔍 Debugging roles API...');
      final response = await _apiHelper.getRequest(
        endPoint: EndPoints.getRoles,
        isProtected: true,
      );
      
      print('🔍 Debug - Response status: ${response.status}');
      print('🔍 Debug - Response message: ${response.message}');
      print('🔍 Debug - Response data type: ${response.data?.runtimeType}');
      print('🔍 Debug - Full response data: ${response.data}');
      
      if (response.data != null && response.data is Map) {
        final data = response.data as Map;
        print('🔍 Debug - Data keys: ${data.keys}');
        
        if (data.containsKey('data')) {
          final rolesData = data['data'];
          print('🔍 Debug - Roles data type: ${rolesData.runtimeType}');
          print('🔍 Debug - Roles data: $rolesData');
          
          if (rolesData is List) {
            print('🔍 Debug - Number of roles: ${rolesData.length}');
            for (int i = 0; i < rolesData.length; i++) {
              print('🔍 Debug - Role $i: ${rolesData[i]}');
            }
          }
        }
      }
    } catch (e) {
      print('🔍 Debug - Error: $e');
    }
  }
  // Get all roles
  Future<ApiResponse> getRoles() async {
    try {
      final response = await _apiHelper.getRequest(
        endPoint: EndPoints.getRoles,
        isProtected: true,
      );
      return response;
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  // Send invitation
  Future<ApiResponse> sendInvitation(InvitationModel invitation) async {
    try {
      final response = await _apiHelper.postRequest(
        endPoint: EndPoints.sendInvite,
        data: invitation.toJson(),
        isFormData: false,
        isAuthorized: true,
      );
      return response;
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }
}