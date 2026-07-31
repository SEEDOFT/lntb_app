import 'package:lntb_app/core/constants/api_endpoints.dart';
import 'package:lntb_app/core/network/api_client.dart';

class AssistantRepository {
  const AssistantRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<String> ask({required int farmId, required String question}) async {
    final response = await _apiClient.post(
      ApiEndpoints.farmAssistant(farmId),
      data: {'question': question},
    );
    final payload = response.data as Map<String, dynamic>;
    final data = payload['data'] as Map<String, dynamic>? ?? const {};
    return data['answer'] as String? ?? '';
  }
}
