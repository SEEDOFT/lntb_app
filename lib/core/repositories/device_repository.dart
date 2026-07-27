import 'package:lntb_app/core/constants/api_endpoints.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/network/api_client.dart';

class DeviceRepository {
  DeviceRepository(this._apiClient);

  final ApiClient _apiClient;

  Map<String, dynamic> _resource(dynamic response) {
    final payload = response.data as Map<String, dynamic>;
    return payload['data'] as Map<String, dynamic>;
  }

  Future<List<DeviceModel>> getDevices() async {
    final response = await _apiClient.get(ApiEndpoints.devices);
    final payload = response.data as Map<String, dynamic>;
    final devices = payload['data'] as List;
    return devices
        .map((item) => DeviceModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<DeviceModel> claimDevice({
    required String macAddress,
    required String claimCode,
    String? name,
  }) async {
    final response = await _apiClient.post(
      '${ApiEndpoints.devices}/claim',
      data: {
        'mac_address': macAddress,
        'claim_code': claimCode,
        if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
      },
    );
    return DeviceModel.fromJson(_resource(response));
  }

  Future<List<ControlRecord>> getControlHistory({int? deviceId}) async {
    final endpoint = deviceId == null
        ? ApiEndpoints.controls
        : ApiEndpoints.deviceControls(deviceId);
    final response = await _apiClient.get(endpoint);
    final payload = response.data as Map<String, dynamic>;
    final controls = payload['data'] as List;
    return controls
        .map((item) => ControlRecord.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ControlRecord> sendControl(
    int deviceId,
    String controlType,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.deviceControls(deviceId),
      data: {
        'control_type': controlType,
        'control_data': <String, dynamic>{},
      },
    );
    return ControlRecord.fromJson(_resource(response));
  }

  Future<List<DeviceAccess>> getSharedUsers(int deviceId) async {
    final response = await _apiClient.get(ApiEndpoints.deviceUsers(deviceId));
    final payload = response.data as Map<String, dynamic>;
    final records = payload['data'] as List;
    return records
        .map((item) => DeviceAccess.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> grantAccess(int deviceId, String identity) async {
    await _apiClient.post(
      ApiEndpoints.deviceUsers(deviceId),
      data: {'login': identity.trim()},
    );
  }

  Future<void> revokeAccess(int deviceId, int accessId) async {
    await _apiClient.delete(
      '${ApiEndpoints.deviceUsers(deviceId)}/$accessId',
    );
  }
}
