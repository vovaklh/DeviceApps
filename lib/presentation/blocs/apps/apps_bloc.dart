import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_apps/domain/repositories/apps_repository.dart';
import 'package:my_apps/domain/wrappers/application_wrapper.dart';
import 'package:my_apps/presentation/sort/sort_method.dart';

part 'apps_event.dart';
part 'apps_state.dart';
part 'apps_bloc.freezed.dart';

class AppsBloc extends Bloc<AppsEvent, AppsState> {
  final AppsRepository appsRepository;

  AppsBloc({required this.appsRepository}) : super(const AppsState.initial()) {
    on<GetAppsEvent>((_, emit) => _getApps(emit));
    on<SearchEvent>((event, emit) => _search(event.query, emit));
    on<SortEvent>((event, emit) => _sort(event.sortMethod, emit));
  }

  Future<void> _getApps(Emitter emit) async {
    try {
      emit(const AppsState.loading());

      final installedApps = await appsRepository.getInstalledApps();
      final systemApps = await appsRepository.getSystemApps();

      emit(AppsState.success(installedApps, systemApps));
    } catch (exception) {
      emit(AppsState.error(exception));
    }
  }

  Future<void> _search(String query, Emitter emit) async {
    try {
      final installedApps = await appsRepository.getInstalledApps();
      final systemApps = await appsRepository.getSystemApps();

      final filteredInstalledApps = installedApps
          .where((wrapper) => wrapper.application.appName
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
      final filteredSystemApps = systemApps
          .where((wrapper) => wrapper.application.appName
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();

      emit(AppsState.success(filteredInstalledApps, filteredSystemApps));
    } catch (exception) {
      emit(AppsState.error(exception));
    }
  }

  Future<void> _sort(SortMethod sortMethod, Emitter emit) async {
    try {
      final List<ApplicationWrapper> displayedInstalledApps = state.maybeMap(
        success: ((value) => value.installedApps),
        orElse: () => [],
      );
      final List<ApplicationWrapper> displayedSystemApps = state.maybeMap(
        success: ((value) => value.systemApps),
        orElse: () => [],
      );

      final sortedInstalledApps = sortMethod.sort(displayedInstalledApps);
      final sortedSystemApps = sortMethod.sort(displayedSystemApps);

      emit(AppsState.success(sortedInstalledApps, sortedSystemApps));
    } catch (exception) {
      emit(AppsState.error(exception));
    }
  }
}
