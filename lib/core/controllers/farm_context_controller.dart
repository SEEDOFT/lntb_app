import 'package:get/get.dart';
import 'package:lntb_app/core/models/farm/farm_models.dart';
import 'package:lntb_app/core/models/farm/farm_task.dart';
import 'package:lntb_app/core/models/repository_state.dart';
import 'package:lntb_app/core/repositories/farm_repository.dart';

class FarmContextController extends GetxController {
  FarmContextController(this.repository);

  final FarmRepository repository;
  final farms = const RepositoryState<List<Farm>>.loading().obs;
  final dashboard = const RepositoryState<FarmDashboard>.loading().obs;
  final tasks = const RepositoryState<List<FarmTask>>.loading().obs;
  final selectedFarm = Rxn<Farm>();

  @override
  void onInit() {
    super.onInit();
    loadFarms();
  }

  Future<void> loadFarms() async {
    farms.value = const RepositoryState.loading();
    farms.value = await repository.getFarms();
    final available = farms.value.data;
    if (available != null && available.isNotEmpty) {
      await selectFarm(available.first);
    }
  }

  Future<void> selectFarm(Farm farm) async {
    selectedFarm.value = farm;
    await Future.wait([loadDashboard(), loadTasks()]);
  }

  Future<void> loadDashboard() async {
    final farm = selectedFarm.value;
    if (farm == null) return;
    dashboard.value = const RepositoryState.loading();
    dashboard.value = await repository.getDashboard(farm.id);
  }

  Future<void> loadTasks() async {
    final farm = selectedFarm.value;
    if (farm == null) return;
    tasks.value = const RepositoryState.loading();
    tasks.value = await repository.getTasks(farm.id);
  }
}
