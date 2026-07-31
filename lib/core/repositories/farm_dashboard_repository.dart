import 'package:lntb_app/core/constants/api_endpoints.dart';
import 'package:lntb_app/core/models/farm_dashboard_models.dart';
import 'package:lntb_app/core/network/api_client.dart';

class FarmDashboardRepository {
  const FarmDashboardRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<FarmSummary>> getFarms() async {
    final response = await _apiClient.get(ApiEndpoints.farms);
    final payload = response.data as Map<String, dynamic>;

    return (payload['data'] as List? ?? const [])
        .map((item) => FarmSummary.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<FarmDashboard> getDashboard(int farmId) async {
    final response = await _apiClient.get(ApiEndpoints.farmDashboard(farmId));
    final payload = response.data as Map<String, dynamic>;

    return FarmDashboard.fromJson(payload['data'] as Map<String, dynamic>);
  }
}
