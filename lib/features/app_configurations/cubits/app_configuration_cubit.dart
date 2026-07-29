import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/models/app_configuration.dart';
import 'package:dompet_app/features/app_configurations/repositories/app_configuration_repository.dart';

class AppConfigurationCubit extends Cubit<AppConfiguration?> {
  final AppConfigurationRepository _repository;
  AppConfigurationCubit(this._repository) : super(null);

  Future<void> init() async {
    if (state != null) return;
    final config = await _repository.getConfig();
    emit(config);
  }

  Future<void> update(AppConfiguration config) async {
    if (state == null) return;

    final currentConfig = state;

    emit(config);
    try {
      await _repository.updateConfig(config);
    } catch (e) {
      emit(currentConfig);
    }
  }
}
