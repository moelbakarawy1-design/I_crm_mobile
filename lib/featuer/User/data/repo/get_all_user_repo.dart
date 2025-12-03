import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/core/network/api_helper.dart';
import 'package:admin_app/core/network/api_response.dart';
import 'package:admin_app/featuer/User/data/model/getAllUser_model.dart';

class GetAllUserRepo {
  final APIHelper apiHelper;

  GetAllUserRepo(this.apiHelper);

  Future<ApiResponse> getAllUsers() async {
    try {
      final response = await apiHelper.getRequest(
        endPoint: EndPoints.getAllUsers,
      );

      return ApiResponse(
        status: response.status,
        statusCode: response.statusCode,
        data: response.data != null
            ? GetAllUserModel.fromJson(response.data)
            : null,
        message: response.message,
      );
    } catch (error) {
      return ApiResponse.fromError(error);
    }
  }

  Future<ApiResponse> updateUser({
    required String userId,
    String? name,
    String? email,
    String? roleId,
  }) async {
    try {
      final body = <String, dynamic>{};

      // Only add fields that are not null (i.e., have been changed)
      if (name != null) body["name"] = name;
      if (email != null) body["email"] = email;
      if (roleId != null) body["roleId"] = roleId;

      // Assuming 'EndPoints.users' is "users"
      final String endpoint = '${EndPoints.getAllUsers}/$userId';

      final response = await apiHelper.patchRequest(
        endPoint: endpoint,
        isFormData: false,
        data: body,
      );

      return ApiResponse(
        status: response.status,
        statusCode: response.statusCode,
        data: response.data,
        message: response.message,
      );
    } catch (error) {
      return ApiResponse.fromError(error);
    }
  }

  Future<ApiResponse> deleteUser(String userId) async {
    try {
      final String endpoint = '${EndPoints.getAllUsers}/$userId';

      final response = await apiHelper.deleteRequest(endPoint: endpoint);

      return ApiResponse(
        status: response.status,
        statusCode: response.statusCode,
        data: response.data,
        message: response.message,
      );
    } catch (error) {
      return ApiResponse.fromError(error);
    }
  }
}
