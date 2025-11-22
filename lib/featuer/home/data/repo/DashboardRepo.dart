import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/core/network/api_helper.dart'; // Your existing helper
import 'package:admin_app/featuer/home/data/model/DashboardResponse.dart';

class DashboardRepository {
  final APIHelper _apiHelper = APIHelper();

  Future<DashboardData> getDashboardStats() async {
    final response = await _apiHelper.getRequest(
      endPoint: EndPoints.dashboard, // Use your BaseURL + this endpoint
    );

    if (response.status && response.data != null) {
      final dashboardRes = DashboardResponse.fromJson(response.data);
      if (dashboardRes.success == true && dashboardRes.data != null) {
        return dashboardRes.data!;
      } else {
        throw Exception(dashboardRes.message ?? "Failed to load data");
      }
    } else {
      throw Exception(response.message);
    }
  }
}