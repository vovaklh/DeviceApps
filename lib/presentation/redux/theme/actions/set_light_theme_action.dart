import 'package:async_redux/async_redux.dart';
import 'package:device_apps/core/di/locator.dart';
import 'package:device_apps/data/datasources/local/shared_prefs.dart';
import 'package:device_apps/presentation/redux/app_state.dart';
import 'package:device_apps/presentation/themes/adaptive_theme/app_theme_mode.dart';

class SetLightThemeAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    await locator<SharedPrefs>().setThemeMode(AppThemeMode.light);
    return state.copyWith(themeMode: AppThemeMode.light);
  }
}
