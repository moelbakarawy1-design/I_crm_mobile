import 'package:admin_app/core/network/api_helper.dart';
import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/core/network/api_response.dart';
import 'package:admin_app/featuer/getAllRole/data/model/invitation_model.dart';

class InvitationRepository {
  final APIHelper _apiHelper;

  InvitationRepository({APIHelper? apiHelper})
      : _apiHelper = apiHelper ?? APIHelper();
 
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
  Future<ApiResponse> updateRole({

    required String roleId,

    required String name,

    required List<String> permissions,

  }) async {

    return await _apiHelper.patchRequest( // Or patchRequest if you use PATCH

      endPoint: '${EndPoints.getRoles}/$roleId', // e.g., '/roles/some-id'

      data: {

        'name': name,

        'permissions': permissions,

      },

      isFormData: false, // Send as JSON

      isAuthorized: true,

    );

  }
   // Delete Role

  Future<ApiResponse> deleteRole({required String roleId}) async {

    return await _apiHelper.deleteRequest(

      endPoint: '${EndPoints.getRoles}/$roleId', // e.g., '/roles/some-id'

      isAuthorized: true,

    );

  }
  Future<ApiResponse> createRole({

    required String name,

    required List<String> permissions,

  }) async {

    return await _apiHelper.postRequest(

      endPoint: EndPoints.getRoles, 

      data: {

        'name': name,

        'permissions': permissions,

      },

      isFormData: false, // Send as JSON

      isAuthorized: true,

    );

  }

}
