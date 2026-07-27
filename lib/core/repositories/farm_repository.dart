import 'package:dio/dio.dart';
import 'package:lntb_app/core/constants/api_endpoints.dart';
import 'package:lntb_app/core/models/farm/farm_log.dart';
import 'package:lntb_app/core/models/farm/farm_models.dart';
import 'package:lntb_app/core/models/farm/farm_task.dart';
import 'package:lntb_app/core/models/farm/harvest_record.dart';
import 'package:lntb_app/core/models/farm/ripeness_result.dart';
import 'package:lntb_app/core/models/farm/usage_summary.dart';
import 'package:lntb_app/core/models/repository_state.dart';
import 'package:lntb_app/core/network/api_client.dart';

class FarmRepository {
  FarmRepository(this._apiClient);

  final ApiClient _apiClient;

  List<dynamic> _list(Response response) =>
      ((response.data as Map<String, dynamic>)['data'] as List?) ?? const [];

  Map<String, dynamic> _item(Response response) =>
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;

  RepositoryState<T> _failure<T>(Object error) {
    if (error is DioException) {
      if (error.response?.statusCode == 404) {
        return const RepositoryState.unavailable();
      }
      if (error.response?.statusCode == 403) {
        return const RepositoryState(
          RepositoryStateType.authorizationFailure,
        );
      }
      if (error.response?.statusCode == 422) {
        return const RepositoryState(
          RepositoryStateType.validationFailure,
        );
      }
    }
    return RepositoryState.error(error.toString());
  }

  Future<RepositoryState<List<Farm>>> getFarms() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.farms);
      final farms = _list(response)
          .map((item) => Farm.fromJson(item as Map<String, dynamic>))
          .toList();
      return farms.isEmpty
          ? const RepositoryState.empty()
          : RepositoryState.data(farms);
    } catch (error) {
      return _failure(error);
    }
  }

  Future<RepositoryState<FarmDashboard>> getDashboard(int farmId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.farmDashboard(farmId),
      );
      return RepositoryState.data(FarmDashboard.fromJson(_item(response)));
    } catch (error) {
      return _failure(error);
    }
  }

  Future<RepositoryState<List<FarmTask>>> getTasks(int farmId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.farmTasks(farmId));
      final tasks = _list(response)
          .map((item) => FarmTask.fromJson(item as Map<String, dynamic>))
          .toList();
      return tasks.isEmpty
          ? const RepositoryState.empty()
          : RepositoryState.data(tasks);
    } catch (error) {
      return _failure(error);
    }
  }

  Future<void> createTask(
    int farmId, {
    required String title,
    String? description,
    DateTime? dueAt,
  }) =>
      _apiClient.post(
        ApiEndpoints.farmTasks(farmId),
        data: {
          'title': title,
          'description': description,
          'due_at': dueAt?.toIso8601String(),
        },
      );

  Future<void> updateTask(int farmId, int taskId, String action) =>
      _apiClient.patch(
        ApiEndpoints.farmTask(farmId, taskId),
        data: {'action': action},
      );

  Future<RepositoryState<List<SensorMetric>>> getTelemetry(int farmId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.farmLatestTelemetry(farmId),
      );
      final metrics = _list(response)
          .map((item) => SensorMetric.fromJson(item as Map<String, dynamic>))
          .toList();
      return metrics.isEmpty
          ? const RepositoryState.empty()
          : RepositoryState.data(metrics);
    } catch (error) {
      return _failure(error);
    }
  }

  Future<RepositoryState<List<UsageSummary>>> getUsage(int farmId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.farmUsage(farmId));
      final usage = _list(response)
          .map((item) => UsageSummary.fromJson(item as Map<String, dynamic>))
          .toList();
      return usage.isEmpty
          ? const RepositoryState.empty()
          : RepositoryState.data(usage);
    } catch (error) {
      return _failure(error);
    }
  }

  Future<RepositoryState<List<RipenessResult>>> getRipeness(int farmId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.farmRipeness(farmId));
      final results = _list(response)
          .map((item) => RipenessResult.fromJson(item as Map<String, dynamic>))
          .toList();
      return results.isEmpty
          ? const RepositoryState.empty()
          : RepositoryState.data(results);
    } catch (error) {
      return _failure(error);
    }
  }

  Future<RepositoryState<List<FarmLog>>> getLogs(int farmId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.farmLogs(farmId));
      final logs = _list(response)
          .map((item) => FarmLog.fromJson(item as Map<String, dynamic>))
          .toList();
      return logs.isEmpty
          ? const RepositoryState.empty()
          : RepositoryState.data(logs);
    } catch (error) {
      return _failure(error);
    }
  }

  Future<void> createLog(
    int farmId, {
    required String type,
    required String title,
    String? notes,
  }) =>
      _apiClient.post(
        ApiEndpoints.farmLogs(farmId),
        data: {'type': type, 'title': title, 'notes': notes},
      );

  Future<RepositoryState<List<HarvestRecord>>> getHarvests(int farmId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.farmHarvests(farmId));
      final records = _list(response)
          .map((item) => HarvestRecord.fromJson(item as Map<String, dynamic>))
          .toList();
      return records.isEmpty
          ? const RepositoryState.empty()
          : RepositoryState.data(records);
    } catch (error) {
      return _failure(error);
    }
  }

  Future<void> createHarvest(
    int farmId, {
    required double quantity,
    required String unit,
    String? grade,
    double? damagedQuantity,
  }) =>
      _apiClient.post(
        ApiEndpoints.farmHarvests(farmId),
        data: {
          'quantity': quantity,
          'unit': unit,
          'grade': grade,
          'damaged_quantity': damagedQuantity,
        },
      );

  Future<RepositoryState<String>> askAssistant(
    int farmId,
    String question,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.farmAssistant(farmId),
        data: {'question': question},
      );
      return RepositoryState.data(_item(response)['answer'] as String? ?? '');
    } catch (error) {
      return _failure(error);
    }
  }
}
