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
        endPoint: EndPoints.getAllUsers
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
}
