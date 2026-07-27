import 'package:lntb_app/core/constants/api_endpoints.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/network/api_client.dart';

class AccountRepository {
  AccountRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<AppUser> getCurrentUser() async {
    final response = await _apiClient.get(ApiEndpoints.me);
    final payload = response.data as Map<String, dynamic>;
    return AppUser.fromJson(payload['data'] as Map<String, dynamic>);
  }
}
